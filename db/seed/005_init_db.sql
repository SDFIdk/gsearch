-- Extensions and schemas:
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

--DROP SCHEMA IF EXISTS dagi_10m_nohist_l1_fdw CASCADE;
--DROP SCHEMA IF EXISTS dagi_500m_nohist_l1_fdw CASCADE;
--DROP SCHEMA IF EXISTS dar_fdw CASCADE;
--DROP SCHEMA IF EXISTS fonetik_fdw CASCADE;
--DROP SCHEMA IF EXISTS mat_kf_fdw CASCADE;
--DROP SCHEMA IF EXISTS stednavne_udstil_fdw CASCADE;
--DROP SCHEMA IF EXISTS dar CASCADE;
--DROP SCHEMA IF EXISTS fonetik CASCADE;
--DROP SCHEMA IF EXISTS mat_kf CASCADE;
--DROP SCHEMA IF EXISTS stednavne_udstil CASCADE;
--DROP SCHEMA IF EXISTS dagi_10m_nohist_l1 CASCADE;
--DROP SCHEMA IF EXISTS dagi_500m_nohist_l1 CASCADE;
DROP SCHEMA IF EXISTS basic CASCADE;
DROP SCHEMA IF EXISTS api CASCADE;
DROP SCHEMA IF EXISTS scratch CASCADE;

--CREATE SCHEMA dagi_10m_nohist_l1_fdw;
--CREATE SCHEMA dagi_500m_nohist_l1_fdw;
--CREATE SCHEMA fonetik_fdw;
--CREATE SCHEMA dar_fdw;
--CREATE SCHEMA mat_kf_fdw;
--CREATE SCHEMA stednavne_udstil_fdw;
--CREATE SCHEMA dagi_10m_nohist_l1;
--CREATE SCHEMA dagi_500m_nohist_l1;
--CREATE SCHEMA fonetik;
--CREATE SCHEMA dar;
--CREATE SCHEMA mat_kf;
--CREATE SCHEMA stednavne_udstil;
CREATE SCHEMA api;
CREATE SCHEMA basic;
CREATE SCHEMA scratch;

--COMMENT ON SCHEMA dagi_10m_nohist_l1_fdw IS 'Foreign data wrappers to dagi 10m tables';
--COMMENT ON SCHEMA dagi_500m_nohist_l1_fdw IS 'Foreign data wrappers to dagi 500m tables';
--COMMENT ON SCHEMA dar_fdw IS 'Foreign data wrappers to dar';
--COMMENT ON SCHEMA fonetik_fdw IS 'Foreign data wrappers to fonetik';
--COMMENT ON SCHEMA mat_kf_fdw IS 'Foreign data wrappers to mat_kf';
--COMMENT ON SCHEMA stednavne_udstil_fdw IS 'Foreign data wrappers to stednavne_udstil';
--COMMENT ON SCHEMA dar IS 'DAR base data';
--COMMENT ON SCHEMA mat_kf IS 'MAT base data';
--COMMENT ON SCHEMA stednavne_udstil IS 'Stednavne base data';
COMMENT ON SCHEMA scratch IS 'Tables describing duplicate pk, orphan FK etc.';
--COMMENT ON SCHEMA fonetik IS 'Phonetic rules and functions';
COMMENT ON SCHEMA api IS 'Public Schema for Gsearch';
COMMENT ON SCHEMA basic IS 'Searchable tables';

--DROP ROLE IF EXISTS udv_gsearch_read;
--CREATE USER udv_gsearch_read WITH PASSWORD :udv_gsearch_read_pass;
