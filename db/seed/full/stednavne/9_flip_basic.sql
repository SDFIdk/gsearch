BEGIN;
    DROP TABLE IF EXISTS basic.stednavn;

    ALTER TABLE basic_initialloading.stednavn
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.stednavn_count;

    ALTER TABLE basic_initialloading.stednavn_count
    SET SCHEMA basic;

END;
