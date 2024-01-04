CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.retskreds CASCADE;

CREATE TYPE api.retskreds AS (
    retskredsnummer text,
    retkredsnavn text,
    visningstekst text,
    myndighedskode text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.retskreds IS 'Retskreds';

COMMENT ON COLUMN api.retskreds.retskredsnummer IS 'Retskredsnummer';

COMMENT ON COLUMN api.retskreds.retkredsnavn IS 'Navn på retskreds';

COMMENT ON COLUMN api.retskreds.visningstekst IS 'Præsentationsform for en retskreds';

COMMENT ON COLUMN api.retskreds.myndighedskode IS 'Retskredsens myndighedskode. Er unik for hver retskreds. 4 cifre.';

COMMENT ON COLUMN api.retskreds.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil retskredsen';

COMMENT ON COLUMN api.retskreds.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.retskreds.bbox IS 'Geometriens boundingbox i EPSG:25832';
