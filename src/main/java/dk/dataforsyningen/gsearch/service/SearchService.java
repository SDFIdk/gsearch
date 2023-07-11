package dk.dataforsyningen.gsearch.service;

import dk.dataforsyningen.gsearch.dao.ISearchDao;
import dk.dataforsyningen.gsearch.rest.Controller;
import java.util.List;
import java.util.Optional;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.opengis.filter.Filter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SearchService implements ISearchService {

  private final ISearchDao iSearchDao;

  @Autowired
  public SearchService(ISearchDao iSearchDao) {
    this.iSearchDao = iSearchDao;
  }

  static Logger logger = LoggerFactory.getLogger(Controller.class);

  static PostGISDialect dialect = new PostGISDialect(null);
  static FilterToSQL filterToSQL = new CustomPostgisFilterToSQL(dialect);

  static {
    dialect.setFunctionEncodingEnabled(true);
    filterToSQL.setInline(true);
  }

  /**
   * Transform request to database query, execute query and return the result.
   *
   * @param q
   * @param resource
   * @param filter
   * @param limit
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  public <T> List<T> getResult(String q, String resource, Optional<String> filter, Integer limit)
      throws FilterToSQLException, CQLException {

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
    String finalWhere = where == null ? null : where.replaceAll("', null", "', 25832");
    logger.debug("finalWhere: " + finalWhere);

    List<T> result = iSearchDao.getData(q, resource, finalWhere, limit);

    return result;
  }
}
