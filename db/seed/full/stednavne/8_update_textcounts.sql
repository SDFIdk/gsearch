-- Create table with text combinations and number of accourences
-- Helper to create data:
DROP TABLE IF EXISTS basic.stednavn_count;
CREATE TABLE basic.stednavn_count (
    tekstelement text,
    forekomster int,
    PRIMARY KEY (tekstelement)
);


-- Inserts into stednavn_count
WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.stednavn_count (tekstelement, forekomster)
SELECT
    substring(lower(skrivemaade) FROM 1 FOR a),
    count(*)
FROM
    basic.stednavn am
        CROSS JOIN a
WHERE skrivemaade IS NOT null
GROUP BY
    substring(lower(skrivemaade) FROM 1 FOR a)
HAVING
    count(1) > 1000
ON CONFLICT DO NOTHING;
