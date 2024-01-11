BEGIN;
    DROP TABLE IF EXISTS basic.adresse;

    ALTER TABLE basic_initialloading.adresse
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.adresse_count;

    ALTER TABLE basic_initialloading.adresse_count
    SET SCHEMA basic;

END;
