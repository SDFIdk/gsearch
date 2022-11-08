# GSearch dokumentation

**GSearch** er et REST-api som udstiller en metode til at søge i adresser, matrikelnumre og en række andre geografiske navne. Api'et tilbyder funktionalitet, som kan implementeres i en brugerapplikation i form af et søgefelt med autocomplete/typeahead funktion.

**GSearch** har i princippet samme funktionalitet og virkemåde som SDFI's nuværende søgekomponent, _GeoSearch_, men med en række forbedringer, bl.a. i muligheden af at sætte filtre, der kan fokusere og dermed optimere søgningen.

**GSearch** tekstsøgning håndterer typiske stave- og skrivevarianter og fonetiske ligheder i de navne der søges i, som fx Ågade/Aagade, Gl. Byvej/Gammel Byvej, Vester/Vestre, Ringkøbing/Ringkjøbing, Kathrine/Cathrine o.l.

## Generelt

**GSearch** kan søge i 12 data-ressourcer: Navngiven vej, adresse, husnummer, kommune, matrikelnummer, opstillingskreds, politikreds, politidistrikt, region, retskreds, sogn og stednavn.

Datakilder for ressourcerne er de fire autoritative grunddataregistre: Danmarks Adresseregister (DAR), Danmarks Administrative, Geografiske Inddeling (DAGI), Matriklen (MAT) og Danske Stednavne (DS), som alle udstilles via Datafordeleren.

## Request syntax
**URL** til GSearch er `https://api.dataforsyningen.dk/gsearch/v1.0/search`

**Søgning:** De centrale inputparametre er _'resources'_, som angiver hvilken data-ressource der skal søges i og _'q'_, der er en tekststreng som angiver hvad der skal søges efter.

_Eksempel,_ hvor der søges efter navngivne veje med 'lærke'

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?gresources=navngivenvej&q=Lærke HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Parameteren _'resources'_ _kan_ definere mere end én data-ressource. I så fald skal man være opmærksom på at den supplerende parameter _'filter'_ ikke kan anvendes.

**Supplerende request parametre** kan anvendes til at målrette søgningen hhv. begrænse antallet af svar i response:

_Parametren 'limit'_ begrænser det mulige antal svar i response. Maksimum er 100; default værdi er 10.

_Eksempel,_ hvor der der søges efter navngivne veje med 'vinkel' og en limit på 90

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?gresources=navngivenvej&q=vinkel&limit=90 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

_Parametren 'filters'_ angiver hvilken del af data-ressourcen, der søges i.

Filtre skal defineres i syntaksen _ECQL_, som er en GeoServer extension af Open Geospatial Consortiums

```http
GET https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Et ECQL filterudtryk kan anvende værdier fra en eller flere af de attributter, der optræder i den pågældende data-ressources retursvar, herunder geometrien i attributterne fx _'bbox'_ og _'geometri'_.

**NB** Det er vigtigt at ECQL-udtrykket anvender fuld URL-encoding så `'` fx encodes til `%27`.

**NB** Attributter i retursvaret, der udgør et array, kan ikke benyttes som filter. Det gælder fx attributten _'postnummer'_ i ressourcen _'navngivenvej'_.

_Eksempel_ på simpelt filter på husnummer: kommunekode '0461', dvs. Odense, bemærk brugen af `%27` som erstatning for `'`.

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?gresources=husnummer&q=lærke&filter=kommunekode=%270461%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Brug af geometri som filter vil være relevant når man ønsker at begrænse søgningen inden for en polygon, der fx kan repræsentere et kortudsnit i brugerapplikationen.

Det spatiale referencesystem i et geometrifilter skal angives som _'SRID=25832'_.

Adresser og husnumre har ikke geometri i _'bbox'_ eller _'geometri'_, Geometri findes hér i _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_, som derfor kan anvendes i et geografisk filter.

_Eksempel_ på filter med geometri for stednavne inden for et område i Sønderjylland

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?gresources=stednavn&q=Ben&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

## Response
Resultatet af en forespørgsel indeholder de forekomster, som matcher forespørgslen bedst muligt. Antallet af forekomster begrænses af parmereten _'limit'_ (se ovenfor).Response er formateret som JSON.

**Indhold:** Response indeholder altid det fundne objekts autoritative _'id'_ samt en tekststreng _'praesentation'_ der fungerer som visuel repræsentation af objektet og som eksempelvis kan implementeres i en liste med søgeresultater, efterhånden som brugeren føjer tegn til søgestrengen.

