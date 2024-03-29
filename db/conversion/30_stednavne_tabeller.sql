-- Køretid ca. 6:30 minutter
-- Sikkerhedskopi:
-- SELECT * INTO stednavne_udstil.stednavn_udstilling_2015_03_25 FROM stednavne_udstil.stednavn_udstilling;
-- Opret resultattabel til lagring af stednavne
DROP TABLE IF EXISTS stednavne_udstil.stednavn_udstilling;
CREATE TABLE stednavne_udstil.stednavn_udstilling
(
    objectid             integer NOT NULL,
    id_lokalid           character varying,
    navnefoelgenummer    integer,
    navnestatus          character varying,
    skrivemaade          character varying,
    sprog                character varying,
    type                 character varying,
    subtype              character varying,
    subtype_presentation character varying,
    geometri             geometry(Geometry, 25832),
    geometri_udtyndet    geometry(Geometry, 25832),
    praesentation        character varying,
    area                 float,
    CONSTRAINT stednavn_udstilling_pkey PRIMARY KEY (objectid, navnefoelgenummer)
);

-- Ingen dubletter mere
-- WITH dubletter AS --4:10
--  (select distinct objectid, navnefoelgenummer from stednavne_udstil.vw_stednavn WHERE objectid IN 
--  (select objectid from stednavne_udstil.vw_stednavn group by objectid, navnefoelgenummer having count(1)>1))

-- 1:50
INSERT INTO stednavne_udstil.stednavn_udstilling (objectid, id_lokalid, navnefoelgenummer, navnestatus, skrivemaade,
                                                  sprog, type, subtype, geometri, area)
SELECT s.objectid,
       s.id_lokalid,
       s.navnefoelgenummer,
       s.navnestatus,
       s.skrivemaade,
       s.sprog,
       s.type,
       btrim(s.subtype),
       s.geometri,
       st_area(s.geometri)
FROM stednavne_udstil.vw_stednavn s
WHERE st_isvalid(s.geometri);

CREATE INDEX stednavn_udstilling_type_idx ON stednavne_udstil.stednavn_udstilling (type, subtype);
CREATE INDEX stednavn_udstilling_subtype_idx ON stednavne_udstil.stednavn_udstilling (subtype, type);
CREATE INDEX stednavn_udstilling_type_presentation_idx ON stednavne_udstil.stednavn_udstilling (type, praesentation);
CREATE INDEX stednavn_udstilling_type_geom_idx ON stednavne_udstil.stednavn_udstilling USING gist (geometri);

-- Opdater subtype_presentation
UPDATE stednavne_udstil.stednavn_udstilling
SET subtype_presentation = COALESCE(st.subtype_presentation, st.subtype)
FROM stednavne_udstil.subtype_translation st
where stednavne_udstil.stednavn_udstilling.subtype = st.subtype;

-- Slet dublerede forekomster (Samme objekt og en uofficiel stavemaade der er magen til)
DELETE
FROM stednavne_udstil.stednavn_udstilling
WHERE navnestatus = 'uofficielt'
  AND objectid IN
      (
          SELECT objectid
          FROM stednavne_udstil.stednavn_udstilling
          WHERE navnestatus = 'uofficielt'
            AND EXISTS
              (SELECT '1'
               FROM stednavne_udstil.stednavn_udstilling s2
               WHERE s2.navnestatus = 'officielt'
                 AND s2.objectid = stednavne_udstil.stednavn_udstilling.objectid
                 AND s2.skrivemaade = stednavne_udstil.stednavn_udstilling.skrivemaade)
      );

-- 2015-09-22/Christian: Slet stednavne med geometrier, der er GeometryCollection
DELETE
FROM stednavne_udstil.stednavn_udstilling s
WHERE st_geometrytype(s.geometri) = 'ST_GeometryCollection';

-- Opdater udyndet geometri 0:55
UPDATE stednavne_udstil.stednavn_udstilling
SET geometri_udtyndet =
        CASE
            WHEN length(ST_Astext(geometri)) < 5000 THEN
                geometri
            ELSE
                ST_SimplifyPreserveTopology(geometri,
                                            GREATEST(ST_Xmax(ST_Envelope(geometri)) - ST_Xmin(ST_Envelope(geometri)),
                                                     ST_Ymax(ST_Envelope(geometri)) - ST_Ymin(ST_Envelope(geometri))) /
                                            300)
            END;

