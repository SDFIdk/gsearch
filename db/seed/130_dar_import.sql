
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
    navngivenvej_id::uuid,
    postnummer_id::uuid
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
    CREATE INDEX ON dar.navngivenvejpostnummer(navngivenvej_id, postnummer_id);
    CREATE INDEX ON dar.postnummer(id);

    DROP TABLE IF EXISTS dar.adresse;
    CREATE TABLE dar.adresse AS
    SELECT
    id::uuid,
    adressebetegnelse,
    dørbetegnelse,
    dørpunkt_id,
    etagebetegnelse,
    fk_bbr_bygning_bygning::uuid as bygning,
    husnummer_id::uuid
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
    h.adgangspunkt_id::uuid,
    h.husnummerretning,
    h.husnummertekst,
    h.vejpunkt_id::uuid,
    h.fk_mu_jordstykke_jordstykke as jordstykke,
    h.fk_mu_jordstykke_foreløbigtplaceretpåjordstykke as placeretpaaforeloebigtjordstykke,
    h.fk_geodk_bygning_geodanmarkbygning as geodanmarkbygning,
    h.fk_bbr_bygning_adgangtilbygning::uuid as adgangtilbygning,
    h.supplerendebynavn_id,
    h.postnummer_id,
    '0' || k.kommunekode::text as kommunekode,
    '' AS vejkode,
    h.navngivenvej_id::uuid
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
    CREATE INDEX ON dar.adresse(husnummer_id);
    CREATE INDEX ON dar.adresse(adressebetegnelse);
    CREATE INDEX ON dar.husnummer(id);
    CREATE INDEX ON dar.husnummer(navngivenvej_id);
    CREATE INDEX ON dar.husnummer(vejpunkt_id);
    CREATE INDEX ON dar.adressepunkt(id);
    CREATE INDEX ON dar.adressepunkt USING gist (geometri);

    -- Primary keys
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_pk PRIMARY KEY (id);
    ALTER TABLE dar.adresse ADD CONSTRAINT adresse_pk PRIMARY KEY (id);
    ALTER TABLE dar.adressepunkt ADD CONSTRAINT adressepunkt_pk PRIMARY KEY (id);

    -- Foreign keys internal to dar
    -- ALTER TABLE dar.adresse ADD CONSTRAINT adresse_husnummer_fk FOREIGN KEY (husnummer_id) REFERENCES dar.husnummer (id) MATCH FULL;

    DROP TABLE IF EXISTS scratch.dar_husnummer_dar_adgangspunkt_fk;
    WITH invalid_relation AS
(UPDATE dar.husnummer h SET adgangspunkt_id = NULL WHERE adgangspunkt_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.adgangspunkt_id = a.id) RETURNING *)
    SELECT * INTO scratch.dar_husnummer_dar_adgangspunkt_fk FROM invalid_relation;
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

    DROP TABLE IF EXISTS scratch.dar_husnummer_dar_vejpunkt_fk;
    WITH invalid_relation AS
(UPDATE dar.husnummer h SET vejpunkt_id = NULL WHERE vejpunkt_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.vejpunkt_id = a.id) RETURNING *)
    SELECT * INTO scratch.dar_husnummer_dar_vejpunkt_fk FROM invalid_relation;
    ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

    ALTER TABLE dar.husnummer ADD CONSTRAINT adresse_husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;
    ALTER TABLE dar.husnummer ADD CONSTRAINT adresse_husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;


