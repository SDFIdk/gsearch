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
            stednavne.andentopografiflade x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.andentopografipunkt x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.bebyggelse x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.begravelsesplads x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.bygning x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.campingplads x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.farvand x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.fortidsminde x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.friluftsbad x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.havnebassin x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.idraetsanlaeg x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.jernbane x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.landskabsform x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.lufthavn x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.naturareal x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.navigationsanlaeg x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.restriktionsareal x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.sevaerdighed x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.soe x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.standsningssted x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.terraenkontur x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.ubearbejdetnavnflade x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.ubearbejdetnavnlinje x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.ubearbejdetnavnpunkt x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.urentfarvand x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.vandloeb x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;
    

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
            stednavne.vej x JOIN (
                SELECT 
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    min(navnefoelgenummer) AS navnefoelgenummer,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
                FROM stednavne.stednavn
                GROUP BY
                    skrivemaade,
                    aktualitet,
                    brugsprioritet,
                    navnestatus,
                    sprog,
                    navngivetsted_objectid
            ) AS s
            ON x.objectid = s.navngivetsted_objectid;




-- All elements
CREATE OR REPLACE VIEW stednavne_udstilling.stednavne_union AS
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
    geometri geometry(Geometry, 25832),
    geometri_udtyndet geometry(Geometry, 25832),
    visningstekst varchar,
    area float,
    CONSTRAINT stednavne_udstilling_pkey PRIMARY KEY (objectid, navnefoelgenummer)
);

-- Ingen dubletter mere
--WITH dubletter AS --4:10
--  (select distinct objectid, navnefoelgenummer from stednavne_udstilling.stednavne_udstilling WHERE objectid IN
--  (select objectid from stednavne_udstilling.stednavne_udstilling group by objectid, navnefoelgenummer having count(1)>1))
-- 1:50
INSERT INTO stednavne_udstilling.stednavne_udstilling (objectid, id_lokalid, navnefoelgenummer, navnestatus, skrivemaade, sprog, TYPE, subtype, geometri, area)
SELECT
    objectid,
    id_lokalid,
    navnefoelgenummer,
    navnestatus,
    skrivemaade,
    sprog,
    type,
    btrim(subtype),
    geometri,
    st_area (geometri)
FROM
    stednavne_udstilling.stednavne_union s
WHERE
    st_isvalid (geometri);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (type, subtype);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype, type);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (type, visningstekst);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling USING gist (geometri);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype_presentation);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (skrivemaade);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (objectid);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (navnefoelgenummer);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (type);

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
DELETE FROM stednavne_udstilling.stednavne_udstilling
WHERE 
    navnestatus = 'uofficielt'
AND objectid IN (
    SELECT
        objectid
    FROM
        stednavne_udstilling.stednavne_udstilling s
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
            s2.objectid = s.objectid
        AND 
            s2.skrivemaade = s.skrivemaade));

-- 2015-09-22/Christian: Slet stednavne med geometrier, der er GeometryCollection
DELETE FROM stednavne_udstilling.stednavne_udstilling s
WHERE st_geometrytype (s.geometri) = 'ST_GeometryCollection';

-- Opdater udtyndet geometri
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    geometri_udtyndet = CASE WHEN length(ST_Astext (geometri)) < 5000 THEN
        geometri
    ELSE
        ST_SimplifyPreserveTopology (geometri, GREATEST (ST_Xmax (ST_Envelope (geometri)) - ST_Xmin (ST_Envelope (geometri)), ST_Ymax (ST_Envelope (geometri)) - ST_Ymin (ST_Envelope (geometri))) / 300)
    END;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Prioritetsmæssig opdatering af visningstekst
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL;

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
    AND type = 'bebyggelse'
    AND subtype = 'by'
    AND visningstekst IS NULL;

