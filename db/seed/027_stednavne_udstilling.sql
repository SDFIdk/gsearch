-- Køretid ca. 6:30 minutter
-- Sikkerhedskopi:
-- SELECT * INTO stednavne_udstil.stednavn_udstilling_2015_03_25 FROM stednavne_udstil.stednavn_udstilling;
-- Opret resultattabel til lagring af stednavne

DROP TABLE IF EXISTS stednavne_udstil.stednavn_udstilling;


CREATE TABLE stednavne_udstil.stednavn_udstilling (objectid integer NOT NULL,
id_lokalid varchar, navnefoelgenummer integer, navnestatus varchar, skrivemaade varchar, sprog varchar, TYPE varchar, subtype varchar, subtype_presentation varchar, geometri geometry(Geometry,25832),
geometri_udtyndet geometry(Geometry,25832),
presentationstring varchar, area float, CONSTRAINT stednavn_udstilling_pkey PRIMARY KEY (objectid,
navnefoelgenummer));

-- Ingen dubletter mere
--WITH dubletter AS --4:10
--  (select distinct objectid, navnefoelgenummer from stednavne_udstil.stednavn_udstilling WHERE objectid IN
--  (select objectid from stednavne_udstil.stednavn_udstilling group by objectid, navnefoelgenummer having count(1)>1))
 -- 1:50

INSERT INTO stednavne_udstil.stednavn_udstilling (objectid, id_lokalid, navnefoelgenummer, navnestatus, skrivemaade, sprog, TYPE, subtype, geometri, area)
SELECT objectid,
       id_lokalid,
       navnefoelgenummer,
       navnestatus,
       skrivemaade,
       sprog,
       TYPE,
       btrim(subtype),
       geometri,
       st_area(geometri)
FROM stednavne.stednavne_udstilling s
WHERE st_isvalid(geometri);


CREATE INDEX stednavn_udstilling_type_idx ON stednavne_udstil.stednavn_udstilling (TYPE, subtype);


CREATE INDEX stednavn_udstilling_subtype_idx ON stednavne_udstil.stednavn_udstilling (subtype, TYPE);


CREATE INDEX stednavn_udstilling_type_presentation_idx ON stednavne_udstil.stednavn_udstilling (TYPE, presentationstring);


CREATE INDEX stednavn_udstilling_type_geom_idx ON stednavne_udstil.stednavn_udstilling USING gist (geometri);

-- Opdater subtype_presentation

UPDATE stednavne_udstil.stednavn_udstilling
SET subtype_presentation = COALESCE(st.subtype_presentation, st.subtype)
FROM stednavne_udstil.subtype_translation st
WHERE stednavne_udstil.stednavn_udstilling.subtype = st.subtype;

-- Slet dublerede forekomster (Samme objekt og en uofficiel stavemaade der er magen til)

DELETE
FROM stednavne_udstil.stednavn_udstilling
WHERE navnestatus = 'uofficielt'
  AND objectid IN
    (SELECT objectid
     FROM stednavne_udstil.stednavn_udstilling
     WHERE navnestatus='uofficielt'
       AND EXISTS
         (SELECT '1'
          FROM stednavne_udstil.stednavn_udstilling s2
          WHERE s2.navnestatus='officielt'
            AND s2.objectid=stednavne_udstil.stednavn_udstilling.objectid
            AND s2.skrivemaade = stednavne_udstil.stednavn_udstilling.skrivemaade) );

-- 2015-09-22/Christian: Slet stednavne med geometrier, der er GeometryCollection

DELETE
FROM stednavne_udstil.stednavn_udstilling s
WHERE st_geometrytype(s.geometri) = 'ST_GeometryCollection';

-- Opdater udyndet geometri 0:55

UPDATE stednavne_udstil.stednavn_udstilling
SET geometri_udtyndet = CASE
                            WHEN length(ST_Astext(geometri)) < 5000 THEN geometri
                            ELSE ST_SimplifyPreserveTopology(geometri, GREATEST(ST_Xmax(ST_Envelope(geometri)) - ST_Xmin(ST_Envelope(geometri)), ST_Ymax(ST_Envelope(geometri)) - ST_Ymin(ST_Envelope(geometri)))/300)
                        END;

-- Prioritetsmæssig opdatering af presentationstring

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL;

-----------------
-- Bebyggelser --
-----------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'bebyggelse';

