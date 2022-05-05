-- bebyggelse
CREATE OR REPLACE VIEW stednavne_udstil.vw_bebyggelse AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  dkstednavne.bebyggelse t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  dkstednavne.bebyggelse t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  dkstednavne.bebyggelse t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  dkstednavne.bebyggelse t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  dkstednavne.bebyggelse t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- begravelsesplads
CREATE OR REPLACE VIEW stednavne_udstil.vw_begravelsesplads AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  dkstednavne.begravelsesplads t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  dkstednavne.begravelsesplads t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  dkstednavne.begravelsesplads t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  dkstednavne.begravelsesplads t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  dkstednavne.begravelsesplads t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- bygning
CREATE OR REPLACE VIEW stednavne_udstil.vw_bygning AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  dkstednavne.bygning t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  dkstednavne.bygning t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  dkstednavne.bygning t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  dkstednavne.bygning t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  dkstednavne.bygning t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- campingplads
CREATE OR REPLACE VIEW stednavne_udstil.vw_campingplads AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  dkstednavne.campingplads t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  dkstednavne.campingplads t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  dkstednavne.campingplads t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  dkstednavne.campingplads t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  dkstednavne.campingplads t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- farvand
CREATE OR REPLACE VIEW stednavne_udstil.vw_farvand AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  dkstednavne.farvand t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  dkstednavne.farvand t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  dkstednavne.farvand t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  dkstednavne.farvand t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  dkstednavne.farvand t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- fortidsminde
CREATE OR REPLACE VIEW stednavne_udstil.vw_fortidsminde AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  dkstednavne.fortidsminde t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  dkstednavne.fortidsminde t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  dkstednavne.fortidsminde t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  dkstednavne.fortidsminde t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  dkstednavne.fortidsminde t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- friluftsbad
CREATE OR REPLACE VIEW stednavne_udstil.vw_friluftsbad AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  dkstednavne.friluftsbad t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  dkstednavne.friluftsbad t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  dkstednavne.friluftsbad t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  dkstednavne.friluftsbad t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  dkstednavne.friluftsbad t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- havnebassin
CREATE OR REPLACE VIEW stednavne_udstil.vw_havnebassin AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  dkstednavne.havnebassin t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  dkstednavne.havnebassin t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  dkstednavne.havnebassin t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  dkstednavne.havnebassin t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  dkstednavne.havnebassin t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- jernbane
CREATE OR REPLACE VIEW stednavne_udstil.vw_jernbane AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  dkstednavne.jernbane t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  dkstednavne.jernbane t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  dkstednavne.jernbane t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  dkstednavne.jernbane t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  dkstednavne.jernbane t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- landskabsform
CREATE OR REPLACE VIEW stednavne_udstil.vw_landskabsform AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  dkstednavne.landskabsform t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  dkstednavne.landskabsform t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  dkstednavne.landskabsform t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  dkstednavne.landskabsform t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  dkstednavne.landskabsform t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- lufthavn
CREATE OR REPLACE VIEW stednavne_udstil.vw_lufthavn AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  dkstednavne.lufthavn t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  dkstednavne.lufthavn t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  dkstednavne.lufthavn t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  dkstednavne.lufthavn t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  dkstednavne.lufthavn t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- naturareal
CREATE OR REPLACE VIEW stednavne_udstil.vw_naturareal AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  dkstednavne.naturareal t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  dkstednavne.naturareal t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  dkstednavne.naturareal t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  dkstednavne.naturareal t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  dkstednavne.naturareal t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- navigationsanlaeg
CREATE OR REPLACE VIEW stednavne_udstil.vw_navigationsanlaeg AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  dkstednavne.navigationsanlaeg t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  dkstednavne.navigationsanlaeg t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  dkstednavne.navigationsanlaeg t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  dkstednavne.navigationsanlaeg t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  dkstednavne.navigationsanlaeg t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- restriktionsareal
CREATE OR REPLACE VIEW stednavne_udstil.vw_restriktionsareal AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  dkstednavne.restriktionsareal t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  dkstednavne.restriktionsareal t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  dkstednavne.restriktionsareal t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  dkstednavne.restriktionsareal t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  dkstednavne.restriktionsareal t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- sevaerdighed
CREATE OR REPLACE VIEW stednavne_udstil.vw_sevaerdighed AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  dkstednavne.sevaerdighed t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  dkstednavne.sevaerdighed t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  dkstednavne.sevaerdighed t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  dkstednavne.sevaerdighed t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  dkstednavne.sevaerdighed t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- terraenkontur
CREATE OR REPLACE VIEW stednavne_udstil.vw_terraenkontur AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  dkstednavne.terraenkontur t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  dkstednavne.terraenkontur t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  dkstednavne.terraenkontur t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  dkstednavne.terraenkontur t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  dkstednavne.terraenkontur t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- urentfarvand
CREATE OR REPLACE VIEW stednavne_udstil.vw_urentfarvand AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  dkstednavne.urentfarvand t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  dkstednavne.urentfarvand t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  dkstednavne.urentfarvand t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  dkstednavne.urentfarvand t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  dkstednavne.urentfarvand t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- vandloeb
CREATE OR REPLACE VIEW stednavne_udstil.vw_vandloeb AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  dkstednavne.vandloeb t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  dkstednavne.vandloeb t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  dkstednavne.vandloeb t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  dkstednavne.vandloeb t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  dkstednavne.vandloeb t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- andentopografiflade
CREATE OR REPLACE VIEW stednavne_udstil.vw_andentopografiflade AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografiflade t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografiflade t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografiflade t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografiflade t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografiflade t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- andentopografipunkt
CREATE OR REPLACE VIEW stednavne_udstil.vw_andentopografipunkt AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografipunkt t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografipunkt t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografipunkt t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografipunkt t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  dkstednavne.andentopografipunkt t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- idraetsanlaeg
CREATE OR REPLACE VIEW stednavne_udstil.vw_idraetsanlaeg AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  dkstednavne.idraetsanlaeg t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  dkstednavne.idraetsanlaeg t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  dkstednavne.idraetsanlaeg t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  dkstednavne.idraetsanlaeg t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  dkstednavne.idraetsanlaeg t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- soe
CREATE OR REPLACE VIEW stednavne_udstil.vw_soe AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  dkstednavne.soe t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  dkstednavne.soe t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  dkstednavne.soe t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  dkstednavne.soe t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  dkstednavne.soe t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- standsningssted
CREATE OR REPLACE VIEW stednavne_udstil.vw_standsningssted AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  dkstednavne.standsningssted t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  dkstednavne.standsningssted t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  dkstednavne.standsningssted t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  dkstednavne.standsningssted t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  dkstednavne.standsningssted t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- vej
CREATE OR REPLACE VIEW stednavne_udstil.vw_vej AS 
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  dkstednavne.vej t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  dkstednavne.vej t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  dkstednavne.vej t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  dkstednavne.vej t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  dkstednavne.vej t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- SELECT 'SELECT * FROM ' || table_schema || '.' || table_name || ' UNION' FROM information_schema.tables where table_type='VIEW' AND table_schema='util' ORDER BY 1;
--SELECT * FROM stednavne_udstil.vw_bebyggelse limit 10
-- All elements
CREATE OR REPLACE VIEW stednavne_udstil.vw_stednavn AS
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, bebyggelsestype AS subtype, id_lokalid FROM stednavne_udstil.vw_bebyggelse UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, begravelsespladstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_begravelsesplads UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, bygningstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_bygning UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, campingpladstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_campingplads UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, farvandstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_farvand UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, fortidsmindetype AS subtype, id_lokalid  FROM stednavne_udstil.vw_fortidsminde UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, friluftsbadtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_friluftsbad UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, havnebassintype AS subtype, id_lokalid  FROM stednavne_udstil.vw_havnebassin UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, jernbanetype AS subtype, id_lokalid  FROM stednavne_udstil.vw_jernbane UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, landskabsformtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_landskabsform UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, lufthavnstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_lufthavn UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, naturarealtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_naturareal UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, navigationsanlaegstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_navigationsanlaeg UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, restriktionsarealtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_restriktionsareal UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, sevaerdighedstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_sevaerdighed UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, terraenkonturtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_terraenkontur UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, urentfarvandtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_urentfarvand UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, vandloebstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_vandloeb UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, andentopografitype AS subtype, id_lokalid  FROM stednavne_udstil.vw_andentopografiflade UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, andentopografitype AS subtype, id_lokalid  FROM stednavne_udstil.vw_andentopografipunkt UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, idraetsanlaegstype AS subtype, id_lokalid  FROM stednavne_udstil.vw_idraetsanlaeg UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, soetype AS subtype, id_lokalid  FROM stednavne_udstil.vw_soe UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, standsningsstedtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_standsningssted UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, type, vejtype AS subtype, id_lokalid  FROM stednavne_udstil.vw_vej

