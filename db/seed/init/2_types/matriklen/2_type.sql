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
