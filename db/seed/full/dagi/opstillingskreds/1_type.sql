
CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.opstillingskreds CASCADE;

CREATE TYPE api.opstillingskreds AS (
    opstillingskredsnummer text,
    opstillingskredsnavn text,
    visningstekst text,
    valgkredsnummer text,
    storkredsnummer text,
    storkredsnavn text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.opstillingskreds IS 'Opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.opstillingskredsnummer IS 'Opstillingskredsnummer';

COMMENT ON COLUMN api.opstillingskreds.opstillingskredsnavn IS 'Navn på opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.visningstekst IS 'Præsentationsform for en opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.valgkredsnummer IS 'Unik nummer indenfor storkredsen';

COMMENT ON COLUMN api.opstillingskreds.storkredsnummer IS 'Unik nummer for storkreds, som opstillingskredsen tilhører';

COMMENT ON COLUMN api.opstillingskreds.storkredsnavn IS 'Storkredsens unikke navn';

COMMENT ON COLUMN api.opstillingskreds.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil opstillingskredsen';

COMMENT ON COLUMN api.opstillingskreds.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.opstillingskreds.bbox IS 'Geometriens boundingbox i EPSG:25832';
