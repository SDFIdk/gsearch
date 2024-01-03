CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.navngivenvej CASCADE;

CREATE TYPE api.navngivenvej AS (
    id text,
    vejnavn text,
    supplerendebynavn text,
    visningstekst text,
    postnummer text,
    postnummernavn text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.navngivenvej IS 'Navngivenvej';

COMMENT ON COLUMN api.navngivenvej.id IS 'ID på navngiven vej';

COMMENT ON COLUMN api.navngivenvej.vejnavn IS 'Navn på vej';

COMMENT ON COLUMN api.navngivenvej.supplerendebynavn IS 'Supplerende bynavn(e) for navngiven vej';

COMMENT ON COLUMN api.navngivenvej.visningstekst IS 'Præsentationsform for navngiven vej';

COMMENT ON COLUMN api.navngivenvej.postnummer IS 'Postnummer(postnumre) for navngiven vej';

COMMENT ON COLUMN api.navngivenvej.postnummernavn IS 'Postnummernavn(e) for navngiven vej';

COMMENT ON COLUMN api.navngivenvej.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil navngiven vej';

COMMENT ON COLUMN api.navngivenvej.geometri IS 'Geometri for den navngivne vej i EPSG:25832, linje eller polygon';

COMMENT ON COLUMN api.navngivenvej.bbox IS 'Geometriens boundingbox';
