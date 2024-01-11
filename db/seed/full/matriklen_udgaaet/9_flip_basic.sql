BEGIN;
    DROP TABLE IF EXISTS basic.matrikel_udgaaet;

    ALTER TABLE basic_initialloading.matrikel_udgaaet
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.matrikel_udgaaet_count;

    ALTER TABLE basic_initialloading.matrikel_udgaaet_count
    SET SCHEMA basic;

END;
