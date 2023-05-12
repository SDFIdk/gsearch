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

CREATE INDEX stednavne_udstilling_type_idx ON stednavne_udstilling.stednavne_udstilling (TYPE, subtype);

CREATE INDEX stednavne_udstilling_subtype_idx ON stednavne_udstilling.stednavne_udstilling (subtype, TYPE);

CREATE INDEX stednavne_udstilling_type_presentation_idx ON stednavne_udstilling.stednavne_udstilling (TYPE, visningstekst);

CREATE INDEX stednavne_udstilling_type_geom_idx ON stednavne_udstilling.stednavne_udstilling USING gist (geometri);

CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (subtype_presentation);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (visningstekst);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (skrivemaade);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (objectid);
CREATE INDEX ON stednavne_udstilling.stednavne_udstilling (navnefoelgenummer);

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

-- Slet dublerede forekomster (Samme objekt og en uofficiel stavemaade der er magen til)
DELETE FROM stednavne_udstilling.stednavne_udstilling
WHERE navnestatus = 'uofficielt'
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
                    AND s2.skrivemaade = stednavne_udstilling.stednavne_udstilling.skrivemaade));

-- 2015-09-22/Christian: Slet stednavne med geometrier, der er GeometryCollection
DELETE FROM stednavne_udstilling.stednavne_udstilling s
WHERE st_geometrytype (s.geometri) = 'ST_GeometryCollection';

-- Opdater udyndet geometri 0:55
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    geometri_udtyndet = CASE WHEN length(ST_Astext (geometri)) < 5000 THEN
        geometri
    ELSE
        ST_SimplifyPreserveTopology (geometri, GREATEST (ST_Xmax (ST_Envelope (geometri)) - ST_Xmin (ST_Envelope (geometri)), ST_Ymax (ST_Envelope (geometri)) - ST_Ymin (ST_Envelope (geometri))) / 300)
    END;

-- Prioritetsmæssig opdatering af visningstekst
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL;

-----------------
-- Bebyggelser --
-----------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'bebyggelse';

-- SELECT skrivemaade, st_area(geometri)/1000/1000 FROM stednavne_udstilling.stednavne_udstilling WHERE type='bebyggelse' AND subtype='By' ORDER BY st_area(geometri) desc LIMIT 1000
-- Store byer > 4 km**2 er kendte
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade
WHERE
    st_area (geometri) > 4000000
    AND TYPE ILIKE 'bebyggelse'
    AND subtype ILIKE 'By'
    AND visningstekst IS NULL;

-- Bydele i store byer > 10 km**2 128 sek
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (Bydel i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (
            s2.type ILIKE 'bebyggelse'
            AND s2.subtype ILIKE 'By'
            AND s2.area > 10000000
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'Bydel'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Byer som ligger helt inde i et postnummerinddeling (25 sec.)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (By i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND s.type ILIKE 'bebyggelse'
    AND s.subtype ILIKE 'By'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bebyggelser som ligger helt inde i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND s.type ILIKE 'bebyggelse'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Begravelsespladser --
------------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'begravelsesplads';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'begravelsesplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Begravelsesplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'begravelsesplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når typen oplagt fremgår af skrivemaade)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Begravelsesplads i ', '(')
WHERE
    TYPE ILIKE 'begravelsesplads'
    AND visningstekst ILIKE '%kirkegård%';

---------------
-- Bygninger --
---------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE = 'bygning';

-- Bygninger helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'bygning'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Bygninger, som ligger > 50 % indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || upper(SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
            FROM 1 FOR 1)) || SUBSTRING(REPLACE(s.subtype_presentation, 'Anden ', '')
        FROM 2 FOR length(s.subtype_presentation)) || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'bygning'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når subtypen oplagt fremgår af skrivemaade)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE
    TYPE ILIKE 'bygning'
    AND subtype ILIKE 'Akvarium';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, 'Akvariet (Akvarium i ', 'Akvariet (')
WHERE
    TYPE ILIKE 'bygning'
    AND subtype ILIKE 'Akvarium';

--------------------
-- Campingpladser --
--------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'campingplads';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'campingplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (Campingplads i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'campingplads'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når typen oplagt fremgår af skrivemaade)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Campingplads i ', '(')
WHERE
    TYPE ILIKE 'campingplads'
    AND visningstekst ILIKE '%camping%';

