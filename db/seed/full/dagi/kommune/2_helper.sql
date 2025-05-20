DROP TABLE IF EXISTS dagi_10.kommune_helper_stednavne;

SELECT
    (
        CASE
            WHEN
                k.kommunekode = '0101'
                THEN
                k.navn || 's Kommune'
            WHEN
                k.kommunekode = '0411'
                THEN
                k.navn
            ELSE
                k.navn || ' Kommune'
            END
        ) AS visningstekst,
    k.navn AS navn,
    st_multi (st_union (k.geometri)) AS geometri
INTO dagi_10.kommune_helper_stednavne
FROM
    dagi_10.kommuneinddeling k
GROUP BY
    k.navn;

CREATE INDEX ON dagi_10.kommune_helper_stednavne (visningstekst);

CREATE INDEX ON dagi_10.kommune_helper_stednavne (navn);

CREATE INDEX ON dagi_10.kommune_helper_stednavne USING gist (geometri);


VACUUM ANALYZE dagi_10.kommune_helper_stednavne;