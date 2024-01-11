BEGIN;
    DROP TABLE IF EXISTS basic.opstillingskreds;

    ALTER TABLE basic_initialloading.opstillingskreds
    SET SCHEMA basic;

END;
