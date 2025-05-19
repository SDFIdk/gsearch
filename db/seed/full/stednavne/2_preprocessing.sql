-- Sikkerhedskopi:
-- SELECT * INTO stednavne_udstilling.stednavne_udstilling_2015_03_25 FROM stednavne_udstilling.stednavne_udstilling;
-- Opret resultattabel til lagring af stednavne
DROP TABLE IF EXISTS stednavne_udstilling.stednavne_udstilling;

CREATE TABLE stednavne_udstilling.stednavne_udstilling (
    objectid integer NOT NULL,
    id_lokalid varchar,
    navnefoelgenummer integer,
    navnestatus varchar,
    skrivemaade varchar,
    sprog varchar,
    TYPE varchar,
    subtype varchar,
    subtype_presentation varchar,
    kommunekode varchar,
    geometri geometry(Geometry,25832),
    geometri_udtyndet geometry(Geometry,25832),
    visningstekst varchar,
    visningstekst_uden_hjaelpetekst varchar,
    area float,
    CONSTRAINT stednavne_udstilling_pkey PRIMARY KEY (objectid, navnefoelgenummer)
);
-- Ingen dubletter mere
--WITH dubletter AS --4:10
--  (select distinct objectid, navnefoelgenummer from stednavne_udstilling.stednavne_udstilling WHERE objectid IN
--  (select objectid from stednavne_udstilling.stednavne_udstilling group by objectid, navnefoelgenummer having count(1)>1))
-- 1:50
INSERT
	INTO
	stednavne_udstilling.stednavne_udstilling (objectid,
	id_lokalid,
	navnefoelgenummer,
	navnestatus,
	skrivemaade,
	sprog,
	TYPE,
	subtype,
	geometri,
	area)
SELECT
	objectid,
	id_lokalid,
	navnefoelgenummer,
	navnestatus,
	skrivemaade,
	sprog,
	TYPE,
	btrim(subtype),
	geometri,
	st_area (geometri)
FROM
	stednavne_udstilling.stednavne_union s
WHERE
	st_isvalid (geometri);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE, subtype);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype, TYPE);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE, visningstekst);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling USING gist (geometri);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (skrivemaade);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (objectid);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (navnefoelgenummer);


-- Opdater subtype_presentation
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	subtype_presentation = COALESCE(st.subtype_presentation, st.subtype)
FROM
	stednavne_udstilling.subtype_translation st
WHERE
	stednavne_udstilling.stednavne_udstilling.subtype = st.subtype;

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype_presentation);


-- Slet dublerede forekomster (Samme objekt og en uofficiel stavemaade der er magen til)
DELETE
FROM
	stednavne_udstilling.stednavne_udstilling
WHERE
	navnestatus = 'uofficielt'
	AND objectid IN (
        SELECT
            objectid
        FROM
            stednavne_udstilling.stednavne_udstilling
        WHERE
            navnestatus = 'uofficielt'
            AND EXISTS (
                SELECT
                    '1'
                FROM
                    stednavne_udstilling.stednavne_udstilling s2
                WHERE
                    s2.navnestatus = 'officielt'
                    AND s2.objectid = stednavne_udstilling.stednavne_udstilling.objectid
                    AND s2.skrivemaade = stednavne_udstilling.stednavne_udstilling.skrivemaade)
    );
-- 2015-09-22/Christian: Slet stednavne med geometrier, der er GeometryCollection
DELETE
FROM
	stednavne_udstilling.stednavne_udstilling s
WHERE
	st_geometrytype (s.geometri) = 'ST_GeometryCollection';
-- Opdater udtyndet geometri
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	geometri_udtyndet = CASE WHEN length(ST_Astext (geometri)) < 5000
    THEN
        geometri
	ELSE
        ST_SimplifyPreserveTopology (geometri,
		GREATEST (ST_Xmax (ST_Envelope (geometri)) - ST_Xmin (ST_Envelope (geometri)),
		ST_Ymax (ST_Envelope (geometri)) - ST_Ymin (ST_Envelope (geometri))) / 300)
	END;

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling USING gist (geometri_udtyndet);


