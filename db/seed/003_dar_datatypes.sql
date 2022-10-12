DROP TYPE IF EXISTS public.bebyggelseref CASCADE;

CREATE TYPE public.bebyggelseref AS (
    id uuid,
    kode integer,
    type text,
    navn character varying
);

DROP TYPE IF EXISTS public.bebyggelsestype CASCADE;

CREATE TYPE public.bebyggelsestype AS ENUM (
    'by',
    'bydel',
    'spredtBebyggelse',
    'sommerhusområde',
    'sommerhusområdedel',
    'industriområde',
    'kolonihave',
    'storby'
);

DROP TYPE IF EXISTS public.dagitemaref CASCADE;

CREATE TYPE public.dagitemaref AS (
    kode integer,
    navn character varying ( 255));

DROP TYPE IF EXISTS public.dar1_entity CASCADE;

CREATE TYPE public.dar1_entity AS ENUM (
    'Adressepunkt',
    'Adresse',
    'DARAfstemningsområde',
    'DARKommuneinddeling',
    'DARMenighedsrådsafstemningsområde',
    'DARSogneinddeling',
    'Husnummer',
    'NavngivenVej',
    'NavngivenVejKommunedel',
    'NavngivenVejPostnummerRelation',
    'NavngivenVejSupplerendeBynavnRelation',
    'Postnummer',
    'SupplerendeBynavn',
    'ReserveretVejnavn'
);

DROP TYPE IF EXISTS public.dar_tx_source CASCADE;

CREATE TYPE public.dar_tx_source AS ENUM (
    'csv',
    'api'
);

DROP TYPE IF EXISTS public.husnr CASCADE;

CREATE TYPE public.husnr AS (
    tal smallint,
    bogstav character varying ( 1));

DROP TYPE IF EXISTS public.husnr_range CASCADE;

CREATE TYPE public.husnr_range AS RANGE (
    subtype = public.husnr
);

DROP TYPE IF EXISTS public.jordstykkeref CASCADE;

CREATE TYPE public.jordstykkeref AS (
    ejerlavkode integer,
    matrikelnr text,
    ejerlavnavn text
);

DROP TYPE IF EXISTS public.kommuneref CASCADE;

CREATE TYPE public.kommuneref AS (
    kode integer,
    navn character varying
);

DROP TYPE IF EXISTS public.operation_type CASCADE;

CREATE TYPE public.operation_type AS ENUM (
    'insert',
    'update',
    'delete'
);

DROP TYPE IF EXISTS public.postnummerref CASCADE;

CREATE TYPE public.postnummerref AS (
    nr integer,
    navn character varying
);

DROP TYPE IF EXISTS public.tema_type CASCADE;

CREATE TYPE public.tema_type AS ENUM (
    'kommune',
    'region',
    'sogn',
    'opstillingskreds',
    'politikreds',
    'retskreds',
    'afstemningsomraade',
    'postnummer',
    'danmark',
    'menighedsraadsafstemningsomraade',
    'samlepostnummer',
    'storkreds',
    'supplerendebynavn',
    'valglandsdel',
    'zone',
    'jordstykke'
);

DROP TYPE IF EXISTS public.tema_data CASCADE;

CREATE TYPE public.tema_data AS (
    tema public.tema_type,
    fields json
);

DROP TYPE IF EXISTS public.vejstykkeref CASCADE;

CREATE TYPE public.vejstykkeref AS (
    kommunekode integer,
    kode integer
);

