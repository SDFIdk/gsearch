CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.matrikel_udgaaet CASCADE;

CREATE TYPE api.matrikel_udgaaet AS (
    ejerlavsnavn text,
    ejerlavskode text,
    kommunenavn text,
    kommunekode text,
    matrikelnummer text,
    visningstekst text,
    jordstykke_id text,
    bfenummer text,
    centroid_x text,
    centroid_y text,
    geometri geometry
);

COMMENT ON TYPE api.matrikel_udgaaet IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavsnavn IS 'Ejerlavsnavn for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavskode IS 'Ejerlavskode for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunenavn IS 'Kommunenavn for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel_udgaaet.visningstekst IS 'Præsentationsform for et matrikelnummer';

COMMENT ON COLUMN api.matrikel.jordstykke_id IS 'Jordstykke lokalid';

COMMENT ON COLUMN api.matrikel_udgaaet.bfenummer IS 'BFE-nummer for matriklen';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_x IS 'Centroide X for matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_y IS 'Centroide Y for matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.geometri IS 'Geometri i EPSG:25832';
