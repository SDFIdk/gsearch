ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_plain_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_plain_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring (vejnavn, 4)), 'D'))
    STORED;

-- unaccented textsearchable column: å -> aa, é -> e, ect.
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_unaccent_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_unaccent_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (vejnavn, 4)), 'D'))

    STORED;

-- phonetic textsearchable column: christian -> kristian, k
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_phonetic_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_phonetic_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (vejnavn, 4)), 'D'))

    STORED;

ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring (vejnavn, 4)), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))
    STORED;

-- unaccented textsearchable column: å -> aa, é -> e, ect.
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (vejnavn, 4)), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))

    STORED;

-- phonetic textsearchable column: christian -> kristian, k
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(vejnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (vejnavn, 4)), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))

    STORED;

