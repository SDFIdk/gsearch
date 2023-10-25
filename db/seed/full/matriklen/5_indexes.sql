CREATE INDEX ON basic.matrikel USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.matrikel USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.matrikel USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.matrikel (matrikelnummer, visningstekst);

CREATE INDEX ON basic.matrikel (jordstykke_id);

CREATE INDEX ON basic.matrikel (bfenummer);

CREATE INDEX ON basic.matrikel (lower(ejerlavsnavn));

CREATE INDEX ON basic.matrikel (kommunekode);

CREATE INDEX ON basic.matrikel USING gist (geometri);

VACUUM ANALYZE basic.matrikel;
