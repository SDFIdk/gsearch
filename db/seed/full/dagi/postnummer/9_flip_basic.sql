BEGIN;
    DROP TABLE IF EXISTS basic.postnummer;

    ALTER TABLE basic_initialloading.postnummer
    SET SCHEMA basic;

END;
