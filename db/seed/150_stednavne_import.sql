SELECT '150_stednavne_import.sql ' || now();


-- DEBUG
DROP TABLE IF EXISTS g_options CASCADE;

CREATE TEMPORARY TABLE g_options (
    maxrows int
);

--INSERT INTO g_options VALUES (1000);
-- STEDNAVNE
DROP TABLE IF EXISTS stednavne.vej CASCADE;

CREATE TABLE stednavne.vej AS
SELECT
    *
FROM
    stednavne_fdw.vej
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.vandloeb CASCADE;

CREATE TABLE stednavne.vandloeb AS
SELECT
    *
FROM
    stednavne_fdw.vandloeb
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.urentfarvand CASCADE;

CREATE TABLE stednavne.urentfarvand AS
SELECT
    *
FROM
    stednavne_fdw.urentfarvand
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnpunkt CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnpunkt AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnpunkt
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnlinje CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnlinje AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnlinje
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnflade CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnflade AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnflade
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.terraenkontur CASCADE;

CREATE TABLE stednavne.terraenkontur AS
SELECT
    *
FROM
    stednavne_fdw.terraenkontur
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.standsningssted CASCADE;

CREATE TABLE stednavne.standsningssted AS
SELECT
    *
FROM
    stednavne_fdw.standsningssted
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.soe CASCADE;

CREATE TABLE stednavne.soe AS
SELECT
    *
FROM
    stednavne_fdw.soe
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.sevaerdighed CASCADE;

CREATE TABLE stednavne.sevaerdighed AS
SELECT
    *
FROM
    stednavne_fdw.sevaerdighed
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.restriktionsareal CASCADE;

CREATE TABLE stednavne.restriktionsareal AS
SELECT
    *
FROM
    stednavne_fdw.restriktionsareal
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.navigationsanlaeg CASCADE;

CREATE TABLE stednavne.navigationsanlaeg AS
SELECT
    *
FROM
    stednavne_fdw.navigationsanlaeg
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.naturareal CASCADE;

CREATE TABLE stednavne.naturareal AS
SELECT
    *
FROM
    stednavne_fdw.naturareal
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.lufthavn CASCADE;

CREATE TABLE stednavne.lufthavn AS
SELECT
    *
FROM
    stednavne_fdw.lufthavn
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.landskabsform CASCADE;

CREATE TABLE stednavne.landskabsform AS
SELECT
    *
FROM
    stednavne_fdw.landskabsform
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.jernbane CASCADE;

CREATE TABLE stednavne.jernbane AS
SELECT
    *
FROM
    stednavne_fdw.jernbane
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.idraetsanlaeg CASCADE;

CREATE TABLE stednavne.idraetsanlaeg AS
SELECT
    *
FROM
    stednavne_fdw.idraetsanlaeg
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.havnebassin CASCADE;

CREATE TABLE stednavne.havnebassin AS
SELECT
    *
FROM
    stednavne_fdw.havnebassin
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.friluftsbad CASCADE;

CREATE TABLE stednavne.friluftsbad AS
SELECT
    *
FROM
    stednavne_fdw.friluftsbad
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.fortidsminde CASCADE;

CREATE TABLE stednavne.fortidsminde AS
SELECT
    *
FROM
    stednavne_fdw.fortidsminde
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.farvand CASCADE;

CREATE TABLE stednavne.farvand AS
SELECT
    *
FROM
    stednavne_fdw.farvand
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.campingplads CASCADE;

CREATE TABLE stednavne.campingplads AS
SELECT
    *
FROM
    stednavne_fdw.campingplads
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.bygning CASCADE;

CREATE TABLE stednavne.bygning AS
SELECT
    *
FROM
    stednavne_fdw.bygning
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.begravelsesplads CASCADE;

CREATE TABLE stednavne.begravelsesplads AS
SELECT
    *
FROM
    stednavne_fdw.begravelsesplads
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.bebyggelse CASCADE;

CREATE TABLE stednavne.bebyggelse AS
SELECT
    *
FROM
    stednavne_fdw.bebyggelse
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.andentopografipunkt CASCADE;

CREATE TABLE stednavne.andentopografipunkt AS
SELECT
    *
FROM
    stednavne_fdw.andentopografipunkt
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.andentopografiflade CASCADE;

CREATE TABLE stednavne.andentopografiflade AS
SELECT
    *
FROM
    stednavne_fdw.andentopografiflade
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS stednavne.stednavn CASCADE;

CREATE TABLE stednavne.stednavn AS
SELECT
    *
FROM
    stednavne_fdw.stednavn
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

