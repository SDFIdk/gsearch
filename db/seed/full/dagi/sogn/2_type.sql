CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.sogn CASCADE;

CREATE TYPE api.sogn AS (
    sognekode text,
    sognenavn text,
    visningstekst text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.sogn IS 'Sogn';

COMMENT ON COLUMN api.sogn.sognekode IS 'Sognekode';

COMMENT ON COLUMN api.sogn.sognenavn IS 'Navn på sogn';

COMMENT ON COLUMN api.sogn.visningstekst IS 'Præsentationsform for et sogn';

COMMENT ON COLUMN api.sogn.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil sogn';

COMMENT ON COLUMN api.sogn.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.sogn.bbox IS 'Geometriens boundingbox i EPSG:25832';
