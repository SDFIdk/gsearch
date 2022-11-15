# GSearch dokumentation 

**GSearch** er et REST-api som udstiller en metode til at søge i adresser, matrikelnumre og en række andre geografiske navne. Api'et tilbyder funktionalitet, som kan implementeres i en brugerapplikation i form af et søgefelt med autocomplete/typeahead funktion.

**GSearch** har i princippet samme funktionalitet og virkemåde som SDFI's nuværende søgekomponent, _GeoSearch_, men med en række forbedringer, bl.a. i muligheden af at sætte filtre, der kan fokusere og dermed optimere søgningen.

**GSearch** tekstsøgning håndterer typiske stave- og skrivevarianter og fonetiske ligheder i de navne der søges i, som fx Ågade/Aagade, Gl. Byvej/Gammel Byvej, Vester/Vestre, Ringkøbing/Ringkjøbing, Kathrine/Cathrine o.l. 

## Generelt

**GSearch** kan søge i 12 data-ressourcer: Navngiven vej, adresse, husnummer, kommune, matrikelnummer, opstillingskreds, politikreds, postdistrikt, region, retskreds, sogn og stednavn. 

Datakilder for ressourcerne er de fire autoritative grunddataregistre: Danmarks Adresseregister (DAR), Danmarks Administrative, Geografiske Inddeling (DAGI), Matriklen (MAT) og Danske Stednavne (DS), som alle udstilles via Datafordeleren.

I hver ressource søges der efter bedst muliug match i et eller flere felter/attributter som følger:

* Navngiven vej: Der søges i ...
* Adresse: Der søges i ...
* Husnummer: Der søges i  ...
* Kommune: Der søges i  ...
* Matrikelnummer: Der søges i ...
* Opstillingskreds: Der søges i ...
* Politikreds: Der søges i ...
* Postdistrikt: Der søges i ...
* Region: Der søges i ...
* Retskreds: Der søges i ...
* Sogn: Der søges i ...
* Stednavn: Der søges i ... 

## Request syntax
**URL** til GSearch er:
<https://api.dataforsyningen.dk/gsearch_test/search?>

**Login:** Loginparametre er _'login'_ (brugernavn) og _'password'_ eller, alternativt _'token'_

* _Eksempel_ med login: _https://api.dataforsyningen.dk/gsearch_test/v1.0/search?login=xxxxxx&password=yyyyyy& ..._

* _Eksempel_ med token: _https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484& ..._ 

**Søgning:** De centrale inputparametre er _'resources'_, som angiver hvilken data-ressource der skal søges i og _'q'_, der er en tekststreng som angiver hvad der skal søges efter. 

* _Eksempel,_ hvor der søges efter navngivne veje med 'lærke'. Syntaksen er: **...&resources=navngivenvej&q=Lærke...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=navngivenvej&q=Lærke>)

Parameteren _'resources'_ _kan_ definere mere end én data-ressource. I så fald skal man være opmærksom på at den supplerende parameter _'filter'_ ikke kan anvendes.

**Supplerende request parametre** kan anvendes til at målrette søgningen hhv. begrænse antallet af svar i response: 

_Parametren 'limit'_ begrænser det mulige antal svar i response. Maksimum er 100; default værdi er 10.

* _Eksempel,_ hvor der der søges efter navngivne veje med 'vinkel' og en limit på 90. Syntaksen er: **...&limit=90...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=navngivenvej&q=vinkel&limit=90>)

_Parametren 'filters'_ angiver hvilken del af data-ressourcen, der søges i. 

Filtre skal defineres i syntaksen _ECQL_, som er en GeoServer extension af Open Geospatial Consortiums [Common Querry Language (CQL)](<https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html>).

Et ECQL filterudtryk kan anvende værdier fra en eller flere af de attributter, der optræder i den pågældende data-ressources retursvar, herunder geometrien i attributterne fx _'bbox'_ og _'geometri'_. 

**NB** Det er vigtigt at ECQL-udtrykket anvender fuld URL-encoding så "'" fx encodes til "%27".

**NB** Attributter i retursvaret, der udgør et array, kan ikke benyttes som filter. Det gælder fx attributten _'postnummer'_ i ressourcen _'navngivenvej'_.

