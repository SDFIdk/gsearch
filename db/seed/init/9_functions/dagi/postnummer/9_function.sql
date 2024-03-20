DROP FUNCTION IF EXISTS api.postnummer (text, jsonb, int, int, int);

CREATE OR REPLACE FUNCTION api.postnummer (input_tekst text, filters text, sortoptions integer, rowlimit integer, srid integer)
    RETURNS SETOF api.postnummer
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_postnummernavn text;
    input_postnummer text;
    postnummer_string text;
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
        -- Removes repeated whitespace and following symbols -()!
        btrim(regexp_replace(btrim(input_tekst), '[-()! \s]+', ' ', 'g'))
    INTO input_postnummernavn;

    --RAISE NOTICE 'input_postnummernavn: %', input_postnummernavn;

    SELECT
        -- Removes everything that starts with a letter or symbol (not digits) and then removes repeated whitespace.
        btrim(regexp_replace(regexp_replace(btrim(input_tekst), '((?<!\S)\D\S*)', '', 'g'), '\s+', ' '))
    INTO input_postnummer;

    --RAISE NOTICE 'input_postnummer: %', input_postnummer;

    -- If input_postnumer is an empty string it needs to be change to NULL so the where clause in the function
    -- behaves as expected, and not make a search as postnummer like `%` that matches every postnummer.
    SELECT
        CASE
            WHEN input_postnummer = ''
                THEN NULL
            ELSE input_postnummer
        END
    INTO postnummer_string;

    --RAISE NOTICE 'postnummer_string: %', postnummer_string;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postnummernavn, ' ')) t
    )
    SELECT
            string_agg(functions.fnfonetik (t, 2), ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO query_string;

    WITH tokens AS (
        SELECT
            -- Splitter op i temp-tabel hver hvert input ord i hver sin raekke.
            -- removes all combination of spaces and ampersand and replaces it with a whitespace
            UNNEST(string_to_array(regexp_replace(btrim(input_tekst),'[ ][&][ ]|[&][ ]|[ ][&]','','g'), ' ')) t
    )
    SELECT
            string_agg(t, ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO plain_query_string;
    --RAISE NOTICE 'query_string: %', query_string; RAISE NOTICE 'plain_query_string: %', plain_query_string;

    -- Execute and return the result
    stmt = format(E'SELECT
                postnummer::text,
                postnummernavn::text,
                visningstekst,
                ergadepostnummer,
                kommunekode::text,
                CASE WHEN $5 = 25832 THEN geometri
                ELSE ST_TRANSFORM(geometri, $5) END,
                CASE WHEN $5 = 25832 THEN bbox::geometry
                ELSE BOX2D(ST_TRANSFORM(bbox, ''EPSG:25832'', $5))::geometry END
            FROM
                basic.postnummer
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2)
				OR (postnummer IS NULL OR postnummer LIKE $3 || ''%%''))
            AND %s
            ORDER BY
                functions.combine_rank(
                    $2,
                    $2,
                    textsearchable_plain_col,
                    textsearchable_unaccent_col,
                    ''simple''::regconfig,
                    ''functions.gsearch_fts_config''::regconfig
                ) desc,
                    ts_rank_cd(
                    textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision desc,
                postnummernavn
            LIMIT $4 ;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, postnummer_string, rowlimit, srid;
END
$function$;
