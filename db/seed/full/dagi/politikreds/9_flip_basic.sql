BEGIN;
    DROP TABLE IF EXISTS basic.politikreds;

    ALTER TABLE basic_initialloading.politikreds
    SET SCHEMA basic;

END;