/* Test
SELECT * FROM stednavne_udstil.vw_bebyggelse LIMIT 100
SELECT * FROM stednavne_udstil.vw_begravelsesplads LIMIT 100
SELECT * FROM stednavne_udstil.vw_bygning LIMIT 100
SELECT * FROM stednavne_udstil.vw_campingplads LIMIT 100
SELECT * FROM stednavne_udstil.vw_faergerutepunkt LIMIT 100
SELECT * FROM stednavne_udstil.vw_farvand LIMIT 100
SELECT * FROM stednavne_udstil.vw_fortidsminde LIMIT 100
SELECT * FROM stednavne_udstil.vw_friluftsbad LIMIT 100
SELECT * FROM stednavne_udstil.vw_havnebassin LIMIT 100
SELECT * FROM stednavne_udstil.vw_jernbane LIMIT 100
SELECT * FROM stednavne_udstil.vw_landskabsform LIMIT 100
SELECT * FROM stednavne_udstil.vw_lufthavn LIMIT 100
SELECT * FROM stednavne_udstil.vw_naturareal LIMIT 100
SELECT * FROM stednavne_udstil.vw_navigationsanlaeg LIMIT 100
SELECT * FROM stednavne_udstil.vw_restriktionsareal LIMIT 100
SELECT * FROM stednavne_udstil.vw_rute LIMIT 100
SELECT * FROM stednavne_udstil.vw_sevaerdighed LIMIT 100
SELECT * FROM stednavne_udstil.vw_terraenkontur LIMIT 100
SELECT * FROM stednavne_udstil.vw_urentfarvand LIMIT 100
SELECT * FROM stednavne_udstil.vw_vandloeb LIMIT 100

SELECT * FROM stednavne_udstil.vw_andentopografiflade order by objectid LIMIT 100
SELECT * FROM stednavne_udstil.vw_andentopografipunkt LIMIT 100
SELECT * FROM stednavne_udstil.vw_faergerutelinje LIMIT 100
SELECT * FROM stednavne_udstil.vw_idraetsanlaeg LIMIT 100
SELECT * FROM stednavne_udstil.vw_soe LIMIT 100
SELECT * FROM stednavne_udstil.vw_standsningssted LIMIT 100
SELECT * FROM stednavne_udstil.vw_vej LIMIT 100

SELECT * FROM stednavne_udstil.vw_stednavn LIMIT 100
*/