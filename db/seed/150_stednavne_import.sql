-- STEDNAVNE


DROP TABLE IF EXISTS stednavne.vej;
CREATE TABLE stednavne.vej AS
SELECT * FROM stednavne_fdw.vej
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.vandloeb;
CREATE TABLE stednavne.vandloeb AS
SELECT * FROM stednavne_fdw.vandloeb
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.urentfarvand;
CREATE TABLE stednavne.urentfarvand AS
SELECT * FROM stednavne_fdw.urentfarvand
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnpunkt;
CREATE TABLE stednavne.ubearbejdetnavnpunkt AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnpunkt
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnlinje;
CREATE TABLE stednavne.ubearbejdetnavnlinje AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnlinje
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.ubearbejdetnavnflade;
CREATE TABLE stednavne.ubearbejdetnavnflade AS
SELECT * FROM stednavne_fdw.ubearbejdetnavnflade
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.terraenkontur;
CREATE TABLE stednavne.terraenkontur AS
SELECT * FROM stednavne_fdw.terraenkontur
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.standsningssted;
CREATE TABLE stednavne.standsningssted AS
SELECT * FROM stednavne_fdw.standsningssted
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.soe;
CREATE TABLE stednavne.soe AS
SELECT * FROM stednavne_fdw.soe
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.sevaerdighed;
CREATE TABLE stednavne.sevaerdighed AS
SELECT * FROM stednavne_fdw.sevaerdighed
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.restriktionsareal;
CREATE TABLE stednavne.restriktionsareal AS
SELECT * FROM stednavne_fdw.restriktionsareal
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.navigationsanlaeg;
CREATE TABLE stednavne.navigationsanlaeg AS
SELECT * FROM stednavne_fdw.navigationsanlaeg
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.naturareal;
CREATE TABLE stednavne.naturareal AS
SELECT * FROM stednavne_fdw.naturareal
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.lufthavn;
CREATE TABLE stednavne.lufthavn AS
SELECT * FROM stednavne_fdw.lufthavn
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.landskabsform;
CREATE TABLE stednavne.landskabsform AS
SELECT * FROM stednavne_fdw.landskabsform
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.jernbane;
CREATE TABLE stednavne.jernbane AS
SELECT * FROM stednavne_fdw.jernbane
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.idraetsanlaeg;
CREATE TABLE stednavne.idraetsanlaeg AS
SELECT * FROM stednavne_fdw.idraetsanlaeg
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.havnebassin;
CREATE TABLE stednavne.havnebassin AS
SELECT * FROM stednavne_fdw.havnebassin
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.friluftsbad;
CREATE TABLE stednavne.friluftsbad AS
SELECT * FROM stednavne_fdw.friluftsbad
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.fortidsminde;
CREATE TABLE stednavne.fortidsminde AS
SELECT * FROM stednavne_fdw.fortidsminde
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.farvand;
CREATE TABLE stednavne.farvand AS
SELECT * FROM stednavne_fdw.farvand
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.campingplads;
CREATE TABLE stednavne.campingplads AS
SELECT * FROM stednavne_fdw.campingplads
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.bygning;
CREATE TABLE stednavne.bygning AS
SELECT * FROM stednavne_fdw.bygning
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.begravelsesplads;
CREATE TABLE stednavne.begravelsesplads AS
SELECT * FROM stednavne_fdw.begravelsesplads
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.bebyggelse;
CREATE TABLE stednavne.bebyggelse AS
SELECT * FROM stednavne_fdw.bebyggelse
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.andentopografipunkt;
CREATE TABLE stednavne.andentopografipunkt AS
SELECT * FROM stednavne_fdw.andentopografipunkt
LIMIT (SELECT maxrows FROM g_options);


DROP TABLE IF EXISTS stednavne.andentopografiflade;
CREATE TABLE stednavne.andentopografiflade AS
SELECT * FROM stednavne_fdw.andentopografiflade
LIMIT (SELECT maxrows FROM g_options);


