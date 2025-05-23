CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.opstillingskreds CASCADE;

CREATE TYPE api.opstillingskreds AS (
    opstillingskredsnummer int,
    opstillingskredsnavn text,
    visningstekst text,
    valgkredsnummer int,
    storkredsnummer int,
    storkredsnavn text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);