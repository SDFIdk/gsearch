DROP FUNCTION IF EXISTS api.region (text, jsonb, int, int, int);

CREATE OR REPLACE FUNCTION api.region (input_tekst text, filters text, sortoptions integer, rowlimit integer, srid integer)
    RETURNS SETOF api.region
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
        -- Removes repeated whitespace and following symbols -()!
        regexp_replace(btrim(input_tekst), '[-()! \s]+', ' ', 'g')
    INTO input_tekst;

    -- Build the query_string
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
            )
    SELECT
        string_agg(functions.fnfonetik (t, 2), ':* <-> ') || ':*'
    FROM
        tokens INTO query_string;
    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            -- Splitter op i temp-tabel hver hvert input ord i hver sin raekke.
            -- removes all combination of spaces and ampersand and replaces it with a whitespace
            UNNEST(string_to_array(regexp_replace(btrim(input_tekst),'[ ][&][ ]|[&][ ]|[ ][&]','','g'), ' ')) t
            )
    SELECT
        string_agg(t, ':* <-> ') || ':*'
    FROM
        tokens INTO plain_query_string;
    -- Execute and return the result
    stmt = format(E'SELECT
            regionskode::text,
            regionsnavn::text,
            visningstekst::text,
            kommunekode::text,
            CASE WHEN $4 = 25832 THEN geometri
            ELSE ST_TRANSFORM(geometri, $4) END,
            CASE WHEN $4 = 25832 THEN bbox::geometry
            ELSE BOX2D(ST_TRANSFORM(bbox, ''EPSG:25832'', $4))::geometry END
        FROM
            basic.region
        WHERE (
            textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
            OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
            OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
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
                ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision desc,
                regionsnavn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit, srid;
END
$function$;
