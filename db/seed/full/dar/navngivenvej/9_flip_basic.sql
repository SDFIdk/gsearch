BEGIN;
    DROP TABLE IF EXISTS basic.navngivenvej;

    ALTER TABLE basic_initialloading.navngivenvej
    SET SCHEMA basic;

    DROP TABLE IF EXISTS basic.navngivenvej_count;

    ALTER TABLE basic_initialloading.navngivenvej_count
    SET SCHEMA basic;

END;
