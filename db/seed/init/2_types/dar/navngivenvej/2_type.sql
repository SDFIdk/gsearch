CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.navngivenvej CASCADE;

CREATE TYPE api.navngivenvej AS (
    id text,
    vejnavn text,
    supplerendebynavn text,
    visningstekst text,
    postnummer text,
    postnummernavn text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);