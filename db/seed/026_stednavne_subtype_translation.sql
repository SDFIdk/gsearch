-- Translates subtype to more proper form:
DROP TABLE IF EXISTS stednavne_udstilling.subtype_translation;
CREATE TABLE stednavne_udstilling.subtype_translation (subtype TEXT, subtype_presentation TEXT);
DELETE FROM stednavne_udstilling.subtype_translation ;
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('køretekniskAnlæg','Køreteknisk anlæg'),
   ('landsdel','Landsdel'),
   ('stenbrud','Stenbrud'),
   ('vindmøllepark','Vindmøllepark'),
   ('bro','Bro'),
   ('brønd','Brønd'),
   ('gravsted','Gravsted'),
   ('grænsestenGrænsepæl','Grænse'),
   ('kilde','Kilde'),
   ('ledLåge','Låge');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('løvtræ','Løvtræ'),
   ('mindesten','Mindesten'),
   ('motorvejskryds','Motorvejskryds'),
   ('nåletræ','Nåletræ'),
   ('rastepladsMedService','Rasteplads'),
   ('rastepladsUdenService','Rasteplads'),
   ('sluse','Sluse'),
   ('sten','Sten'),
   ('strandpost','Strandpost'),
   ('udsigtspunkt','Udsigtspunkt');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('udsigtstårn','Udsigtstårn'),
   ('ukendt',''),
   ('vandfald','Vandfald'),
   ('varde','Varde'),
   ('vejkryds','Vejkryds'),
   ('by','By'),
   ('bydel','Bydel'),
   ('industriområde','Industriområde'),
   ('kolonihave','Kolonihave'),
   ('sommerhusområde','Sommerhusområde');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('sommerhusområdedel','Sommerhusområde'),
   ('spredtBebyggelse','Bebyggelse'),
   ('storby','By'),
   ('kristen',''),
   ('akvarium','Akvarium'),
   ('andenBygning','Bygning'),
   ('efterskoleUngdomsskole','Ungdomsskole'),
   ('fagskole','Fagskole'),
   ('feriecenter','Feriecenter'),
   ('folkehøjskole','Folkehøjskole');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('folkeskole','Folkeskole'),
   ('forskningscenter','Forskningscenter'),
   ('friluftsgård','Friluftsgård'),
   ('fængsel','Fængsel'),
   ('gymnasium','Gymnasium'),
   ('gård','Gård'),
   ('hal','Hal'),
   ('herregård','Herregård'),
   ('hospital','Hospital'),
   ('hotel','Hotel');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('hus','Hus'),
   ('kirkeAndenKristen','Kirke'),
   ('kirkeProtestantisk','Kirke'),
   ('kommunekontor','Kommunekontor'),
   ('kraftvarmeværk','Kraftvarmeværk'),
   ('kursuscenter','Kursuscenter'),
   ('moske','Moske'),
   ('museumSamling','Museum'),
   ('observatorium','Observatorium'),
   ('privatskoleFriskole','Friskole');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('professionshøjskole','Professionshøjskole'),
   ('regionsgård','Regionsgård'),
   ('rådhus','Rådhus'),
   ('slot','Slot'),
   ('specialskole','Specialskole'),
   ('synagoge','Synagoge'),
   ('søredningsstation','Søredningsstation'),
   ('terminal','Terminal'),
   ('terrarium','Terrarium'),
   ('turistbureau','Turistbureau');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('uddannelsescenter','Uddannelsescenter'),
   ('universitet','Universitet'),
   ('vandkraftværk','Vandkraftværk'),
   ('vandmølle','Vandmølle'),
   ('vandrerhjem','Vandrerhjem'),
   ('vejrmølle','Vejrmølle'),
   ('campingsplads','Campingsplads'),
   ('bilfærge','Bilfærge'),
   ('personfærge','Personfærge'),
   ('bredning','Bredning');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('bugt','Bugt'),
   ('fjord','Fjord'),
   ('hav','Hav'),
   ('løb','Løb'),
   ('nor','Nor'),
   ('sejlløb','Sejlløb'),
   ('sund','Sund'),
   ('batteri','Batteri'),
   ('bautasten','Bautasten'),
   ('boplads','Boplads');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('dysse','Dysse'),
   ('fundsted','Fundsted'),
   ('fæstningsanlæg','Fæstningsanlæg'),
   ('gravhøj','Gravhøj'),
   ('hellekiste','Hellekiste'),
   ('helleristning','Helleristning'),
   ('historiskMindeHistoriskAnlæg','Historisk anlæg'),
   ('jættestue','Jættestue'),
   ('krigergrav','Krigergrav'),
   ('køkkenmøding','Køkkenmøding');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('langdysse','Langdysse'),
   ('oldtidsager','Oldtidsager'),
   ('oldtidsminde','Oldtidsminde'),
   ('oldtidsvej','Oldtidsvej'),
   ('ruin','Ruin'),
   ('runddysse','Runddysse'),
   ('runesten','Runesten'),
   ('røse','Røse'),
   ('skanse','Skanse'),
   ('skibssætning','Skibssætning');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('tomt','Tomt'),
   ('vej','Vej'),
   ('vikingeborg','Vikingeborg'),
   ('voldVoldsted','Vold'),
   ('land','Land'),
   ('sø','Sø'),
   ('fiskerihavn','Fiskerihavn'),
   ('lystbådehavn','Lystbådehavn'),
   ('trafikhavn','Trafikhavn'),
   ('cykelbane','Cykelbane');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('goKartbane','Gokartbane'),
   ('golfbane','Golfbane'),
   ('hestevæddeløbsbane','Hestevæddeløbsbane'),
   ('hundevæddeløbsbane','Hundevæddeløbsbane'),
   ('motocrossbane','Motocrossbane'),
   ('motorbane','Motorbane'),
   ('skydebane','Skydebane'),
   ('stadion','Stadion'),
   ('jernbanetunnel','Jernbanetunnel'),
   ('veteranjernbane','Veteranjernbane');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('bakke','Bakke'),
   ('dal','Dal'),
   ('hage','Hage'),
   ('halvø','Halvø'),
   ('hule','Hule'),
   ('højBanke','Høj'),
   ('højdedrag','Højdedrag'),
   ('klint','Klint'),
   ('kløft','Kløft'),
   ('lavning','Lavning');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('næs','Næs'),
   ('odde','Odde'),
   ('pynt','Pynt'),
   ('skræntNaturlig','Skrænt'),
   ('skær','Skær'),
   ('slugt','Slugt'),
   ('tange','Tange'),
   ('ø','Ø'),
   ('øgruppe','Øgruppe'),
   ('ås','Ås');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('flyveplads','Flyveplads'),
   ('heliport','Heliport'),
   ('landingsplads','Landingsplads'),
   ('mindreLufthavn','Lufthavn'),
   ('størreLufthavn','Lufthavn'),
   ('svæveflyveplads','Svæveflyveplads'),
   ('agerMark','Mark'),
   ('eng','Eng'),
   ('hede','Hede'),
   ('klippeIOverfladen','Klippe');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('marsk','Marsk'),
   ('moseSump','Mose'),
   ('parkAnlæg','Park'),
   ('sandKlit','Sandklit'),
   ('skovPlantage','Skov'),
   ('strand','Strand'),
   ('båke','Båke'),
   ('fyr','Fyr'),
   ('fyrtårn','Fyrtårn'),
   ('nationalpark','Nationalpark');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('reservat','Reservat'),
   ('restriktionsareal','Restriktionsareal'),
   ('europavej','Europavej'),
   ('margueritrute','Margueritrute'),
   ('motorvejafkørselsnummer','Motorvejafkørselsnummer'),
   ('primærRingvej','Ringvej'),
   ('primærVejrute','Vejrute'),
   ('sekundærRingvej','Ringvej'),
   ('sekundærVejrute','Vejrute'),
   ('andenSeværdighed','Seværdighed');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('arboret','Arboret'),
   ('blomsterpark','Blomsterpark'),
   ('botaniskHave','Botanisk have'),
   ('dyrepark','Dyrepark'),
   ('forlystelsespark','Forlystelsespark'),
   ('frilandsmuseum','Frilandsmuseum'),
   ('zoologiskHave','Zoologisk have'),
   ('tog','Tog'),
   ('dige','Dige'),
   ('dæmning','Dæmning');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('Andet',''),
   ('Bebyggelse','Bebyggelse'),
   ('Begravelsesplads','Begravelsesplads'),
   ('Bygning','Bygning'),
   ('Friluftsbad','Friluftsbad'),
   ('Idrætsanlæg','Idrætsanlæg'),
   ('Naturareal','Naturareal'),
   ('Sø','Sø'),
   ('Vandløb','Vandløb'),
   ('tørtVedLavvande','Tørt ved lavvande');
INSERT INTO stednavne_udstilling.subtype_translation (subtype,subtype_presentation) VALUES
   ('undersøiskGrund','Grund'),
   ('vandløb','Vandløb'),
   ('låningsvej','Låningsvej'),
   ('vejbro','Bro'),
   ('sti','Sti'),
   ('ebbevej','Ebbevej'),
   ('vejtunnel','Tunnel'),
   ('plads','Plads'),
   ('','');
