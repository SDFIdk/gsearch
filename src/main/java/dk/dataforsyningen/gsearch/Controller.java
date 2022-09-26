package dk.dataforsyningen.gsearch;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
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

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RestController
public class Controller {

    static Logger logger = LoggerFactory.getLogger(Controller.class);

    static FilterToSQL filterToSQL = new PostGISDialect(null).createFilterToSQL();

    @Autowired
    private Jdbi jdbi;

    @Autowired
    private ResourceTypes resourceTypes;

    /**
     * It assembles full sql query from the parameters and maps the result to list of data entities
     *
     * @param q
     * @param resource
     * @param where
     * @param limit
     * @return
     */
    private List<Data> getData(String q, String resource, String where, int limit) {
        return jdbi.withHandle(handle -> {
            String sql = "select (api." + resource + "(:q, :where, 1, :limit)).*";
            // TODO: This gets register every time this method gets called
            handle.registerRowMapper(FieldMapper.factory(Data.class));
            List<Data> data = handle
                .createQuery(sql)
                .bind("search", q)
                .bind("where", where)
                .bind("limit", limit)
                .map(new DataMapper(resource))
                .list();
            return data;
        });
    }

    /**
     * Transform request to database query, execute query and return the result
     *
     * @param q
     * @param resources
     * @param filter
     * @param limit
     * @return
     * @throws FilterToSQLException
     * @throws CQLException
     */
    private List<Data> getResult(String q, String resources, String filter, String limit)
        throws FilterToSQLException, CQLException {
        if (q == null || q.isEmpty()) {
            throw new IllegalArgumentException("Query string parameter q is required");
        }

        if (resources == null || resources.isEmpty()) {
            throw new IllegalArgumentException("Query string parameter resources is required");
        }

        String where = null;
        if (filter != null && !filter.isEmpty()) {
            // To transform cql filter to sql where clause
            Filter ogcFilter = ECQL.toFilter(filter);
            // TODO: visit filter to apply restrictions
            // TODO: visit filter to remove non applicable (field name not in type fx.)
            where = filterToSQL.encodeToString(ogcFilter);
            logger.debug("where: " + where);
        }

        int limitInt = Integer.parseInt(limit);
        if (limitInt < 1 || limitInt > 100) {
            throw new IllegalArgumentException("Query string parameter limit must be between 1-100");
        }

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!resourceTypes.getTypes().contains(requestedTypes[i])) {
                throw new IllegalArgumentException("Resource " + requestedTypes[i] + " does not exist");
            }

        // Need to remove the WHERE clause because getData expects only the expression
        String whereExpression = where != null ? where.replace("WHERE ", "") : null;

        // Map requested types into results via query in parallel
        // Concatenate into single list of results
        List<Data> result = Stream.of(requestedTypes)
            .parallel()
            .map(resourceType -> getData(q, resourceType, whereExpression, limitInt))
            .flatMap(List::stream)
            .collect(Collectors.toList());

        return result;
    }

    /**
     * @param q
     * @param resources
     * @param filter
     * @param limit
     * @return
     * @throws CQLException
     * @throws FilterToSQLException
     */
    @GetMapping(path = "/search", produces = MediaType.APPLICATION_JSON_VALUE)
    @Operation(tags = {"Gsearch"})
    public List<Data> geosearch(
        @Parameter(description = "Søgestreng")
        @RequestParam String q,
        @Parameter(description = "Er en kommasepereatet list på resources navn. Se Schemas for deltajeret beskrivelse af resourcer.")
        @RequestParam String resources,
        @Parameter(description = "Angives med CQL-text, og udefra beskrivelser af mulige filtreringer for den valgte resource.")
        @RequestParam(required = false) String filter,
        @Parameter(description = "Maksantallet af returneret data elementer. Max = 100")
        @RequestParam(defaultValue = "10") String limit)
        throws CQLException, FilterToSQLException {
        // FIXME: Needs checks to see if it compatible with old geosearch
        logger.debug("gsearch called");
        List<Data> result = getResult(q, resources, filter, limit);
        return result;
    }
}
