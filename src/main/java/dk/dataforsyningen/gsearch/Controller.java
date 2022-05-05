package dk.dataforsyningen.gsearch;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.opengis.filter.Filter;
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
    private ObjectMapper objectMapper;

    @Autowired
	private ResourceTypes resourceTypes;

    /**
     * It assembles full sql query from the parameters and maps the result to list of data entities
     * @param search
     * @param resource
     * @param where
     * @param limit
     * @return
     */
    private List<Data> getData(String search, String resource, String where, int limit) {
        return jdbi.withHandle(handle -> {
            String sql = "select (api." + resource + "(:search, :where, 1, :limit)).*";
            // TODO: This gets register every time this method gets called
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

    /**
     * Transform request to database query, execute query and return the result
     * @param search
     * @param resources
     * @param filter
     * @param limit
     * @return
     * @throws FilterToSQLException
     * @throws CQLException
     */
    private Result getResult(String search, String resources, String filter, String limit)
            throws FilterToSQLException, CQLException {
        logger.debug("getResult called");

        if (search == null || search.isEmpty())
            throw new IllegalArgumentException("Query string parameter search is required");

        if (resources == null || resources.isEmpty())
            throw new IllegalArgumentException("Query string parameter resources is required");

        String where = null;
        if (filter != null && !filter.isEmpty()) {
            // To transform cql filter to sql where clause
            Filter ogcFilter = ECQL.toFilter(filter);
            // TODO: visit filter to apply restrictions
            // TODO: visit filter to remove non applicable (field name not in type fx.)
            where = filterToSQL.encodeToString(ogcFilter);
            logger.info("where: " + where);
        }

        int limitInt = Integer.parseInt(limit);
        if (limitInt < 1 || limitInt > 100)
            throw new IllegalArgumentException("Query string parameter limit must be between 1-100");

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!resourceTypes.getTypes().contains(requestedTypes[i]))
                throw new IllegalArgumentException("Resource " + requestedTypes[i] + " does not exist");

        // Need to remove the WHERE clause because getData expects only the expression
        String whereExpression = where != null ? where.replace("WHERE ", "") : null;

        // Map requested types into results via query in parallel
        // Concatenate into single list of results
        List<Data> data = Stream.of(requestedTypes)
            .parallel()
            .map(resourceType -> getData(search, resourceType, whereExpression,  limitInt))
            .flatMap(List::stream)
            .collect(Collectors.toList());

        Result result = new Result();
        result.status = "OK";
        result.message = "OK";
        result.data = data;
        return result;
    }

    /**
     *
     * @param search
     * @param resources
     * @param filter
     * @param limit
     * @return
     * @throws CQLException
     * @throws FilterToSQLException
     */
    @GetMapping(path = "/geosearch", produces = MediaType.APPLICATION_JSON_VALUE, params = {
        "search", "resources"})
    public Result geosearch(
            @RequestParam String search,
            @RequestParam String resources,
            @RequestParam(required = false) String filter,
            @RequestParam(defaultValue = "10") String limit)
                throws CQLException, FilterToSQLException {
        // FIXME: Needs checks to see if it compatible with old geosearch
        logger.debug("geosearch called");
        Result result = getResult(search, resources, filter, limit);
        return result;
    }


    /**
     * JSONP endpoint variant (the old way)
     * @param search
     * @param resources
     * @param filter
     * @param callback
     * @param limit
     * @return
     * @throws CQLException
     * @throws FilterToSQLException
     * @throws JsonProcessingException
     */
    @GetMapping(path = "/geosearch", produces = "application/x-javascript", params = {
        "search", "resources", "callback"})
    public String geosearchWithCallback(
            @RequestParam String search,
            @RequestParam String resources,
            @RequestParam(required = false) String filter,
            @RequestParam(required = false) String callback,
            @RequestParam(defaultValue = "10") String limit)
                throws CQLException, FilterToSQLException, JsonProcessingException {
        logger.debug("geosearchWithCallback called");
        Result result = getResult(search, resources, filter, limit);
        // Wraps the result in javascript callback
        String resultStr = objectMapper.writeValueAsString(result);
        String output = callback + "(" + resultStr + ")";
        return output;
    }
}
