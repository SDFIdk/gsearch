SELECT '151_stednavne_indexes.sql' || now();

CREATE INDEX ON stednavne.andentopografiflade USING btree (objectid);

CREATE INDEX ON stednavne.andentopografipunkt USING btree (objectid);

CREATE INDEX ON stednavne.bebyggelse USING btree (objectid);

CREATE INDEX ON stednavne.begravelsesplads USING btree (objectid);

CREATE INDEX ON stednavne.bygning USING btree (objectid);

CREATE INDEX ON stednavne.campingplads USING btree (objectid);

CREATE INDEX ON stednavne.farvand USING btree (objectid);

CREATE INDEX ON stednavne.fortidsminde USING btree (objectid);

CREATE INDEX ON stednavne.friluftsbad USING btree (objectid);

CREATE INDEX ON stednavne.havnebassin USING btree (objectid);

CREATE INDEX ON stednavne.idraetsanlaeg USING btree (objectid);

CREATE INDEX ON stednavne.jernbane USING btree (objectid);

CREATE INDEX ON stednavne.landskabsform USING btree (objectid);

CREATE INDEX ON stednavne.lufthavn USING btree (objectid);

CREATE INDEX ON stednavne.naturareal USING btree (objectid);

CREATE INDEX ON stednavne.navigationsanlaeg USING btree (objectid);

CREATE INDEX ON stednavne.restriktionsareal USING btree (objectid);

CREATE INDEX ON stednavne.sevaerdighed USING btree (objectid);

CREATE INDEX ON stednavne.soe USING btree (objectid);

CREATE INDEX ON stednavne.standsningssted USING btree (objectid);

CREATE INDEX ON stednavne.terraenkontur USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnflade USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnlinje USING btree (objectid);

CREATE INDEX ON stednavne.ubearbejdetnavnpunkt USING btree (objectid);

CREATE INDEX ON stednavne.urentfarvand USING btree (objectid);

CREATE INDEX ON stednavne.vandloeb USING btree (objectid);

CREATE INDEX ON stednavne.vej USING btree (objectid);

CREATE INDEX ON stednavne.stednavn USING btree (navngivetsted_objectid);
