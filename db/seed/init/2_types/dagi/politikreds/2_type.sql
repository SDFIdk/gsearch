CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.politikreds CASCADE;

CREATE TYPE api.politikreds AS (
    politikredsnummer int,
    navn text,
    visningstekst text,
    myndighedskode text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);