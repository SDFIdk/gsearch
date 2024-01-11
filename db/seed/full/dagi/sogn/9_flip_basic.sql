BEGIN;
    DROP TABLE IF EXISTS basic.sogn;

    ALTER TABLE basic_initialloading.sogn
    SET SCHEMA basic;

END;
