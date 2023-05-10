DROP FUNCTION IF EXISTS api.kommune (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.kommune(input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.kommune
    LANGUAGE plpgsql
    STABLE
AS $function$
DECLARE
    max_rows integer;
    input_kommunenavn text;
    input_kommunekode text;
    kommunekode_string text;
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
    -- Build the query_string
    IF btrim(input_tekst) = ANY ('{.,-, '', \,}') THEN
        input_tekst = '';
    END IF;

    SELECT
        -- Removes repeated whitespace and '-'
        regexp_replace(btrim(input_tekst), '[- \s]+', ' ', 'g')
    INTO input_kommunenavn;

    --RAISE NOTICE 'input_kommunenavn: %', input_kommunenavn;

    SELECT
        -- Removes everything that starts with a letter or symbol (not digits) and then removes repeated whitespace.
        btrim(regexp_replace(regexp_replace(btrim(input_tekst), '((?<!\S)\D\S*)', '', 'g'), '\s+', ' '))
    INTO input_kommunekode;

    --RAISE NOTICE 'input_kommunekode: %', input_kommunekode;

    -- If input_kommunekode is an empty string it needs to be change to NULL so the where clause in the function
    -- behaves as expected, and not make a search as kommunekode like `%` that matches every kommunekode.
    SELECT
        CASE
            WHEN input_kommunekode = ''
                THEN NULL
            ELSE input_kommunekode
        END
    INTO kommunekode_string;

    --RAISE NOTICE 'kommunekode_string: %', kommunekode_string;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_kommunenavn, ' ')) t
    )
    SELECT
            string_agg(fonetik.fnfonetik (t, 2), ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO query_string;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_kommunenavn, ' ')) t
    )
    SELECT
            string_agg(t, ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO plain_query_string;

    -- Execute and return the result
    stmt = format(E'SELECT
                kommunekode::text,
				kommunenavn::text,
				visningstekst,
				geometri,
				bbox::geometry
            FROM
                basic.kommune
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
				OR (kommunekode IS NULL OR kommunekode LIKE ''%%'' || $3 || ''%%'')
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
            	kommunenavn
            LIMIT $4;', filters); RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, kommunekode_string, rowlimit;
END
$function$;


-- Test cases:
/*
 SELECT (api.kommune('køb',NULL, 1, 100)).*;
 SELECT (api.kommune('ålborg',NULL, 1, 100)).*;
 SELECT (api.kommune('nord',NULL, 1, 100)).*;
 SELECT (api.kommune('0101 fred',NULL, 1, 100)).*;
 SELECT(api.kommune('a 1 a',NULL,1,100)).*;
 SELECT(api.kommune('Lyngby-Tårbæk 0851',NULL,1,100)).*;
 SELECT(api.kommune('0851 Lyngby',NULL,1,100)).*;
 SELECT(api.kommune('0760 0730 0840 0329 0265 0230 0175',NULL,1,100)).*;
 */

