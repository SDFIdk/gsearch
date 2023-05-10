CREATE INDEX ON basic.stednavn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.stednavn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.stednavn USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.stednavn (lower(visningstekst));
