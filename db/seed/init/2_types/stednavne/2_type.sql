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