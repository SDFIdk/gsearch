CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.kommune CASCADE;

CREATE TYPE api.kommune AS (
    kommunekode text,
    kommunenavn text,
    visningstekst text,
    geometri geometry,
    bbox geometry
    );

COMMENT ON TYPE api.kommune IS 'Kommune';

COMMENT ON COLUMN api.kommune.kommunekode IS 'Kommunekode';

COMMENT ON COLUMN api.kommune.kommunenavn IS 'Navn på kommune';

COMMENT ON COLUMN api.kommune.visningstekst IS 'Præsentationsform for en kommune';

COMMENT ON COLUMN api.kommune.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.kommune.bbox IS 'Geometriens boundingbox i EPSG:25832';
