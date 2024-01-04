BEGIN;
    DROP TABLE IF EXISTS basic.matrikel;

    ALTER TABLE basic_initialloading.matrikel
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.matrikel_count;

    ALTER TABLE basic_initialloading.matrikel_count
    SET SCHEMA basic;

END;