-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstil.stednavn_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 er kendte

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade
WHERE st_area(geometri) > 4000000
  AND TYPE ILIKE 'bebyggelse'
  AND subtype ILIKE 'By'
  AND presentationstring IS NULL;

-- Bydele i store byer > 10 km**2 128 sek

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (Bydel i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'bebyggelse'
                                                 AND s2.subtype ILIKE 'By'
                                                 AND s2.area > 10000000
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'bebyggelse'
  AND stednavne_udstil.stednavn_udstilling.subtype ILIKE 'Bydel'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Byer som ligger helt inde i et postnummerinddeling (25 sec.)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (by i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND s.type ILIKE 'bebyggelse'
  AND s.subtype ILIKE 'By'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser som ligger helt inde i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND s.type ILIKE 'bebyggelse'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Begravelsespladser --
------------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'begravelsesplads';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'begravelsesplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'begravelsesplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af presentationstring (når typen oplagt fremgår af skrivemaade)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Begravelsesplads i ', '(')
WHERE TYPE ILIKE 'begravelsesplads'
  AND presentationstring ILIKE '%kirkegård%';

---------------
-- Bygninger --
---------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE='bygning';

-- Bygninger helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
                                                                  FROM 1
                                                                  FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
                                                                                       FROM 2
                                                                                       FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'bygning'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
                                                                  FROM 1
                                                                  FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
                                                                                       FROM 2
                                                                                       FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'bygning'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af presentationstring (når subtypen oplagt fremgår af skrivemaade)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE TYPE ILIKE 'bygning'
  AND subtype ILIKE 'Akvarium';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, 'Akvarium (Akvarium i ', 'Akvariet (')
WHERE TYPE ILIKE 'bygning'
  AND subtype ILIKE 'Akvarium';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, 'akvariet (Akvarium i ', 'Akvariet (')
WHERE TYPE ILIKE 'bygning'
  AND subtype ILIKE 'Akvarium';

--------------------
-- Campingpladser --
--------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'campingplads';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'campingplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'campingplads'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af presentationstring (når typen oplagt fremgår af skrivemaade)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Campingplads i ', '(')
WHERE TYPE ILIKE 'campingplads'
  AND presentationstring ILIKE '%camping%';

-------------
-- Farvand --
-------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'farvand';

-- > 1500 km**2 er alment kendte

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade
WHERE area > 1500000000;

