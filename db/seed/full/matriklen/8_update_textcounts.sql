-- Create table with text combinations and number of accourences
-- Helper to create data:
DROP TABLE IF EXISTS basic.matrikel_count;
CREATE TABLE basic.matrikel_count (
    tekstelement text,
    forekomster int,
    PRIMARY KEY (tekstelement)
);


-- Inserts into matrikel_count
WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.matrikel_count (tekstelement, forekomster)
SELECT
    substring(lower(matrikelnummer) FROM 1 FOR a),
    count(*)
FROM
    basic.matrikel am
    CROSS JOIN a
WHERE ejerlavsnavn IS NOT NULL
GROUP BY
    substring(lower(matrikelnummer) FROM 1 FOR a)
HAVING
    count(1) > 1000
ON CONFLICT DO NOTHING;


-- Inserts into matrikel_count
WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.matrikel_count (tekstelement, forekomster)
SELECT
    substring(lower(ejerlavsnavn) FROM 1 FOR a),
    count(*)
FROM
    basic.matrikel am
    CROSS JOIN a
WHERE ejerlavsnavn IS NOT NULL
GROUP BY
    substring(lower(ejerlavsnavn) FROM 1 FOR a)
HAVING
    count(1) > 1000
ON CONFLICT DO NOTHING;
