CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.politikreds CASCADE;

CREATE TYPE api.politikreds AS (
    politikredsnummer int,
    navn text,
    visningstekst text,
    myndighedskode text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.politikreds IS 'politikreds';

COMMENT ON COLUMN api.politikreds.politikredsnummer IS 'Politikredsnummer';

COMMENT ON COLUMN api.politikreds.visningstekst IS 'Præsentationsform for en politikreds';

COMMENT ON COLUMN api.politikreds.navn IS 'Navn på politikreds';

COMMENT ON COLUMN api.politikreds.myndighedskode IS 'Politikredsens myndighedskode. Er unik for hver politikreds. 4 cifre.';

COMMENT ON COLUMN api.politikreds.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil politikreds';

COMMENT ON COLUMN api.politikreds.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.politikreds.bbox IS 'Geometriens boundingbox i EPSG:25832';
