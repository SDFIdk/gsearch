BEGIN;
    DROP TABLE IF EXISTS basic.kommune;

    ALTER TABLE basic_initialloading.kommune
    SET SCHEMA basic;

END;
