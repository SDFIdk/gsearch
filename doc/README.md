# GSearch dokumentation 

**GSearch** er et REST-api som udstiller en metode til at søge i adresser, matrikelnumre og en række andre geografiske navne. Api'et tilbyder funktionalitet, som kan implementeres i en brugerapplikation i form af et søgefelt med autocomplete/typeahead funktion.

**GSearch** har i princippet samme funktionalitet og virkemåde som SDFI's nuværende søgekomponent, _GeoSearch_, men med en række forbedringer, bl.a. i muligheden af at sætte filtre, der kan fokusere og dermed optimere søgningen.

**GSearch** tekstsøgning håndterer typiske stave- og skrivevarianter og fonetiske ligheder i de navne der søges i, som fx Ågade/Aagade, Gl. Byvej/Gammel Byvej, Vester/Vestre, Ringkøbing/Ringkjøbing, Kathrine/Cathrine o.l. 

## Generelt

**GSearch** kan søge i 12 data-ressourcer: Navngiven vej, adresse, husnummer, kommune, matrikelnummer, opstillingskreds, politikreds, politidistrikt, region, retskreds, sogn og stednavn. 

Datakilder for ressourcerne er de fire autoritative grunddataregistre: Danmarks Adresseregister (DAR), Danmarks Administrative, Geografiske Inddeling (DAGI), Matriklen (MAT) og Danske Stednavne (DS), som alle udstilles via Datafordeleren.

## Request syntax
**URL** til GSearch er:
<https://gsearch.k8s-test-121.septima.dk/search>

**Login:** Loginparametre er _'login'_ (brugernavn) og _'password'_ eller, alternativt _'token'_

_Eksempler:_
<https://gsearch.k8s-test-121.septima.dk/search?login=xxxxxx&password=yyyyyy> ... 
<https://gsearch.k8s-test-121.septima.dk/search?token=d66d32cef73a42d63397c86181c2b484> ... 

**Søgning:** De centrale inputparametre er _'resources'_, som angiver hvilken data-ressource der skal søges i, og _'q'_ der er en tekststreng som angiver, hvad der skal søges efter. 

_Eksempel:_
<https://gsearch.k8s-test-121.septima.dk/search?resources=navngivenvej&q=Lærke>

Parameteren _'resources'_ _kan_ definere mere end én data-ressource. I så fald skal man være opmærksom på at den supplerende parameter _'filter'_ ikke kan anvendes.

**Supplerende request parametre** kan anvendes til at målrette søgningen hhv. begrænse antallet af svar i response: 

_Parametren 'limit'_ begrænser det mulige antal svar i response. Maksimum er 100; default værdi er 10.

_Eksempel:_
<https://gsearch.k8s-test-121.septima.dk/search?resources=navngivenvej&q=vinkel&limit=90>

_Parametren 'filters'_ angiver hvilken del af data-ressourcen, der søges i. Filtre skal defineres i syntaksen _ECQL_, som er en GeoServer extension af Open Geospatial Consortiums _Common Querry Language (CQL)_ [Link: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html].

Et ECQL filterudtryk kan anvende værdier fra en eller flere af de attributter, der optræder i den pågældende data-ressources retursvar, herunder geometrien i attributterne _'bbox'_ og _'geometri'_.

Muligheden af at bruge geometri som filter kan typisk anvendes til at begrænse søgningen inden for en polygon, der eksempelvis kan repræsentere et bestemt kortudsnit i brugerapplikationen. 

**NB!** Det er vigtigt at ECQL-udtrykket anvender fuld URL-encoding så "'" encodes til "%27", mellemrum til %20 osv. ... [Skal formuleres]

_Eksempel på simpelt filter på husnummer (kommunekode='0461' dvs. Odense):_
<https://gsearch.k8s-test-121.septima.dk/search?resources=husnummer&q=lærke&filter=kommunekode=%270461%27>

_Eksempel på filter med geometri (polygon i Sønderjylland):_ 
<https://gsearch.k8s-test-121.septima.dk/search?resources=stednavn&q=Ben&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2)))>

## Response 
Resultatet af en forespørgsel indeholder de forekomster, som matcher forespørgslen bedst muligt. Antallet af forekomster begrænses af parmereten _'limit'_ (se ovenfor).Response er formateret som JSON.

**Indhold:** Response indeholder altid det fundne objekts autoritative _'id'_ samt en tekststreng _'praesentation'_ der fungerer som visuel repræsentation af objektet og som eksempelvis kan implementeres i en liste med søgeresultater, efterhånden som brugeren føjer tegn til søgestrengen. 

**Objektgeometri:** Objektgeometri er inkluderet i response som GeoJSON i referencesystem EPSG:25832 (ETRS89 UTM Zone 32).

For adresse og husnummer indeholder response geometri for adgangspunkt og vejpunkt. Øvrige data-ressourcer har to sæt geometri: _'bbox'_ der er en beregnet bounding box, og _'geometri'_ der er basisregisterets objektgeometri. 

For DAGI-objekterne, dvs. kommune, kommune, opstillingskreds, politikreds, postdistrikt, region, retskreds, sogn, anvendes den generaliserede _'D500'_ geometri.

**Attributter i øvrigt:** Det øvrige indhold af objekt-attributter i response afhænger i øvrigt af data-ressourcen, som det fremgår af eksemplerne herunder [ .... ]  eller noget ...

## Eksempler for data-ressourcer

### Navngiven vej

Syntaks-eksempel:
<https://gsearch.k8s-test-121.septima.dk/search?resources=navngivenvej&q=birk>

Syntaks-eksempel med filter på postnummer:
<https://gsearch.k8s-test-121.septima.dk/search?resources=navngivenvej&q=birk&filter=postnummer=%273460%27>

Syntaks-eksempel med filter på geometri:
<https://gsearch.k8s-test-121.septima.dk/search?resources=navngivenvej&q=birk&filter=INTERSECTS(geometri,SRID=25832;POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2)))>

### Adresse

Syntaks eksempel:
<https://gsearch.k8s-test-121.septima.dk/search?resources=adresse&q=flens>

Syntaks eksempel med filter på kommunekode:
<https://gsearch.k8s-test-121.septima.dk/search?resources=adresse&q=flensb&>filter=kommunekode=%270360%27 

Syntaks-eksempel med filter på geometri:
<https://gsearch.k8s-test-121.septima.dk/search?resources=adresse&q=flens&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832;POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2)))>

### Husnummer
Syntaks eksempel:
<https://gsearch.k8s-test-121.septima.dk/search?resources=husnummer&q=genvej>

Syntaks eksempel med filter på kommunekode:
<https://gsearch.k8s-test-121.septima.dk/search?resources=husnummer&q=gen&filter=kommunekode=%270376%27>

Syntaks-eksempel med filter på geometri:
<https://gsearch.k8s-test-121.septima.dk/search?resources=husnummer&q=byg&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832;POLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2)))>

### Matrikelnummer
Syntaks eksempel:
<https://gsearch.k8s-test-121.septima.dk/search?resources=matrikelnummer&q=123ab>

Syntaks eksempel med filter på ejerlavskode:
<https://gsearch.k8s-test-121.septima.dk/search?resources=matrikelnummer&q=123ab&filter=ejerlavskode=%27130653%27>

Syntaks-eksempel med filter på geometri: <https://gsearch.k8s-test-121.septima.dk/search?resources=matrikelnummer&q=22&filter=INTERSECTS(geometri,SRID=25832;POLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2)))>

... osv. ... 
### Opstillingskreds

### Politikreds 

### Postdistrikt

### Region

### Retskreds

### Sogn 

### Stednavn