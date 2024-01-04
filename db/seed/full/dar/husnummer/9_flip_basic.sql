BEGIN;
    DROP TABLE IF EXISTS basic.husnummer;

    ALTER TABLE basic_initialloading.husnummer
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.husnummer_count;

    ALTER TABLE basic_initialloading.husnummer_count
    SET SCHEMA basic;

END;
