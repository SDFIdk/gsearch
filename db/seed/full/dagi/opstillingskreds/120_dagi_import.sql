SELECT '120_dagi_import.sql ' || now();


-- DEBUG
DROP TABLE IF EXISTS g_options;

CREATE TEMPORARY TABLE g_options (
    maxrows int
);

--INSERT INTO g_options VALUES (1000);
-- DAGI
DROP TABLE IF EXISTS dagi_500.kommuneinddeling;

CREATE TABLE dagi_500.kommuneinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.kommuneinddeling
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.kommuneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.kommuneinddeling;


DROP TABLE IF EXISTS dagi_500.opstillingskreds;

CREATE TABLE dagi_500.opstillingskreds AS
SELECT
    *
FROM
    dagi_500_fdw.opstillingskreds
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.opstillingskreds USING gist (geometri);
VACUUM ANALYZE dagi_500.opstillingskreds;


DROP TABLE IF EXISTS dagi_500.storkreds;

CREATE TABLE dagi_500.storkreds AS
SELECT
    *
FROM
    dagi_500_fdw.storkreds
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.storkreds USING gist (geometri);
VACUUM ANALYZE dagi_500.storkreds;


DROP TABLE IF EXISTS dagi_500.politikreds;

CREATE TABLE dagi_500.politikreds AS
SELECT
    *
FROM
    dagi_500_fdw.politikreds
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.politikreds USING gist (geometri);
VACUUM ANALYZE dagi_500.politikreds;


DROP TABLE IF EXISTS dagi_500.postnummerinddeling;

CREATE TABLE dagi_500.postnummerinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.postnummerinddeling
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.postnummerinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.postnummerinddeling;


DROP TABLE IF EXISTS dagi_500.regionsinddeling;

CREATE TABLE dagi_500.regionsinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.regionsinddeling
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.regionsinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.regionsinddeling;


DROP TABLE IF EXISTS dagi_500.retskreds;

CREATE TABLE dagi_500.retskreds AS
SELECT
    *
FROM
    dagi_500_fdw.retskreds
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.retskreds USING gist (geometri);
VACUUM ANALYZE dagi_500.retskreds;


DROP TABLE IF EXISTS dagi_500.sogneinddeling;

CREATE TABLE dagi_500.sogneinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.sogneinddeling
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_500.sogneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.sogneinddeling;


DROP TABLE IF EXISTS dagi_10.kommuneinddeling;

CREATE TABLE dagi_10.kommuneinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.kommuneinddeling
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.kommuneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.kommuneinddeling;


DROP TABLE IF EXISTS dagi_10.opstillingskreds;

CREATE TABLE dagi_10.opstillingskreds AS
SELECT
    *
FROM
    dagi_10_fdw.opstillingskreds
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.opstillingskreds USING gist (geometri);
VACUUM ANALYZE dagi_10.opstillingskreds;


DROP TABLE IF EXISTS dagi_10.storkreds;

CREATE TABLE dagi_10.storkreds AS
SELECT
    *
FROM
    dagi_10_fdw.storkreds
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.storkreds USING gist (geometri);
VACUUM ANALYZE dagi_10.storkreds;


DROP TABLE IF EXISTS dagi_10.politikreds;

CREATE TABLE dagi_10.politikreds AS
SELECT
    *
FROM
    dagi_10_fdw.politikreds
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.politikreds USING gist (geometri);
VACUUM ANALYZE dagi_10.politikreds;


DROP TABLE IF EXISTS dagi_10.postnummerinddeling;

CREATE TABLE dagi_10.postnummerinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.postnummerinddeling
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.postnummerinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.postnummerinddeling;


DROP TABLE IF EXISTS dagi_10.regionsinddeling;

CREATE TABLE dagi_10.regionsinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.regionsinddeling
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.regionsinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.regionsinddeling;


DROP TABLE IF EXISTS dagi_10.retskreds;

CREATE TABLE dagi_10.retskreds AS
SELECT
    *
FROM
    dagi_10_fdw.retskreds
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.retskreds USING gist (geometri);
VACUUM ANALYZE dagi_10.retskreds;


DROP TABLE IF EXISTS dagi_10.sogneinddeling;

CREATE TABLE dagi_10.sogneinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.sogneinddeling
        LIMIT (
               SELECT
                   maxrows
    FROM
        g_options);

CREATE INDEX ON dagi_10.sogneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.sogneinddeling;