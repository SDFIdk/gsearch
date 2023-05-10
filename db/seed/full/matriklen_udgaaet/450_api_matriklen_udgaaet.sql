SELECT '450_api_matrikel_udgaaet.sql ' || now();


DROP TYPE IF EXISTS api.matrikel_udgaaet CASCADE;

CREATE TYPE api.matrikel_udgaaet AS (
    ejerlavsnavn text,
    ejerlavskode text,
    kommunenavn text,
    kommunekode text,
    matrikelnummer text,
    visningstekst text,
    bfenummer text,
    centroid_x text,
    centroid_y text,
    geometri geometry
);

COMMENT ON TYPE api.matrikel_udgaaet IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavsnavn IS 'Ejerlavsnavn for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.ejerlavskode IS 'Ejerlavskode for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunenavn IS 'Kommunenavn for matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil matrikel';

COMMENT ON COLUMN api.matrikel_udgaaet.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikel_udgaaet.visningstekst IS 'Præsentationsform for et matrikelnummer';

COMMENT ON COLUMN api.matrikel_udgaaet.visningstekst IS 'BFE-nummer for matriklen';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_x IS 'Centroide X for matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.centroid_y IS 'Centroide Y for matriklens geometri';

COMMENT ON COLUMN api.matrikel_udgaaet.geometri IS 'Geometri i EPSG:25832';

CREATE COLLATION IF NOT EXISTS matrikelnummer_udgaaet_collation (provider = icu, locale = 'en@colNumeric=yes');

DROP TABLE IF EXISTS basic.matrikel_udgaaet;

WITH ejerlav_kommune_distinct as (
	SELECT distinct
		j.ejerlavlokalid,
		k.kommunenavn,
		k.kommunekode,
		k.id_lokalid as kommuneidlokalid
	from
		matriklen_udgaaet.jordstykke j
		join matriklen_udgaaet.matrikelkommune k on k.id_lokalid = j.kommunelokalid
),
ejerlavnavn_kommune_distinct as (
	SELECT 
		e.ejerlavsnavn,
		e.ejerlavskode::text,
		ek.kommunenavn,
		ek.kommunekode,
		ek.kommuneidlokalid
	from
		ejerlav_kommune_distinct ek
		join matriklen_udgaaet.ejerlav e on e.id_lokalid = ek.ejerlavlokalid
),
kommune_distinct as (
	SELECT distinct
		k.kommunenavn,
		k.kommunekode,
		k.id_lokalid
	from 
		matriklen_udgaaet.matrikelkommune k
),
ejerlav_distinct as (
	SELECT distinct
		ejerlavsnavn,
		ejerlavskode::text,
		id_lokalid
	from matriklen_udgaaet.ejerlav 
),
samletfastejendom_distinct as (
	SELECT distinct
		bfenummer::text,
		id_lokalid
	from matriklen_udgaaet.samletfastejendom
),
lodflade_distinct as (
	SELECT distinct
		jordstykkelokalid,
		geometri
	from matriklen_udgaaet.lodflade
),
jordstykke_distinct as (
	SELECT distinct
		id_lokalid,
		matrikelnummer,
		ejerlavlokalid,
		kommunelokalid,
		samletfastejendomlokalid
	from matriklen_udgaaet.jordstykke
),
matrikelnumre AS (
    SELECT
        e.ejerlavsnavn,
        e.ejerlavskode::text,
        k.kommunenavn,
        k.kommunekode,
        j.matrikelnummer,
        s.bfenummer::text,
        c.geometri AS centroide_geometri,
        st_force2d (COALESCE(l.geometri)) AS geometri
    FROM
        matriklen_udgaaet.jordstykke j
        JOIN ejerlav_distinct e ON e.id_lokalid = j.ejerlavlokalid
        JOIN matriklen_udgaaet.centroide c ON c.jordstykkelokalid = j.id_lokalid
        join kommune_distinct k ON k.id_lokalid = j.kommunelokalid
        JOIN lodflade_distinct l ON l.jordstykkelokalid = j.id_lokalid
        JOIN samletfastejendom_distinct s on s.id_lokalid = j.samletfastejendomlokalid
),
ejerlavsnavn_dups AS (
    SELECT
        count(1) ejerlavsnavn_count,
        ejerlavsnavn,
        (setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_plain_col_ejerlavsnavn,
        (setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_unaccent_col_ejerlavsnavn,
        (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 1), 2)), 'B') ||
        setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 2), 2)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (ejerlavsnavn, 3)), 'D')) AS textsearchable_phonetic_col_ejerlavsnavn
    FROM ( SELECT *
        FROM
            ejerlavnavn_kommune_distinct) x
    GROUP BY
        ejerlavsnavn
)
SELECT DISTINCT
    m.matrikelnummer || ', ' || CASE WHEN ejerlavsnavn_count > 1
        THEN
            m.ejerlavsnavn || ' (' || m.kommunenavn || ')'
        ELSE
            m.ejerlavsnavn
    END AS visningstekst,
    m.ejerlavsnavn,
    m.ejerlavskode,
    m.kommunenavn,
    m.kommunekode,
    m.matrikelnummer,
    m.bfenummer,
    m.centroide_geometri,
    e.textsearchable_plain_col_ejerlavsnavn,
    e.textsearchable_unaccent_col_ejerlavsnavn,
    e.textsearchable_phonetic_col_ejerlavsnavn,
    st_multi (m.geometri) AS geometri INTO basic.matrikel_udgaaet
FROM
    matrikelnumre m
    JOIN ejerlavsnavn_dups e ON e.ejerlavsnavn = m.ejerlavsnavn;


-- Inserts into tekst_forekomst
WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
    'matrikel_udgaaet',
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

