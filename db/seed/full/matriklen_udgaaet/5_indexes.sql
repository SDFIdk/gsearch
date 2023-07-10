CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.matrikel_udgaaet USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.matrikel_udgaaet (matrikelnummer, visningstekst);

CREATE INDEX ON basic.matrikel (jordstykke_id);

CREATE INDEX ON basic.matrikel_udgaaet (bfenummer);

CREATE INDEX ON basic.matrikel_udgaaet (lower(ejerlavsnavn));

CREATE INDEX ON basic.matrikel_udgaaet USING gist (geometri);

VACUUM ANALYZE basic.matrikel_udgaaet;