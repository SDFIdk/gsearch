package dk.dataforsyningen.gsearch.dao;

import dk.dataforsyningen.gsearch.mapper.DataMapper;
import java.util.List;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SearchDao implements ISearchDao {

  @Autowired
  private Jdbi jdbi;

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param resource
   * @param where
   * @param limit
   * @return
   */
  public <T> List<T> getData(String q, String resource, String where, Integer limit, Integer srid) {
    return (List<T>) jdbi.withHandle(handle -> {
      String sql = "select (api." + resource + "(:q, :where, 1, :limit)).*";
      // TODO: This gets register every time this method gets called
      handle.registerRowMapper(FieldMapper.factory(Object.class));
      List<Object> data = handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .map(new DataMapper(resource))
          .list();
      return data;
    });
  }
}
