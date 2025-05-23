CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.sogn CASCADE;

CREATE TYPE api.sogn AS (
    sognekode text,
    sognenavn text,
    visningstekst text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);
