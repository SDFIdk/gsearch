-- bebyggelse
/*
CREATE OR REPLACE VIEW stednavne_udstilling.vw_bebyggelse AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  stednavne_20220504.bebyggelse t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  stednavne_20220504.bebyggelse t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  stednavne_20220504.bebyggelse t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  stednavne_20220504.bebyggelse t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'bebyggelse'::character varying AS type, t.bebyggelsestype, id_lokalid
FROM
  stednavne_20220504.bebyggelse t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- begravelsesplads
CREATE OR REPLACE VIEW stednavne_udstilling.vw_begravelsesplads AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  stednavne_20220504.begravelsesplads t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  stednavne_20220504.begravelsesplads t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  stednavne_20220504.begravelsesplads t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  stednavne_20220504.begravelsesplads t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'begravelsesplads'::character varying AS type, t.begravelsespladstype, id_lokalid
FROM
  stednavne_20220504.begravelsesplads t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- bygning
CREATE OR REPLACE VIEW stednavne_udstilling.vw_bygning AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  stednavne_20220504.bygning t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  stednavne_20220504.bygning t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  stednavne_20220504.bygning t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  stednavne_20220504.bygning t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'bygning'::character varying AS type, t.bygningstype, id_lokalid
FROM
  stednavne_20220504.bygning t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- campingplads
CREATE OR REPLACE VIEW stednavne_udstilling.vw_campingplads AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  stednavne_20220504.campingplads t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  stednavne_20220504.campingplads t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  stednavne_20220504.campingplads t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  stednavne_20220504.campingplads t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'campingplads'::character varying AS type,  t.campingpladstype, id_lokalid
FROM
  stednavne_20220504.campingplads t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- farvand
CREATE OR REPLACE VIEW stednavne_udstilling.vw_farvand AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  stednavne_20220504.farvand t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  stednavne_20220504.farvand t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  stednavne_20220504.farvand t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  stednavne_20220504.farvand t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'farvand'::character varying AS type,  t.farvandstype, id_lokalid
FROM
  stednavne_20220504.farvand t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- fortidsminde
CREATE OR REPLACE VIEW stednavne_udstilling.vw_fortidsminde AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  stednavne_20220504.fortidsminde t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  stednavne_20220504.fortidsminde t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  stednavne_20220504.fortidsminde t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  stednavne_20220504.fortidsminde t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'fortidsminde'::character varying AS type,  t.fortidsmindetype, id_lokalid
FROM
  stednavne_20220504.fortidsminde t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- friluftsbad
CREATE OR REPLACE VIEW stednavne_udstilling.vw_friluftsbad AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  stednavne_20220504.friluftsbad t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  stednavne_20220504.friluftsbad t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  stednavne_20220504.friluftsbad t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  stednavne_20220504.friluftsbad t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'friluftsbad'::character varying AS type,  t.friluftsbadtype, id_lokalid
FROM
  stednavne_20220504.friluftsbad t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- havnebassin
CREATE OR REPLACE VIEW stednavne_udstilling.vw_havnebassin AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  stednavne_20220504.havnebassin t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  stednavne_20220504.havnebassin t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  stednavne_20220504.havnebassin t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  stednavne_20220504.havnebassin t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'havnebassin'::character varying AS type,  t.havnebassintype, id_lokalid
FROM
  stednavne_20220504.havnebassin t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- jernbane
CREATE OR REPLACE VIEW stednavne_udstilling.vw_jernbane AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  stednavne_20220504.jernbane t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  stednavne_20220504.jernbane t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  stednavne_20220504.jernbane t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  stednavne_20220504.jernbane t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'jernbane'::character varying AS type,  t.jernbanetype, id_lokalid
FROM
  stednavne_20220504.jernbane t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- landskabsform
CREATE OR REPLACE VIEW stednavne_udstilling.vw_landskabsform AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  stednavne_20220504.landskabsform t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  stednavne_20220504.landskabsform t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  stednavne_20220504.landskabsform t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  stednavne_20220504.landskabsform t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'landskabsform'::character varying AS type,  t.landskabsformtype, id_lokalid
FROM
  stednavne_20220504.landskabsform t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- lufthavn
CREATE OR REPLACE VIEW stednavne_udstilling.vw_lufthavn AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  stednavne_20220504.lufthavn t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  stednavne_20220504.lufthavn t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  stednavne_20220504.lufthavn t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  stednavne_20220504.lufthavn t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'lufthavn'::character varying AS type,  t.lufthavnstype, id_lokalid
FROM
  stednavne_20220504.lufthavn t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- naturareal
CREATE OR REPLACE VIEW stednavne_udstilling.vw_naturareal AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  stednavne_20220504.naturareal t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  stednavne_20220504.naturareal t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  stednavne_20220504.naturareal t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  stednavne_20220504.naturareal t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'naturareal'::character varying AS type,  t.naturarealtype, id_lokalid
FROM
  stednavne_20220504.naturareal t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- navigationsanlaeg
CREATE OR REPLACE VIEW stednavne_udstilling.vw_navigationsanlaeg AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  stednavne_20220504.navigationsanlaeg t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  stednavne_20220504.navigationsanlaeg t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  stednavne_20220504.navigationsanlaeg t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  stednavne_20220504.navigationsanlaeg t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'navigationsanlaeg'::character varying AS type,  t.navigationsanlaegstype, id_lokalid
FROM
  stednavne_20220504.navigationsanlaeg t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- restriktionsareal
CREATE OR REPLACE VIEW stednavne_udstilling.vw_restriktionsareal AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  stednavne_20220504.restriktionsareal t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  stednavne_20220504.restriktionsareal t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  stednavne_20220504.restriktionsareal t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  stednavne_20220504.restriktionsareal t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'restriktionsareal'::character varying AS type,  t.restriktionsarealtype, id_lokalid
FROM
  stednavne_20220504.restriktionsareal t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- sevaerdighed
CREATE OR REPLACE VIEW stednavne_udstilling.vw_sevaerdighed AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  stednavne_20220504.sevaerdighed t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  stednavne_20220504.sevaerdighed t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  stednavne_20220504.sevaerdighed t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  stednavne_20220504.sevaerdighed t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'sevaerdighed'::character varying AS type,  t.sevaerdighedstype, id_lokalid
FROM
  stednavne_20220504.sevaerdighed t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- terraenkontur
CREATE OR REPLACE VIEW stednavne_udstilling.vw_terraenkontur AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  stednavne_20220504.terraenkontur t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  stednavne_20220504.terraenkontur t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  stednavne_20220504.terraenkontur t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  stednavne_20220504.terraenkontur t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'terraenkontur'::character varying AS type,  t.terraenkonturtype, id_lokalid
FROM
  stednavne_20220504.terraenkontur t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- urentfarvand
CREATE OR REPLACE VIEW stednavne_udstilling.vw_urentfarvand AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  stednavne_20220504.urentfarvand t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  stednavne_20220504.urentfarvand t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  stednavne_20220504.urentfarvand t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  stednavne_20220504.urentfarvand t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'urentfarvand'::character varying AS type,  t.urentfarvandtype, id_lokalid
FROM
  stednavne_20220504.urentfarvand t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- vandloeb
CREATE OR REPLACE VIEW stednavne_udstilling.vw_vandloeb AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  stednavne_20220504.vandloeb t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  stednavne_20220504.vandloeb t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  stednavne_20220504.vandloeb t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  stednavne_20220504.vandloeb t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'vandloeb'::character varying AS type,  t.vandloebstype, id_lokalid
FROM
  stednavne_20220504.vandloeb t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- andentopografiflade
CREATE OR REPLACE VIEW stednavne_udstilling.vw_andentopografiflade AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografiflade t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografiflade t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografiflade t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografiflade t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'andentopografiflade'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografiflade t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- andentopografipunkt
CREATE OR REPLACE VIEW stednavne_udstilling.vw_andentopografipunkt AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografipunkt t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografipunkt t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografipunkt t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografipunkt t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'andentopografipunkt'::character varying AS type,  t.andentopografitype, id_lokalid
FROM
  stednavne_20220504.andentopografipunkt t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- idraetsanlaeg
CREATE OR REPLACE VIEW stednavne_udstilling.vw_idraetsanlaeg AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  stednavne_20220504.idraetsanlaeg t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  stednavne_20220504.idraetsanlaeg t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  stednavne_20220504.idraetsanlaeg t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  stednavne_20220504.idraetsanlaeg t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'idraetsanlaeg'::character varying AS type,  t.idraetsanlaegstype, id_lokalid
FROM
  stednavne_20220504.idraetsanlaeg t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- soe
CREATE OR REPLACE VIEW stednavne_udstilling.vw_soe AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  stednavne_20220504.soe t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  stednavne_20220504.soe t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  stednavne_20220504.soe t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  stednavne_20220504.soe t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'soe'::character varying AS type,  t.soetype, id_lokalid
FROM
  stednavne_20220504.soe t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- standsningssted
CREATE OR REPLACE VIEW stednavne_udstilling.vw_standsningssted AS
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  stednavne_20220504.standsningssted t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  stednavne_20220504.standsningssted t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  stednavne_20220504.standsningssted t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  stednavne_20220504.standsningssted t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'standsningssted'::character varying AS type,  t.standsningsstedtype, id_lokalid
FROM
  stednavne_20220504.standsningssted t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- vej
CREATE OR REPLACE VIEW stednavne_udstilling.vw_vej AS 
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_1_navnefoelgenummer navnefoelgenummer, t.navn_1_navnestatus navnestatus, t.navn_1_skrivemaade skrivemaade, t.navn_1_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  stednavne_20220504.vej t where t.navn_1_skrivemaade IS NOT NULL AND t.navn_1_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_2_navnefoelgenummer navnefoelgenummer, t.navn_2_navnestatus navnestatus, t.navn_2_skrivemaade skrivemaade, t.navn_2_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  stednavne_20220504.vej t where t.navn_2_skrivemaade IS NOT NULL AND t.navn_2_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_3_navnefoelgenummer navnefoelgenummer, t.navn_3_navnestatus navnestatus, t.navn_3_skrivemaade skrivemaade, t.navn_3_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  stednavne_20220504.vej t where t.navn_3_skrivemaade IS NOT NULL AND t.navn_3_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_4_navnefoelgenummer navnefoelgenummer, t.navn_4_navnestatus navnestatus, t.navn_4_skrivemaade skrivemaade, t.navn_4_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  stednavne_20220504.vej t where t.navn_4_skrivemaade IS NOT NULL AND t.navn_4_aktualitet = 'iAnvendelse'
UNION
SELECT
  t.objectid::integer, st_force2d(t.geometri) geometri, t.navn_5_navnefoelgenummer navnefoelgenummer, t.navn_5_navnestatus navnestatus, t.navn_5_skrivemaade skrivemaade, t.navn_5_sprog sprog,
  'vej'::character varying AS type,  t.vejtype, t.id_lokalid
FROM
  stednavne_20220504.vej t where t.navn_5_skrivemaade IS NOT NULL AND t.navn_5_aktualitet = 'iAnvendelse';

-- SELECT 'SELECT * FROM ' || table_schema || '.' || table_name || ' UNION' FROM information_schema.tables where table_type='VIEW' AND table_schema='util' ORDER BY 1;
--SELECT * FROM stednavne_udstilling.vw_bebyggelse limit 10


*/



