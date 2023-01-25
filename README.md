# gsearch
Version 2 af GeoSearch.

Gsearch bygger på følgende hovedprincipper:
 - Udvikles i dette repo.
 - Brugere inddrages i så bredt omfang som muligt. Der bliver løbende etableret test / udviklings services til "tidlig" kommentering fra brugere
 - Tilbyder restservices, som givet en søgetekst og eventuelle filtre, returnerer en række objekter underlagt de givne filtre, der "ligner" søgetekst.
 - Sorteringen af objekterne, er defineret ud fra et sæt af givne sorteringsmuligheder (der vil typisk altid være mulighed for alfabetisk sortering efter visningstekst)
 - Et tyndt forretningslag, som udstiller REST services. Skrevet i Java.
 - Forretningslaget skal som udgangspunkt være selvkonfigurerende (ud fra data i databasen)
 - Forretningslaget dokumenteres som swagger
 - Forretningslaget skal testes gennem formaliseret integrationstest (CI / CD)
 - Et databaselag i Postgres (minimum v.12), som udstiller søgefunktioner eller views i et særskilt schema (fx. API)
 - Databasen definerer søgningerne. Der vil således ikke (eller i meget begrænset omfang) være behov for konfigurationsfiler til applikationslaget.
 - Alle udstillede objekter i databassen, dokumenteres med Postgres Comment (som kan aflæses af forretningslæget til udstilling)

## Project structure

This is a Spring Boot project using Maven, Spring Web and JDBI.

Target Java version is 17.

## Configuration

Database connection is configured by suppling environment variables PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD and PGMAXPOOLSIZE.

## How to run as standalone

> PGHOST=localhost PGPORT=5432 PGDATABASE=gsearch PGUSER=postgres PGPASSWORD=postgres PGMAXPOOLSIZE=4 mvn spring-boot:run

## How to build/run with Docker

Build image with:

> docker build . -t gsearch

Run image exposed at port 8080 with:

> docker run --add-host host.docker.internal:host-gateway --env-file dev.env -p 8080:8080 gsearch

NOTE: dev.env specifies environment variables to local database and --add-hosts makes local postgresql instance available inside the container. This is not needed if connecting to an external database.

## Moving from Geosearch to Gsearch

**GSearch** har i princippet samme funktionalitet og virkemåde som SDFI's nuværende søgekomponent, _GeoSearch_, men med en række forbedringer, bl.a. i muligheden af at sætte filtre, der kan fokusere og dermed optimere søgningen.

| Geosearch | Gsearch |
| - | - |
| - | husnummer |
| - | navngivenvej |
| adresser | adresse |
| kommuner | kommune |
| matrikelnumre | matrikel |
| matrikelnumre_incl_udgaaet | - |
| matrikelnumre_udgaaet | - |
| opstillingskredse | opstillingskreds |
| politikredse | politikreds |
| postdistriker | postnummer |
| regioner | region |
| retskredse | retskreds |
| sogne | sogn |
| stednavn_v2 | - |
| stednavn_v3 | stednavn |
