-- Create base data
DROP TABLE IF EXISTS g_options;
CREATE TEMPORARY TABLE g_options (maxrows int);
--INSERT INTO g_options VALUES (1000);


-- DAGI


DROP TABLE IF EXISTS dagi_500.kommuneinddeling;
CREATE TABLE dagi_500.kommuneinddeling AS
SELECT * FROM dagi_500_fdw.kommuneinddeling
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.opstillingskreds;
CREATE TABLE dagi_500.opstillingskreds AS
SELECT * FROM dagi_500_fdw.opstillingskreds
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.storkreds;
CREATE TABLE dagi_500.storkreds AS
SELECT * FROM dagi_500_fdw.storkreds
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.politikreds;
CREATE TABLE dagi_500.politikreds AS
SELECT * FROM dagi_500_fdw.politikreds
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.postnummerinddeling;
CREATE TABLE dagi_500.postnummerinddeling AS
SELECT * FROM dagi_500_fdw.postnummerinddeling
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.regionsinddeling;
CREATE TABLE dagi_500.regionsinddeling AS
SELECT * FROM dagi_500_fdw.regionsinddeling
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.retskreds;
CREATE TABLE dagi_500.retskreds AS
SELECT * FROM dagi_500_fdw.retskreds
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_500.sogneinddeling;
CREATE TABLE dagi_500.sogneinddeling AS
SELECT * FROM dagi_500_fdw.sogneinddeling
LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS dagi_10.postnummerinddeling;
CREATE TABLE dagi_10.postnummerinddeling AS
SELECT * FROM dagi_10_fdw.postnummerinddeling
LIMIT (SELECT maxrows FROM g_options);


-- DAR


DROP TABLE IF EXISTS dar.navngivenvej;
CREATE TABLE dar.navngivenvej AS
SELECT
id::uuid,
    vejnavn,
    vejnavnebeliggenhed_vejnavnelinje as geometri
    FROM dar_fdw.dar1_navngivenvej_current
    LIMIT (SELECT maxrows FROM g_options);


    DROP TABLE IF EXISTS dar.navngivenvejpostnummer;
    CREATE TABLE dar.navngivenvejpostnummer AS
    SELECT
    id::uuid,
    navngivenvej_id::uuid as navngivenvej,
    postnummer_id::uuid as postnummer
    --FROM dar_fdw.navngivenvejpostnummer_current
    FROM dar_fdw.dar1_navngivenvejpostnummerrelation_current
    LIMIT (SELECT maxrows FROM g_options);

    DROP TABLE IF EXISTS dar.postnummer;
    CREATE TABLE dar.postnummer AS
    SELECT
    id::uuid,
    navn,
    postnr
    FROM
    dar_fdw.dar1_postnummer_current
    LIMIT (SELECT maxrows FROM g_options);

    CREATE INDEX ON dar.navngivenvej(id);
    CREATE INDEX ON dar.navngivenvej USING gist(geometri);
    CREATE INDEX ON dar.navngivenvejpostnummer(navngivenvej, postnummer);
    CREATE INDEX ON dar.postnummer(id);

    DROP TABLE IF EXISTS dar.adresse;
    CREATE TABLE dar.adresse AS
    SELECT
    id::uuid,
    adressebetegnelse,
    dørbetegnelse,
    dørpunkt_id as doerpunkt,
    etagebetegnelse,
    fk_bbr_bygning_bygning::uuid as bygning,
    husnummer_id::uuid as husnummer
    FROM
    dar_fdw.dar1_adresse
    WHERE upper(virkning) IS NULL
    AND upper(registrering) IS NULL
    LIMIT (SELECT maxrows FROM g_options);


    DROP TABLE IF EXISTS dar.husnummer;
    CREATE TABLE dar.husnummer AS
    SELECT DISTINCT
    h.id::uuid,
    h.adgangsadressebetegnelse,
    h.adgangspunkt_id::uuid as adgangspunkt,
    h.husnummerretning,
    h.husnummertekst,
    h.vejpunkt_id::uuid as vejpunkt,
    h.fk_mu_jordstykke_jordstykke as jordstykke,
    h.fk_mu_jordstykke_foreløbigtplaceretpåjordstykke as placeretpaaforeloebigtjordstykke,
    h.fk_geodk_bygning_geodanmarkbygning as geodanmarkbygning,
    h.fk_bbr_bygning_adgangtilbygning::uuid as adgangtilbygning,
    h.supplerendebynavn_id as supplerendebynavn,
    h.postnummer_id as postnummer,
    '0' || k.kommunekode::text as kommunekode,
    '' AS vejkode,
    h.navngivenvej_id::uuid as navngivenvej
    FROM
    dar_fdw.dar1_husnummer h,
    dar_fdw.dar1_darkommuneinddeling k
    WHERE h.darkommune_id = k.id
    AND upper(h.registrering) IS NULL
    AND upper(h.virkning) IS NULL
    AND upper(k.registrering) IS NULL
    AND upper(k.virkning) IS NULL

    LIMIT (SELECT maxrows FROM g_options);


    DROP TABLE IF EXISTS dar.adressepunkt;
    CREATE TABLE dar.adressepunkt AS
    SELECT
    id::uuid,
    position AS geometri
    FROM
    dar_fdw.dar1_adressepunkt_current ac
    LIMIT (SELECT maxrows FROM g_options);


    -- Indices
    CREATE INDEX ON dar.adresse(husnummer);
    CREATE INDEX ON dar.adresse(adressebetegnelse);
    CREATE INDEX ON dar.husnummer(id);
    CREATE INDEX ON dar.husnummer(navngivenvej);
    CREATE INDEX ON dar.husnummer(vejpunkt);
    CREATE INDEX ON dar.adressepunkt(id);
    CREATE INDEX ON dar.adressepunkt USING gist (geometri);

    -- Primary keys
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_pk PRIMARY KEY (id);
    ALTER TABLE dar.adresse ADD CONSTRAINT adresse_pk PRIMARY KEY (id);
    ALTER TABLE dar.adressepunkt ADD CONSTRAINT adressepunkt_pk PRIMARY KEY (id);

    -- Foreign keys internal to dar
    -- ALTER TABLE dar.adresse ADD CONSTRAINT adresse_husnummer_fk FOREIGN KEY (husnummer) REFERENCES dar.husnummer (id) MATCH FULL;

    DROP TABLE IF EXISTS scratch.dar_husnummer_dar_adgangspunkt_fk;
    WITH invalid_relation AS
