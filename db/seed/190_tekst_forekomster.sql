SELECT '190_tekst_forekomst.sql' || now();


-- Create table with text combinations and number of accourences
-- Helper to create data:
DROP TABLE IF EXISTS basic.tekst_forekomst;
CREATE TABLE basic.tekst_forekomst (
        ressource text,
        tekstelement text,
        forekomster int,
        PRIMARY KEY (ressource, tekstelement)
        );

