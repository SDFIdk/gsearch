ALTER TABLE basic_initialloading.kommune
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic_initialloading.kommune
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', kommunekode), 'A') ||
                         setweight(to_tsvector('simple', split_part(kommunenavn, ' ', 1)), 'B') ||
                         setweight(to_tsvector('simple', split_part(kommunenavn, ' ', 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring (kommunenavn, 3)), 'D'))
    STORED;

ALTER TABLE basic_initialloading.kommune
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic_initialloading.kommune
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.septima_fts_config', kommunekode), 'A') ||
                         setweight(to_tsvector('functions.septima_fts_config', split_part(kommunenavn, ' ', 1)), 'B') ||
                         setweight(to_tsvector('functions.septima_fts_config', split_part(kommunenavn, ' ', 2)), 'C') ||
                         setweight(to_tsvector('functions.septima_fts_config', functions.split_and_endsubstring (kommunenavn, 3)), 'D'))
    STORED;

ALTER TABLE basic_initialloading.kommune
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic_initialloading.kommune
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', kommunekode), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(kommunenavn, ' ', 1), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(kommunenavn, ' ', 2), 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (kommunenavn, 3)), 'D'))
    STORED;

