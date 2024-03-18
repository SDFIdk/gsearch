DROP VIEW IF EXISTS stednavne_udstilling.andentopografiflade CASCADE;

CREATE VIEW stednavne_udstilling.andentopografiflade AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.andentopografiflade x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.andentopografipunkt CASCADE;

CREATE VIEW stednavne_udstilling.andentopografipunkt AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.andentopografipunkt x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.bebyggelse CASCADE;

CREATE VIEW stednavne_udstilling.bebyggelse AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.bebyggelse x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.begravelsesplads CASCADE;

CREATE VIEW stednavne_udstilling.begravelsesplads AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.begravelsesplads x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.bygning CASCADE;

CREATE VIEW stednavne_udstilling.bygning AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.bygning x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.campingplads CASCADE;

CREATE VIEW stednavne_udstilling.campingplads AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.campingplads x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.farvand CASCADE;

CREATE VIEW stednavne_udstilling.farvand AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.farvand x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.fortidsminde CASCADE;

CREATE VIEW stednavne_udstilling.fortidsminde AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.fortidsminde x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.friluftsbad CASCADE;

CREATE VIEW stednavne_udstilling.friluftsbad AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.friluftsbad x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.havnebassin CASCADE;

CREATE VIEW stednavne_udstilling.havnebassin AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.havnebassin x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.idraetsanlaeg CASCADE;

CREATE VIEW stednavne_udstilling.idraetsanlaeg AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.idraetsanlaeg x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.jernbane CASCADE;

CREATE VIEW stednavne_udstilling.jernbane AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.jernbane x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.landskabsform CASCADE;

CREATE VIEW stednavne_udstilling.landskabsform AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.landskabsform x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.lufthavn CASCADE;

CREATE VIEW stednavne_udstilling.lufthavn AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.lufthavn x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.naturareal CASCADE;

CREATE VIEW stednavne_udstilling.naturareal AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.naturareal x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.navigationsanlaeg CASCADE;

CREATE VIEW stednavne_udstilling.navigationsanlaeg AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.navigationsanlaeg x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.restriktionsareal CASCADE;

CREATE VIEW stednavne_udstilling.restriktionsareal AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.restriktionsareal x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.sevaerdighed CASCADE;

CREATE VIEW stednavne_udstilling.sevaerdighed AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.sevaerdighed x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.soe CASCADE;

CREATE VIEW stednavne_udstilling.soe AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.soe x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.standsningssted CASCADE;

CREATE VIEW stednavne_udstilling.standsningssted AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.standsningssted x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.terraenkontur CASCADE;

CREATE VIEW stednavne_udstilling.terraenkontur AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.terraenkontur x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.ubearbejdetnavnflade CASCADE;

CREATE VIEW stednavne_udstilling.ubearbejdetnavnflade AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.ubearbejdetnavnflade x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.ubearbejdetnavnlinje CASCADE;

CREATE VIEW stednavne_udstilling.ubearbejdetnavnlinje AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.ubearbejdetnavnlinje x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.ubearbejdetnavnpunkt CASCADE;

CREATE VIEW stednavne_udstilling.ubearbejdetnavnpunkt AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.ubearbejdetnavnpunkt x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.urentfarvand CASCADE;

CREATE VIEW stednavne_udstilling.urentfarvand AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.urentfarvand x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.vandloeb CASCADE;

CREATE VIEW stednavne_udstilling.vandloeb AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.vandloeb x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;

DROP VIEW IF EXISTS stednavne_udstilling.vej CASCADE;

CREATE VIEW stednavne_udstilling.vej AS
SELECT
	x.*,
	s.skrivemaade,
	s.aktualitet,
	s.brugsprioritet,
	s.navnefoelgenummer,
	s.navnestatus,
	s.sprog
FROM
	stednavne.vej x
JOIN (
	SELECT
		skrivemaade,
		aktualitet,
		brugsprioritet,
		min(navnefoelgenummer) AS navnefoelgenummer,
		navnestatus,
		sprog,
		navngivetsted_objectid
	FROM
		stednavne.stednavn
	GROUP BY
		skrivemaade,
		aktualitet,
		brugsprioritet,
		navnestatus,
		sprog,
		navngivetsted_objectid
    ) AS s
    ON
	x.objectid = s.navngivetsted_objectid;
-- All elements
CREATE OR REPLACE
VIEW stednavne_udstilling.stednavne_union AS
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'bebyggelse' AS type,
	bebyggelsestype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.bebyggelse
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'begravelsesplads' AS type,
	begravelsespladstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.begravelsesplads
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'bygning' AS type,
	bygningstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.bygning
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'campingplads' AS type,
	campingpladstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.campingplads
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'farvand' AS type,
	farvandstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.farvand
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'fortidsminde' AS type,
	fortidsmindetype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.fortidsminde
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'friluftsbad' AS type,
	friluftsbadtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.friluftsbad
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'havnebassin' AS type,
	havnebassintype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.havnebassin
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'jernbane' AS type,
	jernbanetype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.jernbane
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'landskabsform' AS type,
	landskabsformtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.landskabsform
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'lufthavn' AS type,
	lufthavnstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.lufthavn
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'naturareal' AS type,
	naturarealtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.naturareal
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'navigationsanlaeg' AS type,
	navigationsanlaegstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.navigationsanlaeg
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'restriktionsareal' AS type,
	restriktionsarealtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.restriktionsareal
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'sevaerdighed' AS type,
	sevaerdighedstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.sevaerdighed
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'terraenkontur' AS type,
	terraenkonturtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.terraenkontur
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'urentfarvand' AS type,
	urentfarvandtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.urentfarvand
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'vandloeb' AS type,
	vandloebstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.vandloeb
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'andentopografiflade' AS type,
	andentopografitype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.andentopografiflade
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'andentopografipunkt' AS type,
	andentopografitype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.andentopografipunkt
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'idraetsanlaeg' AS type,
	idraetsanlaegstype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.idraetsanlaeg
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'soe' AS type,
	soetype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.soe
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'standsningssted' AS type,
	standsningsstedtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.standsningssted
UNION
SELECT
	objectid::integer,
	geometri,
	navnefoelgenummer::int,
	navnestatus,
	skrivemaade,
	sprog,
	'vej' AS type,
	vejtype AS subtype,
	id_lokalid
FROM
	stednavne_udstilling.vej;