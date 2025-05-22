package dk.dataforsyningen.gsearch.service;

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
import java.util.Optional;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.filter.text.cql2.CQLException;

public interface ISearchService {

  List<Adresse> getAdresseResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Husnummer> getHusnummerResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Kommune> getKommuneResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Matrikel> getMatrikelResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<MatrikelUdgaaet> getMatrikelUdgaaetResult(String q, Optional<String> filter, Integer limit,
                                                 Integer srid)
      throws FilterToSQLException, CQLException;

  List<Navngivenvej> getNavngivenvejResult(String q, Optional<String> filter, Integer limit,
                                           Integer srid)
      throws FilterToSQLException, CQLException;

  List<Opstillingskreds> getOpstillingskredsResult(String q, Optional<String> filter, Integer limit,
                                                   Integer srid)
      throws FilterToSQLException, CQLException;

  List<Politikreds> getPolitikredsResult(String q, Optional<String> filter, Integer limit,
                                         Integer srid)
      throws FilterToSQLException, CQLException;

  List<Postnummer> getPostnummerResult(String q, Optional<String> filter, Integer limit,
                                       Integer srid)
      throws FilterToSQLException, CQLException;

  List<Region> getRegionResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Retskreds> getRetskredsResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Sogn> getSognResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;

  List<Stednavn> getStednavnResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException;
}