**Objektgeometri:** Objektgeometri er inkluderet i response som GeoJSON i referencesystem EPSG:25832 (ETRS89 UTM Zone 32).

For adresse og husnummer indeholder response geometri i attributterne _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_. Øvrige data-ressourcer har to sæt geometri: _'bbox'_, der er en beregnet bounding box, og _'geometri'_ der er basisregisterets objektgeometri.

For DAGI-objekterne, dvs. kommune, kommune, opstillingskreds, politikreds, postdistrikt, region, retskreds, sogn, anvendes den generaliserede _'D500'_ geometri.

**Attributter i øvrigt:** Det øvrige indhold af objekt-attributter i response afhænger i øvrigt af data-ressourcen, som det fremgår af eksemplerne herunder [ .... ]  eller noget ...

<h2 id="gsearch-eksempler">Eksempler</h2>

### Navngiven vej
Syntaks-eksempel med limit=100 (```http100 resultater):

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=navngivenvej&limit=100&q=krin HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med filter på geometri - et område i Sønderjylland:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=navngivenvej&q=birk&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Adresse
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=adresse&q=flens HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med med limit=30 filter på kommunekode - Lolland Kommune:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=adresse&limit=30&q=fle&filter=kommunekode=%270360%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med limit=100 og filter på geometri - et område i Sønderjylland:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=adresse&limit=100&q=skanse&filter=INTERSECTS(vejpunkt_geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Husnummer
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=husnummer&q=genvej HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med filter på kommunekode - Guldborgsund:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=husnummer&q=gen&filter=kommunekode=%270376%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med limit=100 og filter på geometri - Lolland-Falster:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=husnummer&limit=100&q=fjordbak&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Matrikelnummer
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=matrikelnummer&q=123ab HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med filter på ejerlavskode:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=matrikelnummer&q=123ab&filter=ejerlavskode=%27130653%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med filter på geometri:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=matrikelnummer&q=22&filter=INTERSECTS(geometri,SRID=25832;POLYGON((530000.1 6085450.2, 530000.3 6092950.4, 540000.5 6092950.6, 540000.7 6085450.8, 530000.1 6085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Opstillingskreds
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=opstillingskreds&q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med filter på storkreds:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=opstillingskreds&q=vest&filter=storkredsnummer=%276%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med filter på geometri:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=opstillingskreds&q=s&filter=INTERSECTS(geometri,SRID=25832;POLYGON((530000.1 6085450.2, 530000.3 6092950.4, 540000.5 6092950.6, 540000.7 6085450.8, 530000.1 6085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Politikreds
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=politikreds&q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med filter på geometri - Nørrejylland:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=politikreds&q=ø&filter=INTERSECTS(geometri,SRID=25832;POLYGON((440000.1 6190000.2, 440000.3 6410000.4, 620000.5 6410000.6, 620000.7 6190000.8, 440000.1 6190000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Postdistrikt
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=postdistrikt&limit=60&q=b HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=postdistrikt&q=mari HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks-eksempel med filter på geometri - Lolland-Falster:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=postdistrikt&q=mari&filter=INTERSECTS(geometri,SRID=25832;POLYGON((615000.1 6049000.2, 615000.3 6111000.4, 735000.5 6111000.6, 735000.7 6049000.8, 615000.1 6049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Region
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=region&q=mid HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel - returnerer alle fem regioner:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=region&q=regi HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Retskreds
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=retskreds&q=mid HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=retskreds&q=a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med filter på geometri - Nørrejylland:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=retskreds&q=a&filter=INTERSECTS(geometri,SRID=25832;POLYGON((440000.1 6190000.2, 440000.3 6410000.4, 620000.5 6410000.6, 620000.7 6190000.8, 440000.1 6190000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Sogn
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=sogn&q=bis HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=sogn&q=skal HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel med filter på geometri - Odsherred:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=sogn&q=r&filter=INTERSECTS(geometri,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Stednavn
Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=stednavn&q=kattebj HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=stednavn&limit=40&q=kratg HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel - filter på type af stednavn:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=stednavn&q=katte&filter=stednavn_type=%27bebyggelse%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Syntaks eksempel - filter på type af stednavn:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=stednavn&q=katte&filter=stednavn_subtype=%27moseSump%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

> Syntaks eksempel med filter på geometri - Odsherred:

```http
GET https://api.dataforsyningen.dk/gsearch/v1.0/search?resources=stednavn&q=steng&filter=INTERSECTS(geometri,SRID=25832;POLYGON((625000.1 6165000.2, 625000.3 6215000.4, 677000.5 6215000.6, 677000.7 6165000.8, 625000.1 6165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