-- Prioritetsmæssig opdatering af praesentation
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL;

-----------------
-- Bebyggelser --
-----------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'bebyggelse';
-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstil.stednavn_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 er kendte
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade
WHERE st_area(geometri) > 4000000
  AND type ilike 'bebyggelse'
  AND subtype ilike 'By'
  AND praesentation IS NULL;

-- Bydele i store byer > 10 km**2 128 sek
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (Bydel i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'bebyggelse' AND s2.subtype ilike 'By' AND s2.area > 10000000 AND
         s1.geometri_udtyndet && s2.geometri_udtyndet AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'bebyggelse'
  AND stednavne_udstil.stednavn_udstilling.subtype ilike 'Bydel'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Byer som ligger helt inde i et postnummerinddeling (25 sek)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (by i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND s.type ilike 'bebyggelse'
  AND s.subtype ilike 'By'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser som ligger helt inde i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND s.type ilike 'bebyggelse'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Begravelsespladser --
------------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'begravelsesplads';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'begravelsesplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'begravelsesplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Justeringer af praesentation (når typen oplagt fremgår af skrivemaade)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Begravelsesplads i ', '(')
WHERE type ilike 'begravelsesplads'
  AND praesentation ilike '%kirkegård%';

---------------
-- Bygninger --
---------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type = 'bygning';
-- Bygninger helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' ||
                    upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '') FROM 1 FOR 1)) ||
                    SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '') FROM 2 FOR
                              length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'bygning'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
UPDATE
    stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' ||
                    upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '') FROM 1 FOR 1)) ||
                    SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '') FROM 2 FOR
                              length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'bygning'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Justeringer af praesentation (når subtypen oplagt fremgår af skrivemaade)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE type ilike 'bygning'
  AND subtype ilike 'Akvarium';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, 'Akvarium (Akvarium i ', 'Akvariet (')
WHERE type ilike 'bygning'
  AND subtype ilike 'Akvarium';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, 'akvariet (Akvarium i ', 'Akvariet (')
WHERE type ilike 'bygning'
  AND subtype ilike 'Akvarium';

