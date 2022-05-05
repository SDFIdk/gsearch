-- Create table with text combinations and number of accourences
DROP TABLE IF EXISTS basic.tekst_forekomst;
CREATE TABLE basic.tekst_forekomst (ressource text, tekstelement TEXT, forekomster int,
PRIMARY KEY (ressource, tekstelement));

WITH a AS (SELECT generate_series(1,3) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
  'adresse',
  substring(lower(vejnavn) FROM 1 FOR a),
  count(*)
FROM
  basic.adresse_mv am
  CROSS JOIN a
GROUP BY
  substring(lower(vejnavn) FROM 1 FOR a)
HAVING
  count(1) > 1000
;

WITH a AS (SELECT generate_series(1,3) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
  'husnummer',
  substring(lower(titel) FROM 1 FOR a),
  count(*)
FROM
  basic.husnummer_mv am
  CROSS JOIN a
GROUP BY
  substring(lower(titel) FROM 1 FOR a)
HAVING
  count(1) > 1000
;

/* TBD
WITH a AS (SELECT generate_series(1,3) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
  'matrikelnummer',
  substring(lower(titel) FROM 1 FOR a),
  count(*)
FROM
  basic.matrikelnummer_mv am
  CROSS JOIN a
GROUP BY
  substring(lower(titel) FROM 1 FOR a)
HAVING
  count(1) > 1000
;
*/
WITH a AS (SELECT generate_series(1,3) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
  'navngivenvej',
  substring(lower(titel) FROM 1 FOR a),
  count(*)
FROM
  basic.navngivenvej_mv am
  CROSS JOIN a
GROUP BY
  substring(lower(titel) FROM 1 FOR a)
HAVING
  count(1) > 1000
;

WITH a AS (SELECT generate_series(1,3) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
  'stednavn',
  substring(lower(presentationstring) FROM 1 FOR a),
  count(*)
FROM
  basic.stednavn_mv am
  CROSS JOIN a
GROUP BY
  substring(lower(presentationstring) FROM 1 FOR a)
HAVING
  count(1) > 1000
;


