SELECT '150z_join_stednavne.sql' || now();

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
    
