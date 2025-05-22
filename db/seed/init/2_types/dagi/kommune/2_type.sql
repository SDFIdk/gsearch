CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.kommune CASCADE;

CREATE TYPE api.kommune AS (
    kommunekode text,
    kommunenavn text,
    visningstekst text,
    geometri geometry,
    bbox geometry
    );