-- Farvande, der ligger helt inde i et andet farvand

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.presentationstring IS NOT NULL
                                                 AND s2.type ILIKE 'farvand'
                                                 AND ST_contains(s2.geometri_udtyndet, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'farvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et farvand

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.presentationstring IS NOT NULL
                                                 AND s2.type ILIKE 'farvand'
                                                 AND s2.geometri_udtyndet && s.geometri_udtyndet
                                                 AND st_area(st_intersection(s2.geometri_udtyndet, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'farvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Fortidsminde --
------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'fortidsminde';

-- Fortidsminder i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'fortidsminde'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE st_geometrytype(stednavne_udstil.stednavn_udstilling.geometri_udtyndet) = 'ST_MultiPoint'
  AND stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'fortidsminde'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------
-- Friluftsbad --
-----------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'friluftsbad';

-- Fortidsminder i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'friluftsbad'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af presentationstring (når subtypen oplagt fremgår af skrivemaade)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Friluftsbad i ', '(')
WHERE TYPE ILIKE 'friluftsbad'
  AND skrivemaade ILIKE '%friluftsbad%';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Friluftsbad i ', '(')
WHERE TYPE ILIKE 'friluftsbad'
  AND skrivemaade ILIKE '%friluftbad%';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Friluftsbad i ', '(')
WHERE TYPE ILIKE 'friluftsbad'
  AND skrivemaade ILIKE '%søbad%';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Friluftsbad i ', '(')
WHERE TYPE ILIKE 'friluftsbad'
  AND skrivemaade ILIKE '%svømmebad%';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Friluftsbad i ', '(')
WHERE TYPE ILIKE 'friluftsbad'
  AND skrivemaade ILIKE '%fribad%';

-----------------
-- Havnebassin --
-----------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'havnebassin';

-- Havnebassin i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'havnebassin'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin,  > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'havnebassin'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--------------
-- Jernbane --
--------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'jernbane';

-- Jernbane i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'jernbane'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Jernbane,  > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'jernbane'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Landskabsform --
-------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'landskabsform';

-- Landskabsformer > 50 km**2

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND TYPE ILIKE 'landskabsform'
  AND ST_Area(geometri_udtyndet) > 50000000;

-- Ø'er i store farvande

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type = 'farvand'
                                                 AND s2.area > 400000000
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet)) 
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ILIKE 'ø'
       OR stednavne_udstil.stednavn_udstilling.subtype ILIKE 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er i alle farvande

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'farvand'
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet)) 
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ILIKE 'ø'
       OR stednavne_udstil.stednavn_udstilling.subtype ILIKE 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er intersects alle farvande

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'farvand'
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_Intersects(s2.geometri_udtyndet, s1.geometri_udtyndet)) 
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'landskabsform'
  AND (stednavne_udstil.stednavn_udstilling.subtype ILIKE 'ø'
       OR stednavne_udstil.stednavn_udstilling.subtype ILIKE 'øgruppe')
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- landskabsformer i postnummer

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'landskabsform'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af presentationstring (når subtypen oplagt fremgår af skrivemaade)

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Bakke i ', '(')
WHERE TYPE ILIKE 'landskabsform'
  AND skrivemaade ILIKE '%Bakke%';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(Dal i ', '(')
WHERE TYPE ILIKE 'landskabsform'
  AND skrivemaade ILIKE '%Dal%';

---------------
-- Lufthavne --
---------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'lufthavn';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'lufthavn';

----------------
-- Naturareal --
----------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'naturareal';

-- Naturareal i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'naturareal'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------------
-- Navigationsanlaeg --
-----------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'navigationsanlaeg';

-- Naturareal i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'navigationsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Restriktionsanlaeg --
------------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'restriktionsareal';

-- Restriktionsanlaeg i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'restriktionsareal'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'rute';

-- Rute

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE presentationstring IS NULL
  AND TYPE ILIKE 'rute';

------------------
-- Sevaerdighed --
------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'sevaerdighed';

-- Sevaerdighed i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'sevaerdighed'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Sevaerdighed,  > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'sevaerdighed'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Terraenkontur --
-------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'terraenkontur';

-- Terraenkontur i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'terraenkontur'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Terraenkontur,  > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'terraenkontur'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Urentfarvand --
------------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'urentfarvand';

-- Urentfarvand i store farvande

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'farvand'
                                                 AND s2.area > 400000000
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand i alle farvande

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'farvand'
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand, intersects

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.type ILIKE 'farvand'
                                                 AND s1.geometri_udtyndet && s2.geometri_udtyndet
                                                 AND ST_Intersects(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'urentfarvand'
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

--------------
-- Vandloeb --
--------------

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'vandloeb';

-- Vandloeb i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'vandloeb'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Vandloeb,  > 50 % i postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, st_envelope(s.geometri_udtyndet))) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'vandloeb'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------------
-- andentopografiflade --
-------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='andentopografiflade' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'andentopografiflade';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'andentopografiflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'andentopografiflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE presentationstring IS NULL
  AND TYPE ILIKE 'andentopografiflade';

-------------------------
-- andentopografipunkt --
-------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='andentopografipunkt' AND presentationstring = NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'andentopografipunkt';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'andentopografipunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Juster broer

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(bro i ', '(')
WHERE TYPE ILIKE 'andentopografipunkt'
  AND skrivemaade ILIKE '% bro%';

-- Juster kilder

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(kilde i ', '(')
WHERE TYPE ILIKE 'andentopografipunkt'
  AND (skrivemaade ILIKE '%kilde %'
       OR skrivemaade ILIKE '%kilder %');

---------------------
-- faergerutelinje --
---------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='faergerutelinje' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'faergerutelinje';


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || '(' || subtype_presentation || ')'
WHERE TYPE ILIKE 'faergerutelinje'
  AND presentationstring IS NULL;

-------------------
-- idraetsanlaeg --
-------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='idraetsanlaeg' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'idraetsanlaeg';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'idraetsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'idraetsanlaeg'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Juster cykelbaner

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(cykelbane i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND skrivemaade ILIKE '%cykelbane%';

-- Juster golfklubber

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(golfbane i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND skrivemaade ILIKE '% golf%';

-- Juster travbaner og galopbaner

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(hestevæddeløbsbane i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND (skrivemaade ILIKE '%galopbane%'
       OR skrivemaade ILIKE '%travbane%');

-- Juster motocross baner

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(motocrossbane i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND (skrivemaade ILIKE '%motocross%');

-- Juster skydebane

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(skydebane i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND (skrivemaade ILIKE '%skydebane%'
       OR skrivemaade ILIKE '%skytteforening%');

-- Juster stadion

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(stadion i ', '(')
WHERE TYPE ILIKE 'idraetsanlaeg'
  AND (skrivemaade ILIKE '%stadion%'
       OR skrivemaade ILIKE '%idrætsanlæg%'
       OR skrivemaade ILIKE '%idrætspark%');

---------
-- soe --
---------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='soe' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'soe';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.5*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
                                        AND st_area(st_intersection(p.geometri, s.geometri_udtyndet)) > 0.4*s.area)
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'soe'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'soe';

-- Juster Sø

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = replace(presentationstring, '(sø i ', '(')
WHERE TYPE ILIKE 'soe'
  AND (skrivemaade ILIKE '%sø');

---------------------
-- standsningssted --
---------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='standsningssted' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'standsningssted';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.type || ', ' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'standsningssted'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || TYPE || ', ' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'standsningssted';

--------------------------
-- ubearbejdetnavnflade --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnflade' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'ubearbejdetnavnflade';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnflade'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnflade';

--------------------------
-- ubearbejdetnavnlinje --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnlinje' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'ubearbejdetnavnlinje';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnlinje'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnlinje';

--------------------------
-- ubearbejdetnavnpunkt --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='ubearbejdetnavnpunkt' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'ubearbejdetnavnpunkt';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnpunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnpunkt';

--------------------------
-- vej --
--------------------------
-- SELECT * from stednavne_udstil.stednavn_udstilling where type='vej' AND presentationstring IS NULL;

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = NULL
WHERE TYPE ILIKE 'ubearbejdetnavnpunkt';

-- Helt indenfor et postnummerinddeling

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM stednavne_udstil.stednavn_udstilling s
JOIN dagi_500.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnpunkt'
  AND stednavne_udstil.stednavn_udstilling.objectid = s.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.type ILIKE 'ubearbejdetnavnpunkt';

--------------------------
-- Resterende stednavne --
--------------------------
-- I Jylland

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.subtype ILIKE 'Halvø'
                                                 AND s2.skrivemaade = 'Jylland'
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- På store ø'er

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.subtype='Ø'
                                                 AND s2.area > 50000000
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- På mindre ø'er

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM stednavne_udstil.stednavn_udstilling s1
JOIN stednavne_udstil.stednavn_udstilling s2 ON (s2.subtype='Ø'
                                                 AND ST_contains(s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND stednavne_udstil.stednavn_udstilling.objectid = s1.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Alle andre får blot type/subtype

UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || TYPE || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND btrim(subtype_presentation) = '' ;


UPDATE stednavne_udstil.stednavn_udstilling
SET presentationstring = skrivemaade || ' (' || TYPE || ' / ' || subtype_presentation || ')'
WHERE stednavne_udstil.stednavn_udstilling.presentationstring IS NULL
  AND btrim(subtype_presentation) <> '' ;

-- Tilføj og populer kommunefilter på tabellen

ALTER TABLE stednavne_udstil.stednavn_udstilling ADD COLUMN municipality_filter varchar;


UPDATE -- Opdater municipalityfilter på stednavne. ca. 11 minutter
stednavne_udstil.stednavn_udstilling
SET municipality_filter = t.municipality_filter
FROM
  (SELECT s.objectid,
          s.navnefoelgenummer,
          array_to_string(array_agg(k.kommunekode::text), ' '::text) AS municipality_filter
   FROM stednavne_udstil.stednavn_udstilling s
   JOIN dagi_500.kommuneinddeling k ON (st_intersects(s.geometri, k.geometri))
   WHERE st_geometrytype(s.geometri) <> 'ST_GeometryCollection' -- undgå geometrycollections - det er en fejl de er i data
GROUP BY s.objectid,
         s.navnefoelgenummer) t
WHERE stednavne_udstil.stednavn_udstilling.objectid = t.objectid
  AND stednavne_udstil.stednavn_udstilling.navnefoelgenummer = t.navnefoelgenummer;


