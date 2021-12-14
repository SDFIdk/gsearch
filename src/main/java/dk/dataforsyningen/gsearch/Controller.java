package dk.dataforsyningen.gsearch;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    static Logger logger = LoggerFactory.getLogger(Controller.class);

    static FilterToSQL filterToSQL = new PostGISDialect(null).createFilterToSQL();

    @Autowired
	private Jdbi jdbi;

    @Autowired
	private ResourceTypes resourceTypes;

    private List<Data> getData(String search, String resource, String where, int limit) {
        return jdbi.withHandle(handle -> {
            String sql = "select (api." + resource + "(:search, :where, 1, :limit)).*";
            handle.registerRowMapper(FieldMapper.factory(Data.class));
            List<Data> data = handle
                .createQuery(sql)
                .bind("search", search)
                .bind("where", where)
                .bind("limit", limit)
                .map(new DataMapper(resource))
                .list();
            return data;
        });
    }

    @GetMapping(path = "/geosearch", produces = MediaType.APPLICATION_JSON_VALUE)
    public Result geosearch(
        @RequestParam String search,
        @RequestParam String resources,
        @RequestParam(required = false) String filter,
        @RequestParam(defaultValue = "10") String limit) throws CQLException, FilterToSQLException {

        logger.debug("geosearch called");

        if (search == null || search.isEmpty())
            throw new IllegalArgumentException("Query string parameter search is required");

        if (resources == null || resources.isEmpty())
            throw new IllegalArgumentException("Query string parameter resources is required");

        String where = null;
        if (filter != null && !filter.isEmpty()) {
            where = filterToSQL.encodeToString(ECQL.toFilter(filter));
            logger.info("where: " + where);
        }

        int limitInt = Integer.parseInt(limit);
        if (limitInt < 1 || limitInt > 100)
            throw new IllegalArgumentException("Query string parameter limit must be between 1-100");

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!resourceTypes.getTypes().contains(requestedTypes[i]))
                throw new IllegalArgumentException("Resource " + requestedTypes[i] + " does not exist");

        String whereExpression = where != null ? where.replace("WHERE ", "") : null;
        List<Data> data = Stream.of(requestedTypes)
            .parallel()
            .map(t -> getData(search, t, whereExpression,  limitInt))
            .flatMap(List::stream)
            .collect(Collectors.toList());

        Result result = new Result();
        result.status = "OK";
        result.message = "OK";
        result.data = data;
        return result;
    }
}