-- Prioritetsmæssig opdatering af visningstekst_uden_hjaelpetekst
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst_uden_hjaelpetekst = skrivemaade;

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst_uden_hjaelpetekst);

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;


-----------------
-- Christiansø --
-----------------
-- Vi er nødt til at starte med at få stednavne på Christiansø fixet, da de stednavne ellers ender med at få en hjælpetekst
-- som har Gudhjem, da Gudhjems postnummer geometri også indeholder Christiansø
SELECT 'Christiansø: ', now();

-- Stednavne der ligger helt indenfor Christiansø
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn = 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Stednavne, > 50% ligger indenfor Christiansø
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn = 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.5 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-----------------
-- Bebyggelser --
-----------------
SELECT 'Bebyggelser: ', now();

-- Bydele
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
        s2.type = 'bebyggelse'
		AND s2.subtype = 'by'
        AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.skrivemaade != s1.skrivemaade
		AND s2.geometri && s1.geometri
		AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
	stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Bydele, > 70 % inde i en by
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
    (
        s2.type = 'bebyggelse'
        AND s2.subtype = 'by'
        AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.geometri && s1.geometri
        AND st_area (st_intersection (s2.geometri, s1.geometri)) > 0.7 * s1.area
    )
WHERE
    stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Burde ikke blive brugt, men er her for en sikkerhedskyld
-- Bydele som ligger helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Burde ikke blive brugt, men er her for en sikkerhedskyld
-- Bydele, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
  AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
  AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
  AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Byer
-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstilling.stednavne_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 får en hjælpetekst med hvilken kommune de ligger i
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn != 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
  	AND stednavne_udstilling.stednavne_udstilling.subtype = 'by'
  	AND st_area (stednavne_udstilling.stednavne_udstilling.geometri) > 4000000
  	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Store byer > 4 km**2 > 90 % i en kommune får en hjælpetekst med hvilken kommune de ligger i
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
  	AND stednavne_udstilling.stednavne_udstilling.subtype = 'by'
  	AND st_area (stednavne_udstilling.stednavne_udstilling.geometri) > 4000000
  	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Byer som ligger helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.subtype = 'by'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- By, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
        p.navn != s.skrivemaade
	    AND p.geometri && s.geometri
		AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.subtype = 'by'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser
-- Bebyggelser som ligger helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
		AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser, > 40 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
		AND st_area (st_intersection (p.geometri, s.geometri)) > 0.4 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser, > helt indenfor kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn != 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 90 % i en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


------------------------
-- Begravelsespladser --
------------------------
SELECT 'Begravelsespladser: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'begravelsesplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'begravelsesplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


---------------
-- Bygninger --
---------------
SELECT 'Bygninger: ', now();

-- Bygninger helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bygninger, som ligger > 20 % indenfor et postnummerinddeling (Er for de bygninger der ligger i indre Koebenhavn
-- som overlapper lidt med mange postnummer geometrier, som tilhører Koebenhavns postnumre
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.2 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------
-- Campingpladser --
--------------------
SELECT 'Campingpladser: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------
-- Farvand --
-------------
SELECT 'Farvand: ', now();

-- Farvande, der ligger helt inde i et andet farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
	    AND s2.skrivemaade != s1.skrivemaade
	    AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- > 90 % i et farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
	    AND s2.skrivemaade != s1.skrivemaade
        AND s2.geometri && s1.geometri
        AND st_area (st_intersection (s2.geometri, s1.geometri)) > 0.9 * s1.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- > 50 % i et farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
	    AND s2.skrivemaade != s1.skrivemaade
        AND s2.geometri && s1.geometri
        AND st_area (st_intersection (s2.geometri, s1.geometri)) > 0.5 * s1.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON
    (
        p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri, s.geometri)) > 0.4 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 90 % i en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


------------------
-- Fortidsminde --
------------------
SELECT 'Fortidsminde: ', now();

-- Fortidsminder i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'fortidsminde'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
	)
WHERE
	st_geometrytype (stednavne_udstilling.stednavne_udstilling.geometri) = 'ST_MultiPoint'
	AND stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'fortidsminde'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-----------------
-- Friluftsbad --
-----------------
SELECT 'Friluftsbad: ', now();

