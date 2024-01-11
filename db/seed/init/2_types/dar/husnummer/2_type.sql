CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.husnummer CASCADE;

CREATE TYPE api.husnummer AS (
    id text,
    kommunekode text,
    kommunenavn text,
    vejkode text,
    vejnavn text,
    husnummertekst text,
    supplerendebynavn text,
    postnummer text,
    postnummernavn text,
    visningstekst text,
    geometri geometry,
    vejpunkt_geometri geometry
);

COMMENT ON TYPE api.husnummer IS 'Husnummer';

COMMENT ON COLUMN api.husnummer.id IS 'ID på husnummer';

COMMENT ON COLUMN api.husnummer.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil et husnummer';

COMMENT ON COLUMN api.husnummer.kommunenavn IS 'Kommunenavn for husnummer';

COMMENT ON COLUMN api.husnummer.vejkode IS 'Vejkode for husnummer';

COMMENT ON COLUMN api.husnummer.vejnavn IS 'Vejnavn for husnummer';

COMMENT ON COLUMN api.husnummer.husnummertekst IS 'Husnummertekst evt. med bogstavsbetegnelse';

COMMENT ON COLUMN api.husnummer.supplerendebynavn IS 'Supplerende bynavn(e) for husnummer';

COMMENT ON COLUMN api.husnummer.postnummer IS 'Postnummer for husnummer';

COMMENT ON COLUMN api.husnummer.postnummernavn IS 'Postnummernavn for husnummer';

COMMENT ON COLUMN api.husnummer.visningstekst IS 'Adgangsadresse for husnummer';

COMMENT ON COLUMN api.husnummer.vejpunkt_geometri IS 'Geometri for vejpunkt i EPSG:25832';

COMMENT ON COLUMN api.husnummer.geometri IS 'Geometri for adgangspunkt i EPSG:25832';
