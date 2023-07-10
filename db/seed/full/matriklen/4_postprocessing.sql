ALTER TABLE basic.matrikel
    ALTER COLUMN matrikelnummer TYPE TEXT COLLATE matrikelnummer_collation;

ALTER TABLE basic.matrikel
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.matrikel
    ADD COLUMN textsearchable_plain_col tsvector
        GENERATED ALWAYS AS (textsearchable_plain_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikel
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.matrikel
    ADD COLUMN textsearchable_unaccent_col tsvector
        GENERATED ALWAYS AS (textsearchable_unaccent_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikel
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.matrikel
    ADD COLUMN textsearchable_phonetic_col tsvector
        GENERATED ALWAYS AS (textsearchable_phonetic_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;
