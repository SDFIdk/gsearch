package dk.dataforsyningen.gsearch.rest;

import dk.dataforsyningen.gsearch.ResourceTypes;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import java.util.Optional;
import javax.validation.constraints.Max;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Positive;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Validated
@RestController
public class Controller {

    static Logger logger = LoggerFactory.getLogger(Controller.class);

    static PostGISDialect dialect = new PostGISDialect(null);
    static FilterToSQL filterToSQL = new CustomPostgisFilterToSQL(dialect);

    static {
        dialect.setFunctionEncodingEnabled(true);
        filterToSQL.setInline(true);
    }

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
    private List<Data> getData(String q, String resource, String where, Integer limit) {
        return jdbi.withHandle(handle -> {
            String sql = "select (api." + resource + "(:q, :where, 1, :limit)).*";
            // TODO: This gets register every time this method gets called
            handle.registerRowMapper(FieldMapper.factory(Data.class));
            List<Data> data = handle
                .createQuery(sql)
                .bind("q", q)
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
    private List<Data> getResult(String q, String resources, Optional<String> filter, int limit)
        throws FilterToSQLException, CQLException {

        String where = null;
        // If filter is present we need to change the CQl to SQL
        if (filter.isPresent()) {
            // To transform cql filter to sql where clause
            Filter ogcFilter = ECQL.toFilter(filter.get());
            // TODO: visit filter to apply restrictions
            // TODO: visit filter to remove non applicable (field name not in type fx.)
            where = filterToSQL.encodeToString(ogcFilter);
            logger.debug("where: " + where);
        }

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!resourceTypes.getTypes().contains(requestedTypes[i]))
                throw new IllegalArgumentException("Resource " + requestedTypes[i] + " does not exist");

        // NOTE: Hack correct SRID
        String finalWhere = where == null ? null : where.replaceAll("', null", "', 25832");
        logger.debug("finalWhere: " + finalWhere);

        // Map requested types into results via query in parallel
        // Concatenate into single list of results
        List<Data> result = Stream.of(requestedTypes)
            .parallel()
            .map(resourceType -> getData(q, resourceType, finalWhere, limit))
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
    public List<Data> gsearch(
        @Parameter(description = "Søgestreng")
        @RequestParam(value = "q", required = true) @NotBlank String q,
        @Parameter(description = "Er en kommasepareret liste på 'resources' navn. Se Schemas for deltajeret beskrivelse af resourcer.")
        @RequestParam(value = "resources", required = true) @NotBlank String resources,
        @Parameter(description = "Angives med CQL-text, og udefra beskrivelser af mulige filtreringer for den valgte resource.")
        @RequestParam(required = false) Optional<String> filter,
        @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
        @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
        throws FilterToSQLException, CQLException {

        // filter (CQL) is not compatible with requesting multiple resources at the same time
        if (StringUtils.containsAny(resources, ",") && filter.isPresent())
        {
            throw new IllegalArgumentException("Defined query parameter filter and multiple resources is incompatible");
        }

        List<Data> result = getResult(q, resources, filter, limit);
        return result;
    }
}