-- Inserts into tekst_forekomst
WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
SELECT
    'matrikel_udgaaet',
    substring(lower(ejerlavsnavn) FROM 1 FOR a),
    count(*)
FROM
    basic.matrikel_udgaaet am
        CROSS JOIN a
WHERE ejerlavsnavn IS NOT NULL
GROUP BY
    substring(lower(ejerlavsnavn) FROM 1 FOR a)
HAVING
        count(1) > 1000
    ON CONFLICT DO NOTHING;


ALTER TABLE basic.matrikel_udgaaet
    ALTER COLUMN matrikelnummer TYPE TEXT COLLATE matrikelnummer_udgaaet_collation;


ALTER TABLE basic.matrikel_udgaaet
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.matrikel_udgaaet
    ADD COLUMN textsearchable_plain_col tsvector
        GENERATED ALWAYS AS (textsearchable_plain_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikel_udgaaet
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.matrikel_udgaaet
    ADD COLUMN textsearchable_unaccent_col tsvector
        GENERATED ALWAYS AS (textsearchable_unaccent_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikel_udgaaet
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.matrikel_udgaaet
    ADD COLUMN textsearchable_phonetic_col tsvector
        GENERATED ALWAYS AS (textsearchable_phonetic_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;


CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.matrikel_udgaaet (matrikelnummer, visningstekst);

CREATE INDEX ON basic.matrikel_udgaaet (lower(ejerlavsnavn));

DROP FUNCTION IF EXISTS api.matrikel_udgaaet(text, text, int, int);

CREATE OR REPLACE FUNCTION api.matrikel_udgaaet(input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.matrikel_udgaaet
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    query_string text;
    plain_query_string text;
    stmt text;
BEGIN
    -- Initialize
    max_rows = 1000;
    IF rowlimit > max_rows THEN
        RAISE 'rowlimit skal være <= %', max_rows;
    END IF;
    IF filters IS NULL THEN
        filters = '1=1';
    END IF;
    IF btrim(input_tekst) = ANY ('{.,-, '', \,}') THEN
        input_tekst = '';
    END IF;

    SELECT
        -- removes repeated whitespace and '-'
        regexp_replace(input_tekst, '[- \s]+', ' ', 'g')
    INTO input_tekst;

    -- Build the query_string (converting vejnavn of input to phonetic)
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
    )
    SELECT
            string_agg(fonetik.fnfonetik (t, 2), ':* & ') || ':*'
    FROM
        tokens
    INTO query_string;

    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            -- Splitter op i temp-tabel hver hvert vejnavn-ord i hver sin raekke.
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
    )
    SELECT
            string_agg(t, ':* & ') || ':*'
    FROM
        tokens
    INTO plain_query_string;

-- Hvis en soegning ender med at have over ca. 1000 resultater, kan soegningen tage lang tid.
-- Dette er dog ofte soegninger, som ikke noedvendigvis giver mening. (fx. husnummer = 's'
-- eller adresse = 'od').
-- Saa for at goere api'et hurtigere ved disse soegninger, er der to forskellige queries
-- i denne funktion. Den ene bliver brugt, hvis der er over 1000 forekomster.
-- Vi har hardcoded antal forekomster i tabellen: `tekst_forekomst`.
-- Dette gaelder for:
-- - husnummer
-- - adresse
-- - matrikel
-- - navngivenvej
-- - stednavn

-- Et par linjer nede herfra, tilfoejes der et `|| ''å''`. Det er et hack,
-- for at representere den alfanumerisk sidste vej, der starter med `%s`

    IF (
        SELECT
            COALESCE(forekomster, 0)
        FROM
            basic.tekst_forekomst
        WHERE
            ressource = 'matrikel_udgaaet'
        AND lower(input_tekst) = tekstelement ) > 1000
        AND filters = '1=1'
    THEN
        stmt = format(E'SELECT
                ejerlavsnavn::text,
                ejerlavskode::text,
                kommunenavn::text,
                kommunekode::text,
                matrikelnummer::text,
                visningstekst::text,
                bfenummer::text,
                ST_X((ST_DUMP(centroide_geometri)).geom)::text,
                ST_Y((ST_DUMP(centroide_geometri)).geom)::text,
                geometri
            FROM
                basic.matrikel_udgaaet
            WHERE
                ejerlavsnavn ilike ''%s%%''
                OR matrikelnummer ilike ''%s''
            ORDER BY
                matrikelnummer
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE 'stmt=%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    ELSE
        -- Execute and return the result
        stmt = format(E'SELECT
                ejerlavsnavn::text,
                ejerlavskode::text,
                kommunenavn::text,
                kommunekode::text,
                matrikelnummer::text,
                visningstekst::text,
                bfenummer::text,
                ST_X((ST_DUMP(centroide_geometri)).geom)::text,
                ST_Y((ST_DUMP(centroide_geometri)).geom)::text,
                geometri
            FROM
                basic.matrikel_udgaaet
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2)
            )
            AND %s
            ORDER BY
                basic.combine_rank(
                    $2,
                    $2,
                    textsearchable_plain_col,
                    textsearchable_unaccent_col,
                    ''simple''::regconfig,
                    ''basic.septima_fts_config''::regconfig
                ) desc,
                ts_rank_cd(
                    textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision desc,
                matrikelnummer,
                visningstekst
            LIMIT $3  ;', filters);
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    END IF;
END
$function$;
-- Test cases:
/*
 SELECT (api.matrikel_udgaaet('søby',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('1320452',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa 1320452',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('1320452 11aa kobbe',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa søby',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('s',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('a 1 a', NULL, 1, 100)).*;

 */
