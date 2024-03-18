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
    geometri geometry(Geometry,
25832),
    geometri_udtyndet geometry(Geometry,
25832),
    visningstekst varchar,
    area float,
    CONSTRAINT stednavne_udstilling_pkey PRIMARY KEY (objectid,
navnefoelgenummer)
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

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE, subtype);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype, TYPE);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE, visningstekst);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling USING gist (geometri);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype_presentation);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (skrivemaade);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (objectid);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (navnefoelgenummer);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (TYPE);

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Opdater subtype_presentation
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	subtype_presentation = COALESCE(st.subtype_presentation, st.subtype)
FROM
	stednavne_udstilling.subtype_translation st
WHERE
	stednavne_udstilling.stednavne_udstilling.subtype = st.subtype;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
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
			AND
            s2.objectid = stednavne_udstilling.stednavne_udstilling.objectid
			AND
            s2.skrivemaade = stednavne_udstilling.stednavne_udstilling.skrivemaade));
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

CREATE INDEX ON
stednavne_udstilling.stednavne_udstilling
	USING gist (geometri_udtyndet);

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-- Prioritetsmæssig opdatering af visningstekst
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = NULL;

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst);

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-----------------
-- Bebyggelser --
-----------------
-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstilling.stednavne_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 er kendte
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade
WHERE
	st_area (geometri) > 4000000
	AND TYPE = 'bebyggelse'
	AND subtype = 'by'
	AND visningstekst IS NULL;
-- Bydele i store byer > 10 km**2
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (Bydel i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(
        s2.type = 'bebyggelse'
		AND s2.subtype = 'by'
		AND s2.area > 10000000
		AND s1.geometri && s2.geometri
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Byer som ligger helt inde i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND s.type = 'bebyggelse'
	AND s.subtype = 'by'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-- By, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND s.type = 'bebyggelse'
	AND s.subtype = 'by'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Bebyggelser som ligger helt inde i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND s.type = 'bebyggelse'
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND s.type = 'bebyggelse'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
------------------------
-- Begravelsespladser --
------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'begravelsesplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
---------------
-- Bygninger --
---------------
-- Bygninger helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation,
	'Anden ',
	'')
FROM
	2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation,
	'Anden ',
	'')
FROM
	2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
--------------------
-- Campingpladser --
--------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-------------
-- Farvand --
-------------
-- > 1500 km**2 er alment kendte
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade
WHERE
	area > 1500000000;
-- Farvande, der ligger helt inde i et andet farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.visningstekst IS NOT NULL
		AND s2.type = 'farvand'
		AND ST_contains (s2.geometri,
		s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- > 50 % i et farvand
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.visningstekst IS NOT NULL
		AND s2.type = 'farvand'
		AND s2.geometri_udtyndet && s.geometri_udtyndet
		AND st_area (st_intersection (s2.geometri_udtyndet,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
------------------
-- Fortidsminde --
------------------
-- Fortidsminder i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	st_geometrytype (stednavne_udstilling.stednavne_udstilling.geometri) = 'ST_MultiPoint'
	AND stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'fortidsminde'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-----------------
-- Friluftsbad --
-----------------
-- Friluftsbad i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'friluftsbad'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-----------------
-- Havnebassin --
-----------------
-- Havnebassin i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
--------------
-- Jernbane --
--------------
-- Jernbane i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'jernbane'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-------------------
-- Landskabsform --
-------------------
-- Landskabsformer > 50 km**2
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND TYPE = 'landskabsform'
	AND ST_Area (geometri) > 50000000;
-- Ø'er i store farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s2.area > 400000000
		AND s1.geometri && s2.geometri
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
		OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Ø'er i alle farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s1.geometri && s2.geometri
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
		OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Ø'er intersects alle farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s1.geometri && s2.geometri
		AND ST_Intersects (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
		OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- landskabsformer i postnummer
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-- Landskabsformer, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
---------------
-- Lufthavne --
---------------
-- Lufthavne helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'lufthavn'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'lufthavn';
----------------
-- Naturareal --
----------------
-- Naturareal i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-- Naturareal, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-----------------------
-- Navigationsanlaeg --
-----------------------
-- Naturareal i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'navigationsanlaeg'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
------------------------
-- Restriktionsanlaeg --
------------------------
-- Restriktionsanlaeg i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"
-- Rute helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
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
-- Sevaerdighed i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'sevaerdighed'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-------------------
-- Terraenkontur --
-------------------
-- Terraenkontur i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'terraenkontur'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
------------------
-- Urentfarvand --
------------------
-- Urentfarvand i store farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s2.area > 400000000
		AND s1.geometri && s2.geometri
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Urentfarvand i alle farvande
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s1.geometri && s2.geometri
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Urentfarvand, intersects
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.type = 'farvand'
		AND s1.geometri && s2.geometri
		AND ST_Intersects (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
--------------
-- Vandloeb --
--------------
-- Vandloeb i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Vandloeb, > 50 % i postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
-------------------------
-- andentopografiflade --
-------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='andentopografiflade' AND visningstekst IS NULL;
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	visningstekst IS NULL
	AND TYPE = 'andentopografiflade';
-------------------------
-- andentopografipunkt --
-------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografipunkt'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
---------------------
-- faergerutelinje --
---------------------

UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || '(' || subtype_presentation || ')'
WHERE
	TYPE = 'faergerutelinje'
	AND visningstekst IS NULL;
-------------------
-- idraetsanlaeg --
-------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'idraetsanlaeg'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
---------
-- soe --
---------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.5 * s.area)
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
	(p.geometri && s.geometri_udtyndet
		AND st_area (st_intersection (p.geometri,
		s.geometri_udtyndet)) > 0.4 * s.area)
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'soe';
---------------------
-- standsningssted --
---------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ', ' || s.subtype || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'standsningssted'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ', ' || subtype || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'standsningssted';
--------------------------
-- ubearbejdetnavnflade --
--------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnflade'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnflade';
--------------------------
-- ubearbejdetnavnlinje --
--------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnlinje'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnlinje';
--------------------------
-- ubearbejdetnavnpunkt --
--------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnpunkt'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnpunkt';
--------------------------
-- vej --
--------------------------
-- Helt indenfor et postnummerinddeling
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s
JOIN dagi_10.postnummerinddeling p ON
	(ST_contains (p.geometri,
	s.geometri_udtyndet))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vej'
	AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;
-- Øvrige
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.type = 'vej';
--------------------------
-- Resterende stednavne --
--------------------------
-- I Jylland
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.subtype = 'halvø'
		AND s2.skrivemaade = 'Jylland'
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- På store ø'er
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.subtype = 'Ø'
		AND s2.area > 50000000
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- På mindre ø'er
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
	stednavne_udstilling.stednavne_udstilling s1
JOIN stednavne_udstilling.stednavne_udstilling s2 ON
	(s2.subtype = 'Ø'
		AND ST_contains (s2.geometri,
		s1.geometri))
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;
-- Alle andre får blot type/subtype
UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND btrim(subtype_presentation) = '';

UPDATE
	stednavne_udstilling.stednavne_udstilling
SET
	visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ' / ' || subtype_presentation || ')'
WHERE
	stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
	AND btrim(subtype_presentation) <> '';

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
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
		st_intersects(k.geometri,
		s.geometri)
	GROUP BY
		s.objectid,
		s.navnefoelgenummer
     ) t
WHERE
	stednavne_udstilling.stednavne_udstilling.objectid = t.objectid
	AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = t.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;