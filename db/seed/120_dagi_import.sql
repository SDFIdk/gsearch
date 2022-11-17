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