(UPDATE dar.husnummer h SET adgangspunkt = NULL WHERE adgangspunkt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.adgangspunkt = a.id) RETURNING *)
    SELECT * INTO scratch.dar_husnummer_dar_adgangspunkt_fk FROM invalid_relation;
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt) REFERENCES dar.adressepunkt (id) MATCH FULL;

    DROP TABLE IF EXISTS scratch.dar_husnummer_dar_vejpunkt_fk;
    WITH invalid_relation AS
(UPDATE dar.husnummer h SET vejpunkt = NULL WHERE vejpunkt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.vejpunkt = a.id) RETURNING *)
    SELECT * INTO scratch.dar_husnummer_dar_vejpunkt_fk FROM invalid_relation;
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt) REFERENCES dar.adressepunkt (id) MATCH FULL;

    ALTER TABLE dar.husnummer ADD CONSTRAINT adresse_husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt) REFERENCES dar.adressepunkt (id) MATCH FULL;
    ALTER TABLE dar.husnummer ADD CONSTRAINT adresse_husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt) REFERENCES dar.adressepunkt (id) MATCH FULL;


-- STEDNAVNE


DROP TABLE IF EXISTS stednavne.vej;
CREATE TABLE stednavne.vej AS
SELECT * FROM stednavne_fdw.vej
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.vandloeb;
CREATE TABLE stednavne.vandloeb AS
SELECT * FROM stednavne_fdw.vandloeb
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.urentfarvand;
CREATE TABLE stednavne.urentfarvand AS
SELECT * FROM stednavne_fdw.urentfarvand
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnpunkt;
CREATE TABLE stednavne.ubearbejdetnavnpunkt AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnpunkt
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnlinje;
CREATE TABLE stednavne.ubearbejdetnavnlinje AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnlinje
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnflade;
CREATE TABLE stednavne.ubearbejdetnavnflade AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnflade
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.terraenkontur;
CREATE TABLE stednavne.terraenkontur AS
SELECT * FROM stednavne_fdw.terraenkontur
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.standsningssted;
CREATE TABLE stednavne.standsningssted AS
SELECT * FROM stednavne_fdw.standsningssted
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.soe;
CREATE TABLE stednavne.soe AS
SELECT * FROM stednavne_fdw.soe
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.sevaerdighed;
CREATE TABLE stednavne.sevaerdighed AS
SELECT * FROM stednavne_fdw.sevaerdighed
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.restriktionsareal;
CREATE TABLE stednavne.restriktionsareal AS
SELECT * FROM stednavne_fdw.restriktionsareal
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.navigationsanlaeg;
CREATE TABLE stednavne.navigationsanlaeg AS
SELECT * FROM stednavne_fdw.navigationsanlaeg
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.naturareal;
CREATE TABLE stednavne.naturareal AS
SELECT * FROM stednavne_fdw.naturareal
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.lufthavn;
CREATE TABLE stednavne.lufthavn AS
SELECT * FROM stednavne_fdw.lufthavn
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.landskabsform;
CREATE TABLE stednavne.landskabsform AS
SELECT * FROM stednavne_fdw.landskabsform
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.jernbane;
CREATE TABLE stednavne.jernbane AS
SELECT * FROM stednavne_fdw.jernbane
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.idraetsanlaeg;
CREATE TABLE stednavne.idraetsanlaeg AS
SELECT * FROM stednavne_fdw.idraetsanlaeg
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.havnebassin;
CREATE TABLE stednavne.havnebassin AS
SELECT * FROM stednavne_fdw.havnebassin
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.friluftsbad;
CREATE TABLE stednavne.friluftsbad AS
SELECT * FROM stednavne_fdw.friluftsbad
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.fortidsminde;
CREATE TABLE stednavne.fortidsminde AS
SELECT * FROM stednavne_fdw.fortidsminde
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.farvand;
CREATE TABLE stednavne.farvand AS
SELECT * FROM stednavne_fdw.farvand
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.campingplads;
CREATE TABLE stednavne.campingplads AS
SELECT * FROM stednavne_fdw.campingplads
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.bygning;
CREATE TABLE stednavne.bygning AS
SELECT * FROM stednavne_fdw.bygning
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.begravelsesplads;
CREATE TABLE stednavne.begravelsesplads AS
SELECT * FROM stednavne_fdw.begravelsesplads
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.bebyggelse;
CREATE TABLE stednavne.bebyggelse AS
SELECT * FROM stednavne_fdw.bebyggelse
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.andentopografipunkt;
CREATE TABLE stednavne.andentopografipunkt AS
SELECT * FROM stednavne_fdw.andentopografipunkt
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.andentopografiflade;
CREATE TABLE stednavne.andentopografiflade AS
SELECT * FROM stednavne_fdw.andentopografiflade
LIMIT (SELECT maxrows FROM g_options);

