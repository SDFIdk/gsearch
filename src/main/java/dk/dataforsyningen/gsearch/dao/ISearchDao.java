package dk.dataforsyningen.gsearch.dao;

import dk.dataforsyningen.gsearch.datamodel.Adresse;
import dk.dataforsyningen.gsearch.datamodel.Husnummer;
import dk.dataforsyningen.gsearch.datamodel.Kommune;
import dk.dataforsyningen.gsearch.datamodel.Matrikel;
import dk.dataforsyningen.gsearch.datamodel.MatrikelUdgaaet;
import dk.dataforsyningen.gsearch.datamodel.Navngivenvej;
import dk.dataforsyningen.gsearch.datamodel.Opstillingskreds;
import dk.dataforsyningen.gsearch.datamodel.Politikreds;
import dk.dataforsyningen.gsearch.datamodel.Postnummer;
import dk.dataforsyningen.gsearch.datamodel.Region;
import dk.dataforsyningen.gsearch.datamodel.Retskreds;
import dk.dataforsyningen.gsearch.datamodel.Sogn;
import dk.dataforsyningen.gsearch.datamodel.Stednavn;
import java.util.List;

public interface ISearchDao {
  List<Adresse> getAdresse(String q, String where, Integer limit, Integer srid);

  List<Husnummer> getHusnummer(String q, String where, Integer limit,
                               Integer srid);

  List<Kommune> getKommune(String q, String where, Integer limit,
                           Integer srid);

  List<Matrikel> getMatrikel(String q, String where, Integer limit,
                             Integer srid);

  List<MatrikelUdgaaet> getMatrikelUdgaaet(String q, String where, Integer limit,
                                           Integer srid);

  List<Navngivenvej> getNavngivenvej(String q, String where, Integer limit,
                                     Integer srid);

  List<Opstillingskreds> getOpstillingskreds(String q, String where, Integer limit,
                                             Integer srid);

  List<Politikreds> getPolitikreds(String q, String where, Integer limit,
                                   Integer srid);

  List<Postnummer> getPostnummer(String q, String where, Integer limit,
                                 Integer srid);

  List<Region> getRegion(String q, String where, Integer limit,
                         Integer srid);

  List<Retskreds> getRetskreds(String q, String where, Integer limit,
                               Integer srid);

  List<Sogn> getSogn(String q, String where, Integer limit,
                     Integer srid);

  List<Stednavn> getStednavn(String q, String where, Integer limit,
                             Integer srid);

}
