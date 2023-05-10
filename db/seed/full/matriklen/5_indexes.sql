CREATE INDEX ON basic.matrikel USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.matrikel USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.matrikel USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.matrikel (matrikelnummer, visningstekst);

CREATE INDEX ON basic.matrikel (lower(ejerlavsnavn));