-- All elements
CREATE OR REPLACE VIEW stednavne_udstilling.stednavne_union AS
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'bebyggelse' as type, bebyggelsestype AS subtype, id_lokalid FROM stednavne.bebyggelse UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'begravelsesplads' as type, begravelsespladstype AS subtype, id_lokalid  FROM stednavne.begravelsesplads UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'bygning' as type, bygningstype AS subtype, id_lokalid  FROM stednavne.bygning UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'campingplads' as type, campingpladstype AS subtype, id_lokalid  FROM stednavne.campingplads UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'farvand' as type, farvandstype AS subtype, id_lokalid  FROM stednavne.farvand UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'fortidsminde' as type, fortidsmindetype AS subtype, id_lokalid  FROM stednavne.fortidsminde UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'friluftsbad' as type, friluftsbadtype AS subtype, id_lokalid  FROM stednavne.friluftsbad UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'havnebassin' as type, havnebassintype AS subtype, id_lokalid  FROM stednavne.havnebassin UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'jernbane' as type, jernbanetype AS subtype, id_lokalid  FROM stednavne.jernbane UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'landskabsform' as type, landskabsformtype AS subtype, id_lokalid  FROM stednavne.landskabsform UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'lufthavn' as type, lufthavnstype AS subtype, id_lokalid  FROM stednavne.lufthavn UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'naturareal' as type, naturarealtype AS subtype, id_lokalid  FROM stednavne.naturareal UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'navigationsanlaeg' as type, navigationsanlaegstype AS subtype, id_lokalid  FROM stednavne.navigationsanlaeg UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'restriktionsareal' as type, restriktionsarealtype AS subtype, id_lokalid  FROM stednavne.restriktionsareal UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'sevaerdighed' as type, sevaerdighedstype AS subtype, id_lokalid  FROM stednavne.sevaerdighed UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'terraenkontur' as type, terraenkonturtype AS subtype, id_lokalid  FROM stednavne.terraenkontur UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'urentfarvand' as type, urentfarvandtype AS subtype, id_lokalid  FROM stednavne.urentfarvand UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'vandloeb' as type, vandloebstype AS subtype, id_lokalid  FROM stednavne.vandloeb UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'andentopografiflade' as type, andentopografitype AS subtype, id_lokalid  FROM stednavne.andentopografiflade UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'andentopografipunkt' as type, andentopografitype AS subtype, id_lokalid  FROM stednavne.andentopografipunkt UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'idraetsanlaeg' as type, idraetsanlaegstype AS subtype, id_lokalid  FROM stednavne.idraetsanlaeg UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'soe' as type, soetype AS subtype, id_lokalid  FROM stednavne.soe UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'standsningssted' as type, standsningsstedtype AS subtype, id_lokalid  FROM stednavne.standsningssted UNION
SELECT objectid::integer, geometri, navnefoelgenummer::int, navnestatus, skrivemaade, sprog, 'vej' as type, vejtype AS subtype, id_lokalid  FROM stednavne.vej;

