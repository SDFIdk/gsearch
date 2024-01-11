CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.matrikel_udgaaet CASCADE;

CREATE TYPE api.matrikel_udgaaet AS (
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

COMMENT ON TYPE api.matrikel_udgaaet IS 'Matrikelnummer udgået';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavsnavn IS 'Ejerlavsnavn for udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavskode IS 'Ejerlavskode for udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunenavn IS 'Kommunenavn for udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.matrikelnummer IS 'Matrikelnummer udgået';

COMMENT ON COLUMN api.matrikel_udgaaet.visningstekst IS 'Præsentationsform for et udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.jordstykke_id IS 'Jordstykke lokalid for udgået matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.bfenummer IS 'BFE-nummer for udgået matrikl';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_x IS 'Centroide X for udgået matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_y IS 'Centroide Y for udgået matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.geometri IS 'Geometri i EPSG:25832 for udgået matrikel';