* _Eksempel_ på simpelt filter på husnummer: kommunekode '0461', dvs. Odense - Syntaksen er: **...&filter=kommunekode=%270461%27...** (bemærk brugen af _%27_ som erstatning for "'") [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=husnummer&q=lærke&filter=kommunekode=%270461%27>)

Brug af geometri som filter vil være relevant når man ønsker at begrænse søgningen inden for en polygon, der fx kan repræsentere et kortudsnit i brugerapplikationen. 

Den relevante spatiale funktion vil i så fald typisk være _INTERSECTS_ som kan bruges på objektgeometrierne _'bbox'_ eller _'geometri'_. For  adresser og husnumre skal objektgeometrien i _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_ anvendes for at sætte et geometrifilter. 

I et geometrifilter skal det spatiale referencesystem i altid angives som _'SRID=25832'_. 

* _Eksempel på filter med geometri_ for stednavne inden for et område i Sønderjylland. Syntaksen er: **...&resources=stednavn&q=Benl&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&q=Benl&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))>)

## Response 
Resultatet af en forespørgsel indeholder de forekomster, som matcher forespørgslen bedst muligt. Antallet af forekomster begrænses af parmereten _'limit'_ (se ovenfor).Response er formateret som JSON.

**Indhold:** Response indeholder altid det fundne objekts autoritative _'id'_ samt en tekststreng _'praesentation'_ der fungerer som visuel repræsentation af objektet og som eksempelvis kan implementeres i en liste med søgeresultater, efterhånden som brugeren føjer tegn til søgestrengen. 

**Objektgeometri:** Objektgeometri er inkluderet i response som GeoJSON i referencesystem EPSG:25832 (ETRS89 UTM Zone 32).

For adresse og husnummer indeholder response geometri i attributterne _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_. Øvrige data-ressourcer har to sæt geometri: _'bbox'_, der er en beregnet bounding box, og _'geometri'_ der er basisregisterets objektgeometri. 

For DAGI-objekterne, dvs. kommune, kommune, opstillingskreds, politikreds, postdistrikt, region, retskreds, sogn, anvendes den generaliserede _'D500'_ geometri.

**Attributter i øvrigt:** Det øvrige indhold af objekt-attributter i response afhænger i øvrigt af data-ressourcen, som det fremgår af eksemplerne herunder. Output for hver ressource er i øvriugt dokumenteret her [ en URL svarende til https://gsearch.k8s-test-121.septima.dk/swagger-ui/index.html ]  eller noget ...

# Eksempler

## Navngiven vej
* Syntaks eksempel som søger efter 'krin' med limit=100 (>100 resultater): **...&resources=navngivenvej&limit=100&q=krin...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=navngivenvej&limit=100&q=krin>)

* Syntaks eksempel som søger efter 'birk' med filter på geometri - et område i Sønderjylland: **...&q=birk&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1%206074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=navngivenvej&q=birk&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1%206074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))>)

## Adresse
* Syntaks eksempel som søger efter 'flens': **...&q=flens...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=adresse&q=flens>)

* Syntaks eksempel som søger efter 'fle' med med limit=30 og filter på kommunekode 0360, dvs. Lolland Kommune: **...&limit=30&q=fle&filter=kommunekode=%270360%27...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=adresse&limit=30&q=fle&filter=kommunekode=%270360%27>) 

* Syntaks eksempel som søger efter 'skanse' med limit=100 og filter på vejpunkt_geometri - et område i Sønderjylland: **&limit=100&q=skanse&filter=INTERSECTS(vejpunkt_geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=adresse&limit=100&q=skanse&filter=INTERSECTS(vejpunkt_geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2)))>)

## Husnummer
* Syntaks eksempel som søger efter 'genvej': **...&q=genvej...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=husnummer&q=genvej>)

* Syntaks eksempel som søger efter 'gen' med med limit=30 og filter på kommunekode 0376, dvs. Guldborgsund Kommune: **...&limit=30&q=fle&filter=kommunekode=%270360%27...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=husnummer&limit=30&q=fle&filter=kommunekode=%270376%27>) 

* Syntaks eksempel som søger efter 'fjordbak' med limit=100 og filter på adgangspunkt_geometri - Lolland-Falster: **...&limit=100&q=fjordbak&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2)))** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=husnummer&limit=100&q=fjordbak&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2)))>)

