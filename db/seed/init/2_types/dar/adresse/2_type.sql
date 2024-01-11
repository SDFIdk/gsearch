CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.adresse CASCADE;

CREATE TYPE api.adresse AS (
    id text,
    kommunekode text,
    kommunenavn text,
    vejkode text,
    vejnavn text,
    husnummer text,
    etagebetegnelse text,
    doerbetegnelse text,
    supplerendebynavn text,
    postnummer text,
    postnummernavn text,
    visningstekst text,
    geometri geometry,
    vejpunkt_geometri geometry
);

COMMENT ON TYPE api.adresse IS 'Adresse';

COMMENT ON COLUMN api.adresse.id IS 'ID på adresse';

COMMENT ON COLUMN api.adresse.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil en adresse';

COMMENT ON COLUMN api.adresse.kommunenavn IS 'Kommunenavn for adresse';

COMMENT ON COLUMN api.adresse.vejkode IS 'Vejkode for adresse';

COMMENT ON COLUMN api.adresse.vejnavn IS 'Vejnavn for adresse';

COMMENT ON COLUMN api.adresse.husnummer IS 'Husnummer på adresse';

COMMENT ON COLUMN api.adresse.etagebetegnelse IS 'Etagebetegnelse for adresse';

COMMENT ON COLUMN api.adresse.doerbetegnelse IS 'Dørbetegnelse for adresse';

COMMENT ON COLUMN api.adresse.supplerendebynavn IS 'Supplerende bynavn(e) for adresse';

COMMENT ON COLUMN api.adresse.postnummer IS 'Postnummer på adresse';

COMMENT ON COLUMN api.adresse.postnummernavn IS 'Postnummernavn på adresse';

COMMENT ON COLUMN api.adresse.visningstekst IS 'Fulde adresse';

COMMENT ON COLUMN api.adresse.vejpunkt_geometri IS 'Geometri for vejpunkt i EPSG:25832';

COMMENT ON COLUMN api.adresse.geometri IS 'Geometri for adgangspunkt i EPSG:25832';
