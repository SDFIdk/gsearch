
CREATE INDEX ON basic.sogn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.sogn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.sogn USING GIN (textsearchable_phonetic_col);
