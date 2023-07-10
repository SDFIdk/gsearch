package dk.dataforsyningen.gsearch.service;

import java.util.List;
import java.util.Optional;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.filter.text.cql2.CQLException;

public interface ISearchService {
  <T> List<T> getResult(String q, String resource, Optional<String> filter, Integer limit)
      throws FilterToSQLException, CQLException;
}
