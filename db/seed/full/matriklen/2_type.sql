CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.matrikel CASCADE;

CREATE TYPE api.matrikel AS (
    ejerlavsnavn text,
    ejerlavskode int,
    kommunenavn text,
    kommunekode text,
    matrikelnummer text,
    visningstekst text,
    jordstykke_id int,
    bfenummer int,
    centroid_x numeric,
    centroid_y numeric,
    geometri geometry
    );

COMMENT ON TYPE api.matrikel IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel.ejerlavsnavn IS 'Ejerlavsnavn for matrikel';

COMMENT ON COLUMN api.matrikel.ejerlavskode IS 'Ejerlavskode for matrikel';

COMMENT ON COLUMN api.matrikel.kommunenavn IS 'Kommunenavn for matrikel';

COMMENT ON COLUMN api.matrikel.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil matrikel';

COMMENT ON COLUMN api.matrikel.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel.visningstekst IS 'Præsentationsform for et matrikel';

COMMENT ON COLUMN api.matrikel.jordstykke_id IS 'Jordstykke lokalid';

COMMENT ON COLUMN api.matrikel.bfenummer IS 'BFE-nummer for matrikel';

COMMENT ON COLUMN api.matrikel.centroid_x IS 'Centroide X for matriklens geometri';

COMMENT ON COLUMN api.matrikel.centroid_y IS 'Centroide Y for matriklens geometri';

COMMENT ON COLUMN api.matrikel.geometri IS 'Geometri i EPSG:25832 for matrikel';
