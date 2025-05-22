CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.retskreds CASCADE;

CREATE TYPE api.retskreds AS (
    retskredsnummer int,
    retkredsnavn text,
    visningstekst text,
    myndighedskode text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);