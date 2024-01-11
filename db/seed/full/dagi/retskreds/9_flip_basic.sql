BEGIN;
    DROP TABLE IF EXISTS basic.retskreds;

    ALTER TABLE basic_initialloading.retskreds
    SET SCHEMA basic;

END;
