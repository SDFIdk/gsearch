CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.stednavn CASCADE;

CREATE TYPE api.stednavn AS (
    id text,
    skrivemaade text,
    visningstekst text,
    skrivemaade_officiel text,
    skrivemaade_uofficiel text,
    stednavn_type text,
    stednavn_subtype text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.stednavn IS 'Stednavn';

COMMENT ON COLUMN api.stednavn.id IS 'UUID for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade IS 'Skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.visningstekst IS 'Præsentationsform for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade_officiel IS 'Officiel skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade_uofficiel IS 'Uofficiel skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.stednavn_type IS 'Featuretype på stednavn';

COMMENT ON COLUMN api.stednavn.stednavn_subtype IS 'Topografitype på stednavn';

COMMENT ON COLUMN api.stednavn.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil stednavn';

COMMENT ON COLUMN api.stednavn.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.stednavn.bbox IS 'Geometriens boundingbox i EPSG:25832';
