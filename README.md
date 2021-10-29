# gsearch
Version 2 af GeoSearch.

Gsearch bygger på følgende hovedprincipper:
 - Udvikles i dette repo.
 - Brugere inddrages i så bredt omfang som muligt. Der bliver løbende etableret test / udviklings services til "tidlig" kommentering fra brugere
 - Tilbyder restservices, som givet en søgetekst og eventuelle filtre, returnerer en række objekter underlagt de givne filtre, der "ligner" søgetekst.
 - Sorteringen af objekterne, er defineret ud fra et sæt af givne sorteringsmuligheder (der vil typisk altid være mulighed for alfabetisk sortering efter præsentations-tekst)
 - Et tyndt forretningslag, som udstiller REST services. Skrevet i Java.
 - Forretningslaget skal som udgangspunkt være selvkonfigurerende (ud fra data i databasen)
 - Forretningslaget dokumenteres som swagger
 - Forretningslaget skal testes gennem formaliseret integrationstest (CI / CD)
 - Der udvikles (måske) en "mixer" funktion, som muliggør at man i samme kald kan kalde flere søgeressourcer i et kald og få et "mix" af objekttyper retur.
 - Et databaselag i Postgres (minimum v.12), som udstiller søgefunktioner eller views i et særskilt schema (fx. API)
 - Databasen definerer søgningerne. Der vil således ikke (eller i meget begrænset omfang) være behov for konfigurationsfiler til applikationslaget.
 - Alle udstillede objekter i databassen, dokumenteres med Postgres Comment (som kan aflæses af forretningslæget til udstilling)

## Project structure

This is a Spring Boot 2 project using Maven, Spring Web and JDBI.

Target Java version is 11.

## Configuration

Database connection is configured by suppling environment variables PGHOST, PGPORT, PGDATABASE, PGUSER and PGPASSWORD.

## How to run as standalone

> mvn spring-boot:run

## How to build/run with Docker

Build image with:

> docker build . -t gsearch

Run image exposed at port 8080 with:

> docker run --add-host host.docker.internal:host-gateway --env-file dev.env -p 8080:8080 gsearch

NOTE: dev.env specifies environment variables to local database and --add-hosts makes local postgresql instance available inside the container. This is not needed if connecting to an external database.
