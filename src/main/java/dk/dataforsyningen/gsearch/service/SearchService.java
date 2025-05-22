package dk.dataforsyningen.gsearch.service;

import dk.dataforsyningen.gsearch.dao.ISearchDao;
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
import dk.dataforsyningen.gsearch.rest.Controller;
import java.util.List;
import java.util.Optional;
import org.geotools.api.filter.Filter;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SearchService implements ISearchService {

  static Logger logger = LoggerFactory.getLogger(Controller.class);
  static PostGISDialect dialect = new PostGISDialect(null);
  static FilterToSQL filterToSQL = new CustomPostgisFilterToSQL(dialect);

  static {
    dialect.setFunctionEncodingEnabled(true);
    filterToSQL.setInline(true);
  }

  private final ISearchDao iSearchDao;

  @Autowired
  public SearchService(ISearchDao iSearchDao) {
    this.iSearchDao = iSearchDao;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Adresse> getAdresseResult(String q, Optional<String> filter, Integer limit,
                                        Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Adresse> result = iSearchDao.getAdresse(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Husnummer> getHusnummerResult(String q, Optional<String> filter, Integer limit,
                                            Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Husnummer> result = iSearchDao.getHusnummer(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Kommune> getKommuneResult(String q, Optional<String> filter, Integer limit,
                                        Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Kommune> result = iSearchDao.getKommune(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Matrikel> getMatrikelResult(String q, Optional<String> filter, Integer limit,
                                          Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Matrikel> result = iSearchDao.getMatrikel(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<MatrikelUdgaaet> getMatrikelUdgaaetResult(String q, Optional<String> filter,
                                                        Integer limit, Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<MatrikelUdgaaet> result =
        iSearchDao.getMatrikelUdgaaet(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Navngivenvej> getNavngivenvejResult(String q, Optional<String> filter, Integer limit,
                                                  Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Navngivenvej> result = iSearchDao.getNavngivenvej(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Opstillingskreds> getOpstillingskredsResult(String q, Optional<String> filter,
                                                          Integer limit, Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Opstillingskreds> result =
        iSearchDao.getOpstillingskreds(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Politikreds> getPolitikredsResult(String q, Optional<String> filter, Integer limit,
                                                Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Politikreds> result = iSearchDao.getPolitikreds(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Postnummer> getPostnummerResult(String q, Optional<String> filter, Integer limit,
                                              Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Postnummer> result = iSearchDao.getPostnummer(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Region> getRegionResult(String q, Optional<String> filter, Integer limit,
                                      Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Region> result = iSearchDao.getRegion(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Retskreds> getRetskredsResult(String q, Optional<String> filter, Integer limit,
                                            Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Retskreds> result = iSearchDao.getRetskreds(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Sogn> getSognResult(String q, Optional<String> filter, Integer limit, Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Sogn> result = iSearchDao.getSogn(q, finalWhere, limit, srid);

    return result;
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public List<Stednavn> getStednavnResult(String q, Optional<String> filter, Integer limit,
                                          Integer srid)
      throws FilterToSQLException, CQLException {

    String finalWhere = getWhereClause(filter, srid);

    List<Stednavn> result = iSearchDao.getStednavn(q, finalWhere, limit, srid);

    return result;
  }

  private String getWhereClause(Optional<String> filter, Integer srid)
      throws CQLException, FilterToSQLException {
    String where = null;
    // If filter is present we need to change the CQl to SQL
    if (filter.isPresent()) {
      // To transform cql filter to sql where clause
      Filter ogcFilter = ECQL.toFilter(filter.get());
      logger.debug("ogcFilter: " + ogcFilter);

      // Fixes shared memory issue with `out`
      synchronized (this) {
        where = filterToSQL.encodeToString(ogcFilter);
      }

      logger.debug("where: " + where);
    }

    // NOTE: Hack correct SRID
    String finalWhere = where == null ? null : where.replaceAll("', null", "', " + srid);
    logger.debug("finalWhere: " + finalWhere);
    return finalWhere;
  }
}
