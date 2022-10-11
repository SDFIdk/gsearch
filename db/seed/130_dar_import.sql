-- DEBUG

DROP TABLE IF EXISTS g_options;
CREATE TEMPORARY TABLE g_options (maxrows int);
--INSERT INTO g_options VALUES (1000);



-- DAR


DROP TABLE IF EXISTS dar.navngivenvej;

CREATE TABLE dar.navngivenvej AS
SELECT
    id_lokalid::uuid as id,
    vejnavn,
    geometri
FROM dar_fdw.navngivenvej
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS dar.navngivenvejpostnummer;

CREATE TABLE dar.navngivenvejpostnummer AS
SELECT
    id_lokalid::uuid as id,
    navngivenvejlokalid::uuid as navngivenvej_id,
    postnummerlokalid::uuid as postnummer_id
FROM dar_fdw.navngivenvejpostnummer
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS dar.postnummer;

CREATE TABLE dar.postnummer AS
SELECT
    id_lokalid::uuid as id,
    navn,
    postnr
FROM
dar_fdw.postnummer
LIMIT (SELECT maxrows FROM g_options);


CREATE INDEX ON dar.navngivenvej(id);
CREATE INDEX ON dar.navngivenvej USING gist(geometri);
CREATE INDEX ON dar.navngivenvejpostnummer(navngivenvej_id, postnummer_id);
CREATE INDEX ON dar.postnummer(id);


DROP TABLE IF EXISTS dar.adresse;

CREATE TABLE dar.adresse (
    id uuid PRIMARY KEY,
    adressebetegnelse varchar,
    doerbetegnelse varchar,
    doerpunkt_id uuid,
    etagebetegnelse varchar,
    bygning_id uuid,
    husnummer_id uuid
);

CREATE INDEX ON dar.adresse(husnummer_id);
CREATE INDEX ON dar.adresse(adressebetegnelse);

INSERT INTO dar.adresse
SELECT DISTINCT
    id_lokalid::uuid as id,
    adressebetegnelse,
    doerbetegnelse,
    doerpunktlokalid::uuid,
    etagebetegnelse,
    bygninglokalid::uuid,
    husnummerlokalid::uuid as husnummer_id
FROM
    dar_fdw.adresse
LIMIT (SELECT maxrows FROM g_options);
ON CONFLICT DO NOTHING;


DROP TABLE IF EXISTS dar.husnummer;

CREATE TABLE dar.husnummer AS
SELECT DISTINCT
    h.id_lokalid AS id,
    h.adgangsadressebetegnelse,
    h.adgangspunktlokalid::uuid AS adgangspunkt_id,
    h.geometri AS husnummerretning,
    h.husnummertekst,
    h.vejpunktlokalid::uuid AS vejpunkt_id,
    h.jordstykkelokalid AS jordstykke_id,
    h.plapaaflbgjordstykkelokalid AS placeretpaaforeloebigtjordstykke_id,
    h.geodanmarkbygninglokalid AS geodanmarkbygning_id,
    h.adgangtilbygninglokalid::uuid AS adgangtilbygning_id,
    h.supplerendebynavnlokalid::uuid AS supplerendebynavn_id,
    h.postnummerlokalid::uuid as postnummer_id,
    left(h.vejmidtelokalid, 4) AS kommunekode,
    right(h.vejmidtelokalid, 4) AS vejkode,
    h.navngivenvejlokalid::uuid as navngivenvej_id
FROM
    dar_fdw.husnummer h
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS dar.adressepunkt;

CREATE TABLE dar.adressepunkt (
    id uuid PRIMARY KEY,
    geometri geometry
);

CREATE INDEX ON dar.adressepunkt(id);
CREATE INDEX ON dar.adressepunkt USING gist (geometri);

INSERT INTO dar.adressepunkt
SELECT DISTINCT
    id_lokalid::uuid,
    geometri
FROM
    dar_fdw.adressepunkt
LIMIT (SELECT maxrows FROM g_options);
ON CONFLICT DO NOTHING;


/*
CREATE TABLE dar.adressepunkt AS
SELECT
    id_lokalid as id,
    geometri
FROM dar_fdw.adressepunkt
LIMIT (SELECT maxrows FROM g_options);
*/


-- Indices
CREATE INDEX ON dar.husnummer(id);
CREATE INDEX ON dar.husnummer(navngivenvej_id);
CREATE INDEX ON dar.husnummer(vejpunkt_id);

-- Primary keys
-- ELVIS -- ALTER TABLE dar.husnummer ADD CONSTRAINT husnummer_pk PRIMARY KEY (id);
-- ELVIS -- ALTER TABLE dar.adresse ADD CONSTRAINT adresse_pk PRIMARY KEY (id);
-- ELVIS -- ALTER TABLE dar.adressepunkt ADD CONSTRAINT adressepunkt_pk PRIMARY KEY (id);

-- Foreign keys internal to dar
-- ALTER TABLE dar.adresse ADD CONSTRAINT adresse_husnummer_fk FOREIGN KEY (husnummer_id) REFERENCES dar.husnummer (id) MATCH FULL;


DROP TABLE IF EXISTS scratch.dar_husnummer_dar_adgangspunkt_fk;

WITH invalid_relation AS
    (UPDATE dar.husnummer h SET adgangspunkt_id = NULL WHERE adgangspunkt_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.adgangspunkt_id = a.id) RETURNING *)
SELECT * 
INTO scratch.dar_husnummer_dar_adgangspunkt_fk 
FROM invalid_relation;
ALTER TABLE dar.husnummer 
ADD CONSTRAINT husnummer_adgangspunkt_fk 
FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;


DROP TABLE IF EXISTS scratch.dar_husnummer_dar_vejpunkt_fk;
WITH invalid_relation AS
(UPDATE dar.husnummer h SET vejpunkt_id = NULL WHERE vejpunkt_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dar.adressepunkt a WHERE h.vejpunkt_id::uuid = a.id) RETURNING *)
SELECT * 
INTO scratch.dar_husnummer_dar_vejpunkt_fk 
FROM invalid_relation;

ALTER TABLE dar.husnummer 
ADD CONSTRAINT husnummer_vejpunkt_fk 
FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

ALTER TABLE dar.husnummer 
ADD CONSTRAINT adresse_husnummer_adgangspunkt_fk 
FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

ALTER TABLE dar.husnummer 
ADD CONSTRAINT adresse_husnummer_vejpunkt_fk 
FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;