--------------------
-- Campingpladser --
--------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'campingplads';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'campingplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'campingplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Justeringer af praesentation (når typen oplagt fremgår af skrivemaade)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Campingplads i ', '(')
WHERE type ilike 'campingplads'
  AND praesentation ilike '%camping%';

-------------
-- Farvand --
-------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'farvand';
-- > 1500 km**2 er alment kendte
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade
WHERE area > 1500000000;
-- Farvande, der ligger helt inde i et andet farvand
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     stednavne_udstil.stednavn_udstilling s2 ON (s2.praesentation IS NOT NULL AND s2.type ilike 'farvand' AND
                                                 ST_contains(s2.geometri_udtyndet, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'farvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et farvand
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     stednavne_udstil.stednavn_udstilling s2 ON (s2.praesentation IS NOT NULL AND s2.type ilike 'farvand' AND
                                                 s2.geometri_udtyndet && s.geometri_udtyndet AND
                                                 st_area(st_intersection(s2.geometri_udtyndet, s.geometri_udtyndet)) >
                                                 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'farvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Fortidsminde --
------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'fortidsminde';
-- Fortidsminder i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'fortidsminde'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE st_geometrytype(stednavne_udstil.stednavn_udstilling.geometri_udtyndet) = 'ST_MultiPoint'
  AND stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'fortidsminde'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------
-- Friluftsbad --
-----------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'friluftsbad';
-- Fortidsminder i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'friluftsbad'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Justeringer af praesentation (når subtypen oplagt fremgår af skrivemaade)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Friluftsbad i ', '(')
WHERE type ilike 'friluftsbad'
  AND skrivemaade ilike '%friluftsbad%';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Friluftsbad i ', '(')
WHERE type ilike 'friluftsbad'
  AND skrivemaade ilike '%friluftbad%';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Friluftsbad i ', '(')
WHERE type ilike 'friluftsbad'
  AND skrivemaade ilike '%søbad%';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Friluftsbad i ', '(')
WHERE type ilike 'friluftsbad'
  AND skrivemaade ilike '%svømmebad%';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Friluftsbad i ', '(')
WHERE type ilike 'friluftsbad'
  AND skrivemaade ilike '%fribad%';

-----------------
-- Havnebassin --
-----------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'havnebassin';
-- Havnebassin i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'havnebassin'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Havnebassin,  > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'havnebassin'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--------------
-- Jernbane --
--------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'jernbane';
-- Jernbane i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'jernbane'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Jernbane,  > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'jernbane'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Landskabsform --
-------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'landskabsform';
-- Landskabsformer > 50 km**2
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND type ilike 'landskabsform'
  AND ST_Area(geometri_udtyndet) > 50000000;
-- Ø'er i store farvande
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type = 'farvand' AND s2.area > 400000000 AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ilike 'ø' OR
       stednavne_udstil.stednavn_udstilling.subtype ilike 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Ø'er i alle farvande
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'farvand' AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ilike 'ø' OR
       stednavne_udstil.stednavn_udstilling.subtype ilike 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Ø'er intersects alle farvande
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'farvand' AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_Intersects(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ilike 'ø' OR
       stednavne_udstil.stednavn_udstilling.subtype ilike 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- landskabsformer i postnummer
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'landskabsform'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Justeringer af praesentation (når subtypen oplagt fremgår af skrivemaade)
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Bakke i ', '(')
WHERE type ilike 'landskabsform'
  AND skrivemaade ilike '%Bakke%';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(Dal i ', '(')
WHERE type ilike 'landskabsform'
  AND skrivemaade ilike '%Dal%';

---------------
-- Lufthavne --
---------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'lufthavn';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'lufthavn';

----------------
-- Naturareal --
----------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'naturareal';
-- Naturareal i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'naturareal'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------------
-- Navigationsanlaeg --
-----------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'navigationsanlaeg';
-- Naturareal i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'navigationsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Restriktionsanlaeg --
------------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'restriktionsareal';
-- Restriktionsanlaeg i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'restriktionsareal'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'rute';
-- Rute
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE praesentation IS NULL
  AND type ilike 'rute';

------------------
-- Sevaerdighed --
------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'sevaerdighed';
-- Sevaerdighed i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'sevaerdighed'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Sevaerdighed,  > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'sevaerdighed'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Terraenkontur --
-------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'terraenkontur';
-- Terraenkontur i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'terraenkontur'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Terraenkontur,  > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'terraenkontur'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Urentfarvand --
------------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'urentfarvand';
-- Urentfarvand i store farvande
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'farvand' AND s2.area > 400000000 AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Urentfarvand i alle farvande
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'farvand' AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Urentfarvand, intersects
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.type ilike 'farvand' AND s1.geometri_udtyndet && s2.geometri_udtyndet AND
         ST_Intersects(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

--------------
-- Vandloeb --
--------------
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'vandloeb';
-- Vandloeb i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'vandloeb'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Vandloeb,  > 50 % i postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet AND
                                        st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) >
                                        0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'vandloeb'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------------
-- andentopografiflade --
-------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='andentopografiflade' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'andentopografiflade';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'andentopografiflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'andentopografiflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE praesentation IS NULL
  AND type ilike 'andentopografiflade';

-------------------------
-- andentopografipunkt --
-------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='andentopografipunkt' AND praesentation = NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'andentopografipunkt';

-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'andentopografipunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Juster broer
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(bro i ', '(')
WHERE type ilike 'andentopografipunkt'
  AND skrivemaade ilike '% bro%';
-- Juster kilder
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(kilde i ', '(')
WHERE type ilike 'andentopografipunkt'
  AND (skrivemaade ilike '%kilde %' OR skrivemaade ilike '%kilder %');

---------------------
-- faergerutelinje --
---------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='faergerutelinje' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'faergerutelinje';
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || '(' || subtype_presentation || ')'
WHERE type ilike 'faergerutelinje'
  AND praesentation IS NULL;

-------------------
-- idraetsanlaeg --
-------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='idraetsanlaeg' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'idraetsanlaeg';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'idraetsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'idraetsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Juster cykelbaner
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(cykelbane i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND skrivemaade ilike '%cykelbane%';
-- Juster golfklubber
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(golfbane i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND skrivemaade ilike '% golf%';
-- Juster travbaner og galopbaner
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(hestevæddeløbsbane i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND (skrivemaade ilike '%galopbane%' OR skrivemaade ilike '%travbane%');
-- Juster motocross baner
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(motocrossbane i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND (skrivemaade ilike '%motocross%');
-- Juster skydebane
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(skydebane i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND (skrivemaade ilike '%skydebane%' OR skrivemaade ilike '%skytteforening%');
-- Juster stadion
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(stadion i ', '(')
WHERE type ilike 'idraetsanlaeg'
  AND (skrivemaade ilike '%stadion%' OR skrivemaade ilike '%idrætsanlæg%' OR skrivemaade ilike '%idrætspark%');

---------
-- soe --
---------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='soe' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'soe';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 40 % i et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p
     ON (p.geometri && s.geometri_udtyndet AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.4 * s.area)
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'soe';
-- Juster Sø
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = replace(praesentation, '(sø i ', '(')
WHERE type ilike 'soe'
  AND (skrivemaade ilike '%sø');

---------------------
-- standsningssted --
---------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='standsningssted' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'standsningssted';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.type || ', ' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'standsningssted'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || type || ', ' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'standsningssted';

--------------------------
-- ubearbejdetnavnflade --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnflade' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'ubearbejdetnavnflade';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnflade';

--------------------------
-- ubearbejdetnavnlinje --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnlinje' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'ubearbejdetnavnlinje';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnlinje'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnlinje';

--------------------------
-- ubearbejdetnavnpunkt --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnpunkt' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'ubearbejdetnavnpunkt';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnpunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnpunkt';

--------------------------
-- vej --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='vej' AND praesentation IS NULL;
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = NULL
WHERE type ilike 'ubearbejdetnavnpunkt';
-- Helt indenfor et postnummerinddeling
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
         JOIN
     dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnpunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ilike 'ubearbejdetnavnpunkt';

--------------------------
-- Resterende stednavne --
--------------------------
-- I Jylland
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2 ON (s2.subtype ilike 'Halvø' AND s2.skrivemaade = 'Jylland' AND
                                                 ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- På store ø'er
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.subtype = 'Ø' AND s2.area > 50000000 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- På mindre ø'er
UPDATE stednavne_udstil.stednavn_udstilling
SET praesentation = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
         JOIN
     stednavne_udstil.stednavn_udstilling s2
     ON (s2.subtype = 'Ø' AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Alle andre får blot type/subtype
UPDATE
    stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || type || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND btrim(subtype_presentation) = '';
UPDATE
    stednavne_udstil.stednavn_udstilling
SET praesentation = skrivemaade || ' (' || type || ' / ' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.praesentation IS NULL
  AND btrim(subtype_presentation) <> '';

-- Tilføj og populer kommunefilter på tabellen
ALTER TABLE stednavne_udstil.stednavn_udstilling
    ADD COLUMN municipality_filter character varying;

UPDATE -- Opdater municipalityfilter på stednavne. ca. 11 minutter
    stednavne_udstil.stednavn_udstilling
SET municipality_filter = t.municipality_filter
FROM (SELECT s.objectid,
             s.navnefoelgenummer,
             array_to_string(array_agg(k.kommunekode::text), ' '::text) AS municipality_filter
      FROM stednavne_udstil.stednavn_udstilling s
               JOIN
           dagi_500.kommuneinddeling k ON (st_intersects(s.geometri, k.geometri))
      WHERE st_geometrytype(s.geometri) <> 'ST_GeometryCollection' -- undgå geometrycollections - det er en fejl de er i data
      GROUP BY s.objectid, s.navnefoelgenummer
     ) t
WHERE stednavne_udstil.stednavn_udstilling.objectid = t.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = t.navnefoelgenummer;