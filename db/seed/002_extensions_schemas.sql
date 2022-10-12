-- Extensions and schemas:
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP SCHEMA IF EXISTS dagi_10_fdw CASCADE;

DROP SCHEMA IF EXISTS dagi_500_fdw CASCADE;

DROP SCHEMA IF EXISTS dar_fdw CASCADE;

DROP SCHEMA IF EXISTS matriklen_fdw CASCADE;

DROP SCHEMA IF EXISTS stednavne_fdw CASCADE;

DROP SCHEMA IF EXISTS dar CASCADE;

DROP SCHEMA IF EXISTS matriklen CASCADE;

DROP SCHEMA IF EXISTS stednavne CASCADE;

DROP SCHEMA IF EXISTS stednavne_udstilling CASCADE;

DROP SCHEMA IF EXISTS dagi_10 CASCADE;

DROP SCHEMA IF EXISTS dagi_500 CASCADE;

DROP SCHEMA IF EXISTS basic CASCADE;

DROP SCHEMA IF EXISTS api CASCADE;

DROP SCHEMA IF EXISTS scratch CASCADE;

CREATE SCHEMA dagi_10_fdw;

CREATE SCHEMA dagi_500_fdw;

CREATE SCHEMA dar_fdw;

CREATE SCHEMA matriklen_fdw;

CREATE SCHEMA stednavne_fdw;

CREATE SCHEMA dagi_10;

CREATE SCHEMA dagi_500;

CREATE SCHEMA dar;

CREATE SCHEMA matriklen;

CREATE SCHEMA stednavne;

CREATE SCHEMA stednavne_udstilling;

CREATE SCHEMA api;

CREATE SCHEMA basic;

CREATE SCHEMA scratch;

COMMENT ON SCHEMA dagi_10_fdw IS 'Foreign data wrappers to dagi 10 tables';

COMMENT ON SCHEMA dagi_500_fdw IS 'Foreign data wrappers to dagi 500 tables';

COMMENT ON SCHEMA dar_fdw IS 'Foreign data wrappers to dar';

COMMENT ON SCHEMA matriklen_fdw IS 'Foreign data wrappers to matriklen';

COMMENT ON SCHEMA stednavne_fdw IS 'Foreign data wrappers to stednavne';

COMMENT ON SCHEMA dar IS 'DAR base data';

COMMENT ON SCHEMA matriklen IS 'MAT base data';

COMMENT ON SCHEMA stednavne IS 'Stednavne base data';

COMMENT ON SCHEMA scratch IS 'Tables describing duplicate pk, orphan FK etc.';

COMMENT ON SCHEMA api IS 'Public Schema for Gsearch';

COMMENT ON SCHEMA basic IS 'Searchable tables';