-- Bydele i store byer > 10 km**2
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (Bydel i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (
            s2.type = 'bebyggelse'
            AND s2.subtype = 'by'
            AND s2.area > 10000000
            AND s1.geometri && s2.geometri
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'bebyggelse'
    AND s1.subtype = 'bydel'
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Byer som ligger helt inde i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (By i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND s.subtype = 'by'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- By, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (By i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND s.subtype = 'by'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser som ligger helt inde i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
  AND s.type = 'bebyggelse'
  AND s.objectid = s.objectid
  AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'begravelsesplads'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'begravelsesplads'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

---------------
-- Bygninger --
---------------

-- Bygninger helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'bygning'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'bygning'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'campingplads'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'campingplads'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.visningstekst IS NOT NULL
            AND s2.type = 'farvand'
            AND ST_contains (s2.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'farvand'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et farvand
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.visningstekst IS NOT NULL
            AND s2.type = 'farvand'
            AND s2.geometri_udtyndet && s.geometri_udtyndet
            AND st_area (st_intersection (s2.geometri_udtyndet, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'farvand'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'fortidsminde'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    st_geometrytype (s.geometri) = 'ST_MultiPoint'
    AND s.visningstekst IS NULL
    AND s.type = 'fortidsminde'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'friluftsbad'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'havnebassin'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'havnebassin'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'jernbane'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Jernbane,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'jernbane'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Landskabsform --
-------------------

-- Landskabsformer > 50 km**2
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade
WHERE
    s.visningstekst IS NULL
    AND s.type = 'landskabsform'
    AND ST_Area (s.geometri) > 50000000;

-- Ø'er i store farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s2.area > 400000000
            AND s1.geometri && s2.geometri
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'landskabsform'
    AND (s1.subtype = 'ø'
        OR s1.subtype = 'øgruppe')
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er i alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s1.geometri && s2.geometri
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'landskabsform'
    AND (s1.subtype = 'ø'
        OR s1.subtype = 'øgruppe')
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er intersects alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s1.geometri && s2.geometri
            AND ST_Intersects (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'landskabsform'
    AND (s1.subtype = 'ø'
        OR s1.subtype = 'øgruppe')
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- landskabsformer i postnummer
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'landskabsform'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Landskabsformer, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
    FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
  AND s.type = 'landskabsform'
  AND s.objectid = s.objectid
  AND s.navnefoelgenummer = s.navnefoelgenummer;

---------------
-- Lufthavne --
---------------

UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'lufthavn';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'naturareal'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Naturareal, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'naturareal'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'navigationsanlaeg'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'restriktionsareal'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
    FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
  AND s.type = 'restriktionsareal'
  AND s.objectid = s.objectid
  AND s.navnefoelgenummer = s.navnefoelgenummer;

----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"

-- Rute
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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'sevaerdighed'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Sevaerdighed,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'sevaerdighed'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Terraenkontur --
-------------------

-- Terraenkontur i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'terraenkontur'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Terraenkontur,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'terraenkontur'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s2.area > 400000000
            AND s1.geometri && s2.geometri
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'urentfarvand'
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand i alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s1.geometri && s2.geometri
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'urentfarvand'
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand, intersects
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s1.geometri && s2.geometri
            AND ST_Intersects (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.type = 'urentfarvand'
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'vandloeb'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Vandloeb, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'vandloeb'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'andentopografiflade'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'andentopografiflade'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    visningstekst IS NULL
    AND type = 'andentopografiflade';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'andentopografipunkt'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

---------------------
-- faergerutelinje --
---------------------

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || '(' || subtype_presentation || ')'
WHERE
    type = 'faergerutelinje'
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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'idraetsanlaeg'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'idraetsanlaeg'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'soe'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'soe'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.4 * s.area)
WHERE
    s.visningstekst IS NULL
    AND s.type = 'soe'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'soe';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'standsningssted'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ', ' || s.subtype || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'standsningssted';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnflade'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnflade';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnlinje'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnlinje';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnpunkt'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'ubearbejdetnavnpunkt';

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
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    s.visningstekst IS NULL
    AND s.type = 'vej'
    AND s.objectid = s.objectid
    AND s.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND s.type = 'vej';

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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'halvø'
            AND s2.skrivemaade = 'Jylland'
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- På store ø'er
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'Ø'
            AND s2.area > 50000000
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- På mindre ø'er
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'Ø'
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    s1.visningstekst IS NULL
    AND s1.objectid = s1.objectid
    AND s1.navnefoelgenummer = s1.navnefoelgenummer;

-- Alle andre får blot type/subtype
UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ')'
WHERE
    s.visningstekst IS NULL
    AND btrim(s.subtype_presentation) = '';

UPDATE
    stednavne_udstilling.stednavne_udstilling s
SET
    visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ' / ' || s.subtype_presentation || ')'
WHERE
    s.visningstekst IS NULL
    AND btrim(s.subtype_presentation) <> '';

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;

-- Tilføj og populer kommunefilter på tabellen
-- Kommunekode needs to be done here and not in 510_api_stednavne as it else results in duplicated kommunekoder in
-- stednavne that has more than one skrivemaade.
UPDATE
stednavne_udstilling.stednavne_udstilling s
SET
    kommunekode = t.kommunekode
FROM (
    SELECT
        s1.objectid,
        s1.navnefoelgenummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        stednavne_udstilling.stednavne_udstilling s1
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, s1.geometri)
    GROUP BY
        s1.objectid,
        s1.navnefoelgenummer
    ) t
WHERE
    s.objectid = t.objectid
    AND s.navnefoelgenummer = t.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
