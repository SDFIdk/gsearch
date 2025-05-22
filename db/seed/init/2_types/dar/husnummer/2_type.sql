CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.husnummer CASCADE;

CREATE TYPE api.husnummer AS (
    id text,
    kommunekode text,
    kommunenavn text,
    vejkode text,
    vejnavn text,
    husnummertekst text,
    supplerendebynavn text,
    postnummer text,
    postnummernavn text,
    visningstekst text,
    geometri geometry,
    vejpunkt_geometri geometry
);