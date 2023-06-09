DROP VIEW IF EXISTS stednavne_udstilling.andentopografiflade CASCADE;

CREATE VIEW stednavne_udstilling.andentopografiflade AS
        SELECT
            x.*,
            s.skrivemaade,
            s.aktualitet,
            s.brugsprioritet,
            s.navnefoelgenummer,
            s.navnestatus,
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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
            s.sprog,
            round(st_area(x.geometri)) as udregnet_areal
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



SELECT now();
SELECT 638;

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


SELECT now();
SELECT 6386;

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

SELECT now();
SELECT 30120;
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
SELECT now();
SELECT 5418;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    subtype_presentation = COALESCE(st.subtype_presentation, st.subtype)
FROM
    stednavne_udstilling.subtype_translation st
WHERE
    stednavne_udstilling.stednavne_udstilling.subtype = st.subtype;

-- Slet dublerede forekomster (Samme objekt og en uofficiel stavemaade der er magen til)
DELETE FROM stednavne_udstilling.stednavne_udstilling
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
DELETE FROM stednavne_udstilling.stednavne_udstilling s
WHERE st_geometrytype (s.geometri) = 'ST_GeometryCollection';

-- Opdater udyndet geometri
SELECT now();
SELECT 18284;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    geometri_udtyndet = CASE WHEN length(ST_Astext (geometri)) < 5000 THEN
        geometri
    ELSE
        ST_SimplifyPreserveTopology (geometri, GREATEST (ST_Xmax (ST_Envelope (geometri)) - ST_Xmin (ST_Envelope (geometri)), ST_Ymax (ST_Envelope (geometri)) - ST_Ymin (ST_Envelope (geometri))) / 300)
    END;

-- Prioritetsmæssig opdatering af visningstekst
SELECT now();
SELECT 13673;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL;

-----------------
-- Bebyggelser --
-----------------

-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstilling.stednavne_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 er kendte
SELECT now();
SELECT 29657;
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
SELECT now();
SELECT 26454;
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
    stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.subtype = 'bydel'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Byer som ligger helt inde i et postnummerinddeling
