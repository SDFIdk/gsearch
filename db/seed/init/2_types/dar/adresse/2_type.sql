CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.adresse CASCADE;

CREATE TYPE api.adresse AS (
    id text,
    kommunekode text,
    kommunenavn text,
    vejkode text,
    vejnavn text,
    husnummer text,
    etagebetegnelse text,
    doerbetegnelse text,
    supplerendebynavn text,
    postnummer text,
    postnummernavn text,
    visningstekst text,
    geometri geometry,
    vejpunkt_geometri geometry
);