CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.postnummer CASCADE;

CREATE TYPE api.postnummer AS (
    postnummer text,
    postnummernavn text,
    visningstekst text,
    gadepostnummer bool,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.postnummer IS 'Postnummer';

COMMENT ON COLUMN api.postnummer.postnummer IS 'Postnummer';

COMMENT ON COLUMN api.postnummer.postnummernavn IS 'Navn på postnummernavn';

COMMENT ON COLUMN api.postnummer.visningstekst IS 'Præsentationsform for et postnummernavn';

COMMENT ON COLUMN api.postnummer.gadepostnummer IS 'Dækker postnummeret kun en gade';

COMMENT ON COLUMN api.postnummer.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil postnummeret';

COMMENT ON COLUMN api.postnummer.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.postnummer.bbox IS 'Geometriens boundingbox i EPSG:25832';
