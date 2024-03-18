ALTER TABLE basic_initialloading.stednavn
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic_initialloading.stednavn
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(visningstekst, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(visningstekst, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring ((visningstekst), 3)), 'C'))
    STORED;

ALTER TABLE basic_initialloading.stednavn
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic_initialloading.stednavn
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.gsearch_fts_config', split_part(visningstekst, ' ', 1)), 'A') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(visningstekst, ' ', 2)), 'B') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (visningstekst, 3)), 'C'))
    STORED;

ALTER TABLE basic_initialloading.stednavn
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic_initialloading.stednavn
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', functions.fnfonetik (split_part(visningstekst_nohyphen, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(visningstekst_nohyphen, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (visningstekst_nohyphen, 3)), 'C'))
    STORED;

CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_phonetic_col);

VACUUM ANALYZE basic_initialloading.stednavn;