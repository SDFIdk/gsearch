SELECT '051_static_tekst_with_numbers.sql ' || now();

-- Create table with text combinations with numbers in it
-- Helper to create data:
DROP TABLE IF EXISTS basic.tekst_med_tal;
CREATE TABLE basic.tekst_med_tal
(
    ressource    text,
    tekstelement text,
    PRIMARY KEY (ressource, tekstelement)
);

INSERT
INTO basic.tekst_med_tal (ressource, tekstelement)
SELECT DISTINCT 'adresse',
       vejnavn
FROM basic.adresse am
WHERE vejnavn ~ '\d';

INSERT
INTO basic.tekst_med_tal (ressource, tekstelement)
SELECT DISTINCT 'husnummer',
                vejnavn
FROM basic.adresse am
WHERE vejnavn ~ '\d';

INSERT
INTO basic.tekst_med_tal (ressource, tekstelement)
SELECT DISTINCT 'matrikel',
                vejnavn
FROM basic.adresse am
WHERE vejnavn ~ '\d';

INSERT
INTO basic.tekst_med_tal (ressource, tekstelement)
SELECT DISTINCT 'navngivenvej',
                vejnavn
FROM basic.adresse am
WHERE vejnavn ~ '\d';

INSERT
INTO basic.tekst_med_tal (ressource, tekstelement)
SELECT DISTINCT 'stednavn',
                vejnavn
FROM basic.adresse am
WHERE vejnavn ~ '\d';
