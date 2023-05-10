CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.matrikel CASCADE;

CREATE TYPE api.matrikel AS (
    ejerlavsnavn text,
    ejerlavskode text,
    kommunenavn text,
    kommunekode text,
    matrikelnummer text,
    visningstekst text,
    bfenummer text,
    centroid_x text,
    centroid_y text,
    geometri geometry
    );

COMMENT ON TYPE api.matrikel IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel.ejerlavsnavn IS 'Ejerlavsnavn for matrikel';

COMMENT ON COLUMN api.matrikel.ejerlavskode IS 'Ejerlavskode for matrikel';

COMMENT ON COLUMN api.matrikel.kommunenavn IS 'Kommunenavn for matrikel';

COMMENT ON COLUMN api.matrikel.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil matrikel';

COMMENT ON COLUMN api.matrikel.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel.visningstekst IS 'Præsentationsform for et matrikelnummer';

COMMENT ON COLUMN api.matrikel.visningstekst IS 'BFE-nummer for matriklen';

COMMENT ON COLUMN api.matrikel.centroid_x IS 'Centroide X for matriklens geometri';

COMMENT ON COLUMN api.matrikel.centroid_y IS 'Centroide Y for matriklens geometri';

COMMENT ON COLUMN api.matrikel.geometri IS 'Geometri i EPSG:25832';