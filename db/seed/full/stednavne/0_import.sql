-- STEDNAVNE
DROP TABLE IF EXISTS stednavne.vej CASCADE;

CREATE TABLE stednavne.vej AS
SELECT
    *
FROM
    stednavne_fdw.vej;

DROP TABLE IF EXISTS stednavne.vandloeb CASCADE;

CREATE TABLE stednavne.vandloeb AS
SELECT
    *
FROM
    stednavne_fdw.vandloeb;

DROP TABLE IF EXISTS stednavne.urentfarvand CASCADE;

CREATE TABLE stednavne.urentfarvand AS
SELECT
    *
FROM
    stednavne_fdw.urentfarvand;

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnpunkt CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnpunkt AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnpunkt;

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnlinje CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnlinje AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnlinje;

DROP TABLE IF EXISTS stednavne.ubearbejdetnavnflade CASCADE;

CREATE TABLE stednavne.ubearbejdetnavnflade AS
SELECT
    *
FROM
    stednavne_fdw.ubearbejdetnavnflade;

DROP TABLE IF EXISTS stednavne.terraenkontur CASCADE;

CREATE TABLE stednavne.terraenkontur AS
SELECT
    *
FROM
    stednavne_fdw.terraenkontur;

DROP TABLE IF EXISTS stednavne.standsningssted CASCADE;

CREATE TABLE stednavne.standsningssted AS
SELECT
    *
FROM
    stednavne_fdw.standsningssted;

DROP TABLE IF EXISTS stednavne.soe CASCADE;

CREATE TABLE stednavne.soe AS
SELECT
    *
FROM
    stednavne_fdw.soe;

DROP TABLE IF EXISTS stednavne.sevaerdighed CASCADE;

CREATE TABLE stednavne.sevaerdighed AS
SELECT
    *
FROM
    stednavne_fdw.sevaerdighed;

DROP TABLE IF EXISTS stednavne.restriktionsareal CASCADE;

CREATE TABLE stednavne.restriktionsareal AS
SELECT
    *
FROM
    stednavne_fdw.restriktionsareal;

DROP TABLE IF EXISTS stednavne.navigationsanlaeg CASCADE;

CREATE TABLE stednavne.navigationsanlaeg AS
SELECT
    *
FROM
    stednavne_fdw.navigationsanlaeg;

DROP TABLE IF EXISTS stednavne.naturareal CASCADE;

CREATE TABLE stednavne.naturareal AS
SELECT
    *
FROM
    stednavne_fdw.naturareal;

DROP TABLE IF EXISTS stednavne.lufthavn CASCADE;

CREATE TABLE stednavne.lufthavn AS
SELECT
    *
FROM
    stednavne_fdw.lufthavn;

DROP TABLE IF EXISTS stednavne.landskabsform CASCADE;

CREATE TABLE stednavne.landskabsform AS
SELECT
    *
FROM
    stednavne_fdw.landskabsform;

DROP TABLE IF EXISTS stednavne.jernbane CASCADE;

CREATE TABLE stednavne.jernbane AS
SELECT
    *
FROM
    stednavne_fdw.jernbane;

DROP TABLE IF EXISTS stednavne.idraetsanlaeg CASCADE;

CREATE TABLE stednavne.idraetsanlaeg AS
SELECT
    *
FROM
    stednavne_fdw.idraetsanlaeg;

DROP TABLE IF EXISTS stednavne.havnebassin CASCADE;

CREATE TABLE stednavne.havnebassin AS
SELECT
    *
FROM
    stednavne_fdw.havnebassin;

DROP TABLE IF EXISTS stednavne.friluftsbad CASCADE;

CREATE TABLE stednavne.friluftsbad AS
SELECT
    *
FROM
    stednavne_fdw.friluftsbad;

DROP TABLE IF EXISTS stednavne.fortidsminde CASCADE;

CREATE TABLE stednavne.fortidsminde AS
SELECT
    *
FROM
    stednavne_fdw.fortidsminde;

DROP TABLE IF EXISTS stednavne.farvand CASCADE;

CREATE TABLE stednavne.farvand AS
SELECT
    *
FROM
    stednavne_fdw.farvand;

DROP TABLE IF EXISTS stednavne.campingplads CASCADE;

CREATE TABLE stednavne.campingplads AS
SELECT
    *
FROM
    stednavne_fdw.campingplads;

DROP TABLE IF EXISTS stednavne.bygning CASCADE;

CREATE TABLE stednavne.bygning AS
SELECT
    *
FROM
    stednavne_fdw.bygning;

DROP TABLE IF EXISTS stednavne.begravelsesplads CASCADE;

CREATE TABLE stednavne.begravelsesplads AS
SELECT
    *
FROM
    stednavne_fdw.begravelsesplads;

DROP TABLE IF EXISTS stednavne.bebyggelse CASCADE;

CREATE TABLE stednavne.bebyggelse AS
SELECT
    *
FROM
    stednavne_fdw.bebyggelse;

DROP TABLE IF EXISTS stednavne.andentopografipunkt CASCADE;

CREATE TABLE stednavne.andentopografipunkt AS
SELECT
    *
FROM
    stednavne_fdw.andentopografipunkt;

DROP TABLE IF EXISTS stednavne.andentopografiflade CASCADE;

CREATE TABLE stednavne.andentopografiflade AS
SELECT
    *
FROM
    stednavne_fdw.andentopografiflade;

DROP TABLE IF EXISTS stednavne.stednavn CASCADE;

CREATE TABLE stednavne.stednavn AS
SELECT
    *
FROM
    stednavne_fdw.stednavn;


CREATE INDEX ON stednavne.andentopografiflade USING btree (objectid);

CREATE INDEX ON stednavne.andentopografipunkt USING btree (objectid);

CREATE INDEX ON stednavne.bebyggelse USING btree (objectid);

CREATE INDEX ON stednavne.begravelsesplads USING btree (objectid);

CREATE INDEX ON stednavne.bygning USING btree (objectid);

CREATE INDEX ON stednavne.campingplads USING btree (objectid);

CREATE INDEX ON stednavne.farvand USING btree (objectid);

CREATE INDEX ON stednavne.fortidsminde USING btree (objectid);

CREATE INDEX ON stednavne.friluftsbad USING btree (objectid);

CREATE INDEX ON stednavne.havnebassin USING btree (objectid);

CREATE INDEX ON stednavne.idraetsanlaeg USING btree (objectid);

CREATE INDEX ON stednavne.jernbane USING btree (objectid);

CREATE INDEX ON stednavne.landskabsform USING btree (objectid);

CREATE INDEX ON stednavne.lufthavn USING btree (objectid);

CREATE INDEX ON stednavne.naturareal USING btree (objectid);

CREATE INDEX ON stednavne.navigationsanlaeg USING btree (objectid);

CREATE INDEX ON stednavne.restriktionsareal USING btree (objectid);

CREATE INDEX ON stednavne.sevaerdighed USING btree (objectid);

CREATE INDEX ON stednavne.soe USING btree (objectid);

CREATE INDEX ON stednavne.standsningssted USING btree (objectid);

CREATE INDEX ON stednavne.terraenkontur USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnflade USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnlinje USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnpunkt USING btree (objectid);

CREATE INDEX ON stednavne.urentfarvand USING btree (objectid);

CREATE INDEX ON stednavne.vandloeb USING btree (objectid);

CREATE INDEX ON stednavne.vej USING btree (objectid);

CREATE INDEX ON stednavne.stednavn USING btree (navngivetsted_objectid);
