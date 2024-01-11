CREATE INDEX ON basic_initialloading.matrikel USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.matrikel USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.matrikel USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.matrikel (matrikelnummer, visningstekst);

CREATE INDEX ON basic_initialloading.matrikel (jordstykke_id);

CREATE INDEX ON basic_initialloading.matrikel (bfenummer);

CREATE INDEX ON basic_initialloading.matrikel (lower(ejerlavsnavn));

CREATE INDEX ON basic_initialloading.matrikel (kommunekode);

CREATE INDEX ON basic_initialloading.matrikel USING gist (geometri);

VACUUM ANALYZE basic_initialloading.matrikel;