-------------
-- Farvand --
-------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'farvand';

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
            AND s2.type ILIKE 'farvand'
            AND ST_contains (s2.geometri_udtyndet, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et farvand
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.visningstekst IS NOT NULL
            AND s2.type ILIKE 'farvand'
            AND s2.geometri_udtyndet && s.geometri_udtyndet
            AND st_area (st_intersection (s2.geometri_udtyndet, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'farvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Fortidsminde --
------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'fortidsminde';

-- Fortidsminder i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'fortidsminde'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Fortidsminder, som er multi punkter og ligger > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    st_geometrytype (stednavne_udstilling.stednavne_udstilling.geometri_udtyndet) = 'ST_MultiPoint'
    AND stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'fortidsminde'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------
-- Friluftsbad --
-----------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'friluftsbad';

-- Fortidsminder i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || 'Friluftsbad' || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'friluftsbad'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når subtypen oplagt fremgår af skrivemaade)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Friluftsbad i ', '(')
WHERE
    TYPE ILIKE 'friluftsbad'
    AND skrivemaade ILIKE '%friluftbad%';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Friluftsbad i ', '(')
WHERE
    TYPE ILIKE 'friluftsbad'
    AND skrivemaade ILIKE '%søbad%';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Friluftsbad i ', '(')
WHERE
    TYPE ILIKE 'friluftsbad'
    AND skrivemaade ILIKE '%svømmebad%';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Friluftsbad i ', '(')
WHERE
    TYPE ILIKE 'friluftsbad'
    AND skrivemaade ILIKE '%fribad%';

-----------------
-- Havnebassin --
-----------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'havnebassin';

-- Havnebassin i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'havnebassin'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Havnebassin,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'havnebassin'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

--------------
-- Jernbane --
--------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'jernbane';

-- Jernbane i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'jernbane'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Jernbane,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'jernbane'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Landskabsform --
-------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'landskabsform';

-- Landskabsformer > 50 km**2
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND TYPE ILIKE 'landskabsform'
    AND ST_Area (geometri_udtyndet) > 50000000;

-- Ø'er i store farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type = 'farvand'
            AND s2.area > 400000000
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er i alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type ILIKE 'farvand'
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Ø'er intersects alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type ILIKE 'farvand'
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_Intersects (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'landskabsform'
    AND (stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'ø'
        OR stednavne_udstilling.stednavne_udstilling.subtype ILIKE 'øgruppe')
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- landskabsformer i postnummer
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'landskabsform'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Justeringer af visningstekst (når subtypen oplagt fremgår af skrivemaade)
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Bakke i ', '(')
WHERE
    TYPE ILIKE 'landskabsform'
    AND skrivemaade ILIKE '%Bakke%';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Dal i ', '(')
WHERE
    TYPE ILIKE 'landskabsform'
    AND skrivemaade ILIKE '%Dal%';

---------------
-- Lufthavne --
---------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'lufthavn';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'lufthavn';

----------------
-- Naturareal --
----------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'naturareal';

-- Naturareal i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'naturareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-----------------------
-- Navigationsanlaeg --
-----------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'navigationsanlaeg';

-- Naturareal i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'navigationsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------------
-- Restriktionsanlaeg --
------------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'restriktionsareal';

-- Restriktionsanlaeg i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'restriktionsareal'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

----------
-- Rute --
----------
-- En del af dem bør nok ikke udstilles. F.eks. "10 (Motorvejsafkørselsnummer)"
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'rute';

-- Rute
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    visningstekst IS NULL
    AND TYPE ILIKE 'rute';

------------------
-- Sevaerdighed --
------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'sevaerdighed';

-- Sevaerdighed i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'sevaerdighed'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Sevaerdighed,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'sevaerdighed'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------
-- Terraenkontur --
-------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'terraenkontur';

-- Terraenkontur i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'terraenkontur'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Terraenkontur,  > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'terraenkontur'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

------------------
-- Urentfarvand --
------------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'urentfarvand';

-- Urentfarvand i store farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type ILIKE 'farvand'
            AND s2.area > 400000000
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand i alle farvande
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type ILIKE 'farvand'
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

-- Urentfarvand, intersects
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s1.skrivemaade || ' (' || s1.subtype_presentation || ' i ' || s2.skrivemaade || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s1
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.type ILIKE 'farvand'
            AND s1.geometri_udtyndet && s2.geometri_udtyndet
            AND ST_Intersects (s2.geometri_udtyndet, s1.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'urentfarvand'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s1.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s1.navnefoelgenummer;

--------------
-- Vandloeb --
--------------
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'vandloeb';

-- Vandloeb i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'vandloeb'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Vandloeb, > 50 % i postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, st_envelope (s.geometri_udtyndet))) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'vandloeb'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-------------------------
-- andentopografiflade --
-------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='andentopografiflade' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'andentopografiflade';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'andentopografiflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'andentopografiflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    visningstekst IS NULL
    AND TYPE ILIKE 'andentopografiflade';

-------------------------
-- andentopografipunkt --
-------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='andentopografipunkt' AND visningstekst = NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'andentopografipunkt';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'andentopografipunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Juster broer
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Bro i ', '(')
WHERE
    TYPE ILIKE 'andentopografipunkt'
    AND skrivemaade ILIKE '% bro%';

-- Juster kilder
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Kilde i ', '(')
WHERE
    TYPE ILIKE 'andentopografipunkt'
    AND (skrivemaade ILIKE '%kilde %'
        OR skrivemaade ILIKE '%kilder %');

---------------------
-- faergerutelinje --
---------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='faergerutelinje' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'faergerutelinje';

UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || '(' || subtype_presentation || ')'
WHERE
    TYPE ILIKE 'faergerutelinje'
    AND visningstekst IS NULL;

-------------------
-- idraetsanlaeg --
-------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='idraetsanlaeg' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'idraetsanlaeg';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'idraetsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'idraetsanlaeg'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Juster cykelbaner
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Cykelbane i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND skrivemaade ILIKE '%cykelbane%';

-- Juster golfklubber
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Golfbane i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND skrivemaade ILIKE '% golf%';

-- Juster travbaner og galopbaner
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Hestevæddeløbsbane i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND (skrivemaade ILIKE '%galopbane%'
        OR skrivemaade ILIKE '%travbane%');

-- Juster motocross baner
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Motocrossbane i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND (skrivemaade ILIKE '%motocross%');

-- Juster skydebane
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Skydebane i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND (skrivemaade ILIKE '%skyde%'
        OR skrivemaade ILIKE '%skytteforening%');

-- Juster stadion
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Stadion i ', '(')
WHERE
    TYPE ILIKE 'idraetsanlaeg'
    AND skrivemaade ILIKE '%idræts%';

---------
-- soe --
---------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='soe' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'soe';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 50 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.5 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- > 40 % i et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (p.geometri && s.geometri_udtyndet
            AND st_area (st_intersection (p.geometri, s.geometri_udtyndet)) > 0.4 * s.area)
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'soe'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'soe';

-- Juster Sø
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = replace(visningstekst, '(Sø i ', '(')
WHERE
    TYPE ILIKE 'soe'
    AND (skrivemaade ILIKE '%sø');

---------------------
-- standsningssted --
---------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='standsningssted' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'standsningssted';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || INITCAP(s.type) || ', ' || s.subtype || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'standsningssted'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || INITCAP(TYPE) || ', ' || subtype || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'standsningssted';

--------------------------
-- ubearbejdetnavnflade --
--------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='ubearbejdetnavnflade' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'ubearbejdetnavnflade';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnflade'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnflade';

--------------------------
-- ubearbejdetnavnlinje --
--------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='ubearbejdetnavnlinje' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'ubearbejdetnavnlinje';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnlinje'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnlinje';

--------------------------
-- ubearbejdetnavnpunkt --
--------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='ubearbejdetnavnpunkt' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'ubearbejdetnavnpunkt';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnpunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnpunkt';

--------------------------
-- vej --
--------------------------
-- SELECT * from stednavne_udstilling.stednavne_udstilling where type='vej' AND visningstekst IS NULL;
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = NULL
WHERE
    TYPE ILIKE 'ubearbejdetnavnpunkt';

-- Helt indenfor et postnummerinddeling
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = s.skrivemaade || ' (' || s.subtype_presentation || ' i ' || p.navn || ')'
FROM
    stednavne_udstilling.stednavne_udstilling s
    JOIN dagi_500.postnummerinddeling p ON (ST_contains (p.geometri, s.geometri_udtyndet))
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnpunkt'
    AND stednavne_udstilling.stednavne_udstilling.objectid = s.objectid
    AND stednavne_udstilling.stednavne_udstilling.navnefoelgenummer = s.navnefoelgenummer;

-- Øvrige
UPDATE
    stednavne_udstilling.stednavne_udstilling
SET
    visningstekst = skrivemaade || ' (' || subtype_presentation || ')'
WHERE
    stednavne_udstilling.stednavne_udstilling.visningstekst IS NULL
    AND stednavne_udstilling.stednavne_udstilling.type ILIKE 'ubearbejdetnavnpunkt';

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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype ILIKE 'Halvø'
            AND s2.skrivemaade = 'Jylland'
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'Ø'
            AND s2.area > 50000000
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
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
    JOIN stednavne_udstilling.stednavne_udstilling s2 ON (s2.subtype = 'Ø'
            AND ST_contains (s2.geometri_udtyndet, s1.geometri_udtyndet))
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

-- Tilføj og populer kommunefilter på tabellen
-- Kommunekode needs to be done here and not in 510_api_stednavne as it else results in duplicated kommunekoder in
-- stednavne that has more than one skrivemaade.
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