SELECT now();
SELECT 8565;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (By i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND s.subtype = 'by'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- By, > 50 % i postnummerinddeling
SELECT now();
SELECT 17589;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (By i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND s.subtype = 'by'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser som ligger helt inde i et postnummerinddeling
SELECT now();
SELECT 22221;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND s.type = 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser, > 50 % i postnummerinddeling
SELECT now();
SELECT 454;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
  AND s.type = 'bebyggelse'
  AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Begravelsespladser --
------------------------

-- Helt indenfor et postnummerinddeling
SELECT now();
SELECT 6397;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'begravelsesplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
SELECT now();
SELECT 10368;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'begravelsesplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

---------------
-- Bygninger --
---------------

-- Bygninger helt indenfor et postnummerinddeling
SELECT now();
SELECT 7892;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
SELECT now();
SELECT 31505;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'bygning'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når subtypen oplagt fremgår af skrivemaade)
SELECT now();
SELECT 28240;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE
    type = 'bygning'
    AND subtype = 'akvarium';

SELECT now();
SELECT 21971;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE
    type = 'bygning'
    AND subtype = 'akvarium';

--------------------
-- Campingpladser --
--------------------

-- Helt indenfor et postnummerinddeling
SELECT now();
SELECT 23414;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
SELECT now();
SELECT 18798;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'campingplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------
-- Farvand --
-------------

-- > 1500 km**2 er alment kendte
SELECT now();
SELECT 2342;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade
WHERE
    area > 1500000000;

-- Farvande, der ligger helt inde i et andet farvand
SELECT now();
SELECT 18409;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.visningstekst IS NOT NULL
            AND s2.type = 'farvand'
            AND ST_contains (s2.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et farvand
SELECT now();
SELECT 469;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Fortidsminde --
------------------

-- Fortidsminder i postnummerinddeling
SELECT now();
SELECT 18470;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'fortidsminde'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling
SELECT now();
SELECT 5412;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    st_geometrytype (stednavne_udstilling.stednavne_udstilling.geometri) = 'ST_MultiPoint'
    AND stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'fortidsminde'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------
-- Friluftsbad --
-----------------

-- Friluftsbad i postnummerinddeling
SELECT now();
SELECT 32211;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'friluftsbad'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------
-- Havnebassin --
-----------------

-- Havnebassin i postnummerinddeling
SELECT now();
SELECT 13080;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin,  > 50 % i postnummerinddeling
SELECT now();
SELECT 13739;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'havnebassin'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--------------
-- Jernbane --
--------------

-- Jernbane i postnummerinddeling
SELECT now();
SELECT 3335;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'jernbane'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Jernbane,  > 50 % i postnummerinddeling
SELECT now();
SELECT 23159;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'jernbane'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Landskabsform --
-------------------

-- Landskabsformer > 50 km**2
SELECT now();
SELECT 20045;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND TYPE = 'landskabsform'
    AND ST_Area (geometri) > 50000000;

-- Ø'er i store farvande
SELECT now();
SELECT 10155;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er i alle farvande
SELECT now();
SELECT 19579;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er intersects alle farvande
SELECT now();
SELECT 26980;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype = 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype = 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- landskabsformer i postnummer
SELECT now();
SELECT 5595;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Landskabsformer, > 50 % i postnummerinddeling
SELECT now();
SELECT 6977;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
    FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
  AND stednavne_udstilling.stednavne_udstilling.type = 'landskabsform'
  AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

---------------
-- Lufthavne --
---------------

SELECT now();
SELECT 17994;
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
SELECT now();
SELECT 18841;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Naturareal, > 50 % i postnummerinddeling
SELECT now();
SELECT 16231;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
        AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'naturareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------------
-- Navigationsanlaeg --
-----------------------

-- Naturareal i postnummerinddeling
SELECT now();
SELECT 4365;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'navigationsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Restriktionsanlaeg --
------------------------

-- Restriktionsanlaeg i postnummerinddeling
SELECT now();
SELECT 32687;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Restriktionsanlaeg, > 50 % i postnummerinddeling
SELECT now();
SELECT 22950;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
    FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
    AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
  AND stednavne_udstilling.stednavne_udstilling.type = 'restriktionsareal'
  AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
  AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"

-- Rute
SELECT now();
SELECT 4313;
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
SELECT now();
SELECT 7607;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'sevaerdighed'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Sevaerdighed,  > 50 % i postnummerinddeling
SELECT now();
SELECT 21483;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'sevaerdighed'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Terraenkontur --
-------------------

-- Terraenkontur i postnummerinddeling
SELECT now();
SELECT 23025;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'terraenkontur'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Terraenkontur,  > 50 % i postnummerinddeling
SELECT now();
SELECT 25519;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'terraenkontur'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Urentfarvand --
------------------

-- Urentfarvand i store farvande
SELECT now();
SELECT 11500;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand i alle farvande
SELECT now();
SELECT 18327;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand, intersects
SELECT now();
SELECT 1102;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

--------------
-- Vandloeb --
--------------

-- Vandloeb i postnummerinddeling
SELECT now();
SELECT 18469;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Vandloeb, > 50 % i postnummerinddeling
SELECT now();
SELECT 31313;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'vandloeb'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------------
-- andentopografiflade --
-------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='andentopografiflade' AND visningstekst IS NULL;

-- Helt indenfor et postnummerinddeling
SELECT now();
SELECT 6553;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
SELECT now();
SELECT 26509;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografiflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 17090;
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
SELECT now();
SELECT 23885;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'andentopografipunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

---------------------
-- faergerutelinje --
---------------------

SELECT now();
SELECT 28526;
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
SELECT now();
SELECT 15390;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'idraetsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
SELECT now();
SELECT 12894;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'idraetsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

---------
-- soe --
---------

-- Helt indenfor et postnummerinddeling
SELECT now();
SELECT 10813;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
SELECT now();
SELECT 18132;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling
SELECT now();
SELECT 25129;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (p.geometri && s.geometri
            AND st_area (st_intersection (p.geometri, s.geometri)) > 0.4 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 4975;
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
SELECT now();
SELECT 29128;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ', ' || s.subtype || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'standsningssted'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 4355;
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
SELECT now();
SELECT 19747;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 16287;
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
SELECT now();
SELECT 7082;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnlinje'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 27591;
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
SELECT now();
SELECT 25750;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'ubearbejdetnavnpunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 10101;
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
SELECT now();
SELECT 15486;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_10.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type = 'vej'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
SELECT now();
SELECT 13023;
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
SELECT now();
SELECT 19144;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- På store ø'er
SELECT now();
SELECT 18553;
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
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- På mindre ø'er
SELECT now();
SELECT 7138;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' på ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'Ø'
            AND ST_contains (s2.geometri, s1.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Alle andre får blot type/subtype
SELECT now();
SELECT 22117;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND btrim(subtype_presentation) = '';

    SELECT now();
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ' / ' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND btrim(subtype_presentation) <> '';

-- Tilføj og populer kommunefilter på tabellen
-- Kommunekode needs to be done here and not in 510_api_stednavne as it else results in duplicated kommunekoder in
-- stednavne that has more than one skrivemaade.
SELECT now();
SELECT 6613;
UPDATE
stednavne_udstilling.stednavne_udstilling
SET
    kommunekode = t.kommunekode
FROM (
    SELECT
        s.objectid,
        s.navnefoelgenummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        stednavne_udstilling.stednavne_udstilling s
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, s.geometri)
    GROUP BY
        s.objectid,
        s.navnefoelgenummer
    ) t
WHERE
    stednavne_udstilling.stednavne_udstilling.objectid = t.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = t.navnefoelgenummer;

VACUUM ANALYZE stednavne_udstilling.stednavne_udstilling;