## Matrikelnummer
* Syntaks eksempel som søger efter '123ab': **...&q=123ab...** [prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=matrikelnummer&q=123ab>)

* Syntaks eksempel som søger efter '123ab' med filter på ejerlavskode '130653': **...&q=123ab&filter=ejerlavskode=%27130653%27..** 
[prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=matrikelnummer&q=123ab&filter=ejerlavskode=%27130653%27>)

* Syntaks eksempel som søger efter '22' med filter på geometri - Lolland-Falster: **...&q=22&filter=INTERSECTS(geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2)))...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=matrikelnummer&q=22&filter=INTERSECTS(geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2)))>)

## Opstillingskreds
* Syntaks eksempel som søger efter 'vest': **...&q=vest...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=opstillingskreds&q=vest>)

* Syntaks eksempel som søger efter 'vest' med filter på storkreds '6': **&...q=vest&filter=storkredsnummer=%276%27...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=opstillingskreds&q=vest&filter=storkredsnummer=%276%27>)

## Politikreds
* Syntaks eksempel som søger efter 'vest': **...&q=vest...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=politikreds&q=vest>)

* Syntaks eksempel som søger efter 'ø' med filter på geometri - Nørrejylland: **...&q=ø&filter=INTERSECTS(geometri,SRID=25832;POLYGON((440000.1 6190000.2, 440000.3 6410000.4, 620000.5 6410000.6, 620000.7 6190000.8, 440000.1 6190000.2)))...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=politikreds&q=ø&filter=INTERSECTS(geometri,SRID=25832;POLYGON((440000.1 6190000.2, 440000.3 6410000.4, 620000.5 6410000.6, 620000.7 6190000.8, 440000.1 6190000.2)))>)

## Postdistrikt
* Syntaks eksempel som søger efter 'b' og limit '60': **...&limit=60&q=b...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=postdistrikt&limit=60&q=b>)

* Syntaks eksempel som søger efter 'mari': **...&q=mari...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=postdistrikt&q=mari>)

* Syntaks eksempel som søger efter 'mar'og filter på geometri - Lolland-Falster: 
<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=postdistrikt&q=mar&filter=INTERSECTS(geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2)))>

## Region
* Syntaks eksempel som søger efter 'mid': **...&q=mid...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=region&q=mid>)

* Syntaks eksempel som søger efter 'regi' (og returnerer alle fem): **...&q=regi...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=region&q=regi>)

## Retskreds
* Syntaks eksempel som søger efter 'mid': **...&q=mid...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=retskreds&q=mid>)

* Syntaks eksempel som søger efter 'a' (og returnerer alle fem): **...&q=a...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=retskreds&q=a>)

## Sogn 
* Syntaks eksempel som søger efter 'bis: **...&q=bis...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=sogn&q=bis>)

* Syntaks eksempel som søger efter 'skal': **...&q=skal...** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=sogn&q=skal>)

* Syntaks eksempel som søger efter 'r' og med filter på geometri - Odsherred: **...&q=r&filter=INTERSECTS(geometri,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2)))** [Prøv her](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=sogn&q=r&filter=INTERSECTS(geometri,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2)))>)

## Stednavn
* Syntaks eksempel som søger efter 'kattebj': **...&q=kattebj...** [Prøv det](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&q=kattebj>)

* Syntaks eksempel som søger efter 'kratg': **...&q=kratg...** [Prøv det](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&limit=40&q=kratg>)

* Syntaks eksempel som søger efter 'katte' og med filter på type af stednavn 'bebyggelse': **...&q=katte&filter=stednavn_type=%27bebyggelse%27** [Prøv det](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&q=katte&filter=stednavn_type=%27bebyggelse%27>)

* Syntaks eksempel som søger efter 'katte' og med filter på type af stednavn 'moseSump': **...&q=katte&filter=stednavn_type=%27moseSump%27** [Prøv det](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&q=katte&filter=stednavn_subtype=%27moseSump%27>)

* Syntaks eksempel som søger efter 'steng' og med filter på geometri - Odsherred: **...&q=steng&filter=INTERSECTS(bbox,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2)))...** [Prøv det](<https://api.dataforsyningen.dk/gsearch_test/v1.0/search?token=d66d32cef73a42d63397c86181c2b484&resources=stednavn&q=steng&filter=INTERSECTS(bbox,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2)))>)
