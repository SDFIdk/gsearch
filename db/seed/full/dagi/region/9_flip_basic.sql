BEGIN;
    DROP TABLE IF EXISTS basic.region;

    ALTER TABLE basic_initialloading.region
    SET SCHEMA basic;

END;
