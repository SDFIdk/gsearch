
CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.region CASCADE;

CREATE TYPE api.region AS (
    regionskode text,
    regionsnavn text,
    visningstekst text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.region IS 'Region';

COMMENT ON COLUMN api.region.regionskode IS 'Regionskode';

COMMENT ON COLUMN api.region.regionsnavn IS 'Navn på region';

COMMENT ON COLUMN api.region.visningstekst IS 'Præsentationsform for en region';

COMMENT ON COLUMN api.region.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil region';

COMMENT ON COLUMN api.region.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.region.bbox IS 'Geometriens boundingbox i EPSG:25832';
