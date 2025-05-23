CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.region CASCADE;

CREATE TYPE api.region AS (
    regionskode text,
    regionsnavn text,
    visningstekst text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);