-- SCRATCH-schema, which - i think - consists of data that is faulty somehow ?
DROP TABLE IF EXISTS scratch.dar_husnummer_dar_adgangspunkt_fk;

WITH invalid_relation AS (
    UPDATE
        dar.husnummer h
    SET
        adgangspunkt_id = NULL
    WHERE
        adgangspunkt_id IS NOT NULL
        AND NOT EXISTS (
            SELECT
                1
            FROM
                dar.adressepunkt a
            WHERE
                h.adgangspunkt_id = a.id)
        RETURNING
            *
)
SELECT
    * INTO scratch.dar_husnummer_dar_adgangspunkt_fk
FROM
    invalid_relation;

ALTER TABLE dar.husnummer
    ADD CONSTRAINT husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

DROP TABLE IF EXISTS scratch.dar_husnummer_dar_vejpunkt_fk;

WITH invalid_relation AS (
    UPDATE
        dar.husnummer h
    SET
        vejpunkt_id = NULL
    WHERE
        vejpunkt_id IS NOT NULL
        AND NOT EXISTS (
            SELECT
                1
            FROM
                dar.adressepunkt a
            WHERE
                h.vejpunkt_id::uuid = a.id)
        RETURNING
            *
)
SELECT
    * INTO scratch.dar_husnummer_dar_vejpunkt_fk
FROM
    invalid_relation;

ALTER TABLE dar.husnummer
    ADD CONSTRAINT husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

ALTER TABLE dar.husnummer
    ADD CONSTRAINT adresse_husnummer_adgangspunkt_fk FOREIGN KEY (adgangspunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;

ALTER TABLE dar.husnummer
    ADD CONSTRAINT adresse_husnummer_vejpunkt_fk FOREIGN KEY (vejpunkt_id) REFERENCES dar.adressepunkt (id) MATCH FULL;



-- Collation
CREATE COLLATION IF NOT EXISTS husnummer_collation (provider = icu, locale = 'en@colNumeric=yes');
