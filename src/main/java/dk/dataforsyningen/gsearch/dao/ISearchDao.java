package dk.dataforsyningen.gsearch.dao;

import java.util.List;

public interface ISearchDao {
  <T> List<T> getData(String q, String resource, String where, Integer limit, Integer srid);
}