/* Test
SELECT * FROM stednavne_udstilling.bebyggelse LIMIT 100
SELECT * FROM stednavne_udstilling.begravelsesplads LIMIT 100
SELECT * FROM stednavne_udstilling.bygning LIMIT 100
SELECT * FROM stednavne_udstilling.campingplads LIMIT 100
SELECT * FROM stednavne_udstilling.faergerutepunkt LIMIT 100
SELECT * FROM stednavne_udstilling.farvand LIMIT 100
SELECT * FROM stednavne_udstilling.fortidsminde LIMIT 100
SELECT * FROM stednavne_udstilling.friluftsbad LIMIT 100
SELECT * FROM stednavne_udstilling.havnebassin LIMIT 100
SELECT * FROM stednavne_udstilling.jernbane LIMIT 100
SELECT * FROM stednavne_udstilling.landskabsform LIMIT 100
SELECT * FROM stednavne_udstilling.lufthavn LIMIT 100
SELECT * FROM stednavne_udstilling.naturareal LIMIT 100
SELECT * FROM stednavne_udstilling.navigationsanlaeg LIMIT 100
SELECT * FROM stednavne_udstilling.restriktionsareal LIMIT 100
SELECT * FROM stednavne_udstilling.rute LIMIT 100
SELECT * FROM stednavne_udstilling.sevaerdighed LIMIT 100
SELECT * FROM stednavne_udstilling.terraenkontur LIMIT 100
SELECT * FROM stednavne_udstilling.urentfarvand LIMIT 100
SELECT * FROM stednavne_udstilling.vandloeb LIMIT 100

SELECT * FROM stednavne_udstilling.andentopografiflade order by objectid LIMIT 100
SELECT * FROM stednavne_udstilling.andentopografipunkt LIMIT 100
SELECT * FROM stednavne_udstilling.faergerutelinje LIMIT 100
SELECT * FROM stednavne_udstilling.idraetsanlaeg LIMIT 100
SELECT * FROM stednavne_udstilling.soe LIMIT 100
SELECT * FROM stednavne_udstilling.standsningssted LIMIT 100
SELECT * FROM stednavne_udstilling.vej LIMIT 100

SELECT * FROM stednavne_udstilling.stednavn_udstilling LIMIT 100
*/
