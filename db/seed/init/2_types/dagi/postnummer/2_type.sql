CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.postnummer CASCADE;

CREATE TYPE api.postnummer AS (
    postnummer text,
    postnummernavn text,
    visningstekst text,
    gadepostnummer bool,
    kommunekode text,
    geometri geometry,
    bbox geometry
);