-- Friluftsbad i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'friluftsbad'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-----------------
-- Havnebassin --
-----------------
SELECT 'Havnebassin: ', now();

-- Havnebassin i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin,  > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin, som ligger > 30 % indenfor et postnummerinddeling (er for de Havnebassiner der ligger i indre Koebenhavn
-- som overlapper lidt med mange postnummer geometrier, som tilhører Koebenhavns postnumre
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.3 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------
-- Jernbane --
--------------
SELECT 'Jernbane: ', now();

-- Jernbane i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'jernbane'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Jernbane,  > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'jernbane'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------------
-- Landskabsform --
-------------------
SELECT 'Landskabsform: ', now();

-- Ø'er i alle farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.geometri && s1.geometri
        AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND
        (
            stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
            OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe'
        )
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- > Ø'er der ligger 50 % i et farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
		s2.type = 'farvand'
		AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.geometri && s1.geometri
        AND st_area (st_intersection (s2.geometri, s1.geometri)) > 0.5 * s1.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND
        (
            stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
		    OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe'
        )
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- landskabsformer  postnummer
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Landskabsformer, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri,  s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Landskabsformer, > 40 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
	    p.navn != s.skrivemaade
        AND p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri,  s.geometri)) > 0.4 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


---------------
-- Lufthavne --
---------------
SELECT 'Lufthavne: ', now();

-- Lufthavne helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'lufthavn'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Lufthavne > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'lufthavn'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

----------------
-- Naturareal --
----------------
SELECT 'Naturareal: ', now();

-- Naturareal i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Naturareal, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
        p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--> Naturareal, > 90% inden for en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--> Naturareal, > 60% inden for en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.6 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-----------------------
-- Navigationsanlaeg --
-----------------------
SELECT 'Navigationsanlaeg: ', now();

-- Naturareal i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'navigationsanlaeg'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


------------------------
-- Restriktionsanlaeg --
------------------------
SELECT 'Restriktionsanlaeg: ', now();

-- Restriktionsanlaeg i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, helt indenfor en region
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn != 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, > 90 % i en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, > 60 % i kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.6 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


----------
-- Rute --
----------
SELECT 'Rute: ', now();

-- Er ingen stednavn for tiden der har denne type
-- Rute helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'rute'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Rute > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND p.geometri && s.geometri
		AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'rute'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	visningstekst IS NULL
	AND TYPE = 'rute';


------------------
-- Sevaerdighed --
------------------
SELECT 'Sevaerdighed: ', now();

-- Sevaerdighed i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'sevaerdighed'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Sevaerdighed,  > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'sevaerdighed'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------------
-- Terraenkontur --
-------------------
SELECT 'Terraenkontur: ', now();

-- Terraenkontur i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'terraenkontur'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Terraenkontur,  > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'terraenkontur'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


------------------
-- Urentfarvand --
------------------
SELECT 'Urentfarvand: ', now();

-- Urentfarvand i alle farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.geometri && s1.geometri
        AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- > 50 % i et farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.type = 'farvand'
	    AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.geometri && s1.geometri
        AND st_area (st_intersection (s2.geometri, s1.geometri)) > 0.5 * s1.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------
-- Vandloeb --
--------------
SELECT 'Vandloeb: ', now();

-- Vandloeb i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Vandloeb, > 60 % i postnummerinddeling
-- Vandloeb består af multilinestrings og der har vi brug for st_envelope, som returnerer en bbox,
-- da mulitlinestring ingen bbox har
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.6 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------------------
-- Andentopografiflade --
-------------------------
SELECT 'Andentopografiflade: ', now();

-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='andentopografiflade' AND visningstekst IS NULL;
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--> 60% inden for en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.6 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------------------
-- Andentopografipunkt --
-------------------------
SELECT 'Andentopografipunkt: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografipunkt'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Helt inden for en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn != 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografipunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--> 60% inden for en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
        k.kommunenavn != 'Christiansø'
        AND k.geometri && s.geometri
        AND st_area (st_intersection (k.geometri, s.geometri)) > 0.6 * s.area
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografipunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


-------------------
-- Idraetsanlaeg --
-------------------
SELECT 'Idraetsanlaeg: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'idraetsanlaeg'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'idraetsanlaeg'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


---------
-- Soe --
---------
SELECT 'Soe: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, s.geometri)) > 0.4 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Soe, helt indenfor en kommune
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || k.visningstekst || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.kommune_helper_stednavne k ON
    (
    	k.kommunenavn != 'Christiansø'
        AND ST_contains (k.geometri, s.geometri)
    )
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


---------------------
-- Standsningssted --
---------------------
SELECT 'Standsningssted: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ', ' || s.subtype || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
	    AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'standsningssted'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------------
-- Ubearbejdetnavnflade --
--------------------------
SELECT 'Ubearbejdetnavnflade: ', now();

-- Er ingen stednavn for tiden der har denne type
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnflade'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------------
-- Ubearbejdetnavnlinje --
--------------------------
SELECT 'Ubearbejdetnavnlinje: ', now();

-- Er ingen stednavn for tiden der har denne type
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnlinje'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------------
-- Ubearbejdetnavnpunkt --
--------------------------
SELECT 'Ubearbejdetnavnpunkt: ', now();

-- Er ingen stednavn for tiden der har denne type
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnpunkt'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------------
---------- Vej -----------
--------------------------
SELECT 'Vej: ', now();

-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(
	    p.navn != s.skrivemaade
        AND ST_contains (p.geometri, s.geometri)
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vej'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Vej, > 60 % i postnummerinddeling
-- Vej består af multilinestrings og der har vi brug for st_envelope, som returnerer en bbox,
-- da mulitlinestring ingen bbox har
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
    (
        p.navn != s.skrivemaade
        AND p.geometri && s.geometri
	    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.6 * s.area
	)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vej'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


--------------------------
-- Resterende stednavne --
--------------------------
SELECT 'Resterende stednavne: ', now();

-- Stednavne der ligger helt indenfor en region
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || r.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.regionsinddeling r ON
    (
        ST_contains (r.geometri, s.geometri)
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--> 90% indenfor region
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || r.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.regionsinddeling r ON
    (
        r.geometri && s.geometri
        AND st_area (st_intersection (r.geometri, s.geometri)) > 0.9 * s.area
    )
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Placeret stednavne på ø'er og halvø'er
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
        s2.TYPE = 'landskabsform'
		AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.skrivemaade != s1.skrivemaade
        AND st_area(s2.geometri) > 10000000
		AND s2.geometri && s1.geometri
		AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Der ønskes at få så præcis en landsdel som muligt, så vi undlader først landsdel Jylland
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.skrivemaade != 'Jylland'
		AND s2.subtype = 'landsdel'
		AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.skrivemaade != s1.skrivemaade
		AND s2.geometri && s1.geometri
		AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
	    s2.subtype = 'landsdel'
		AND (s2.navnestatus = 'officielt' OR s2.navnestatus = 'suAutoriseret')
        AND s2.skrivemaade != s1.skrivemaade
		AND s2.geometri && s1.geometri
		AND ST_contains (s2.geometri, s1.geometri)
	)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Soerger for at de sidste stednavne faar en hjaelpetekst
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i Danmark)'
FROM
    stednavne_udstilling.stednavne_udstilling s
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;


VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;


SELECT 'Kommunefilter: ', now();

-- Tilføj og populer kommunefilter på tabellen
-- Kommunekode needs to be done here and not in 510_api_stednavne as it else results in duplicated kommunekoder in
-- stednavne that has more than one skrivemaade.
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	kommunekode = t.kommunekode
FROM
	(
	SELECT
		s.objectid,
		s.navnefoelgenummer,
		string_agg(k.kommunekode, ',') AS kommunekode
	FROM
		stednavne_udstilling.stednavne_udstilling s
	LEFT JOIN dagi_10.kommuneinddeling k ON
		st_intersects(k.geometri, s.geometri)
	GROUP BY
		s.objectid,
		s.navnefoelgenummer
     ) t
WHERE
	stednavne_udstilling.stednavne_udstilling.objectid = t.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = t.navnefoelgenummer;

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE, visningstekst);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst);

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

SELECT '2_preprocessing.sql DONE: ', now();