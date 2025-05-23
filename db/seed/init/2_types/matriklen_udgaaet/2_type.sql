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