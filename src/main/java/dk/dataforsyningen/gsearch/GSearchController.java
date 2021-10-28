package dk.dataforsyningen.gsearch;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import net.postgis.jdbc.jts.JtsBinaryParser;

@RestController
public class GSearchController {

    static Logger logger = LoggerFactory.getLogger(GSearchController.class);

    @Autowired
	private Jdbi jdbi;

    @Autowired
	private ResourceTypes resourceTypes;

    JtsBinaryParser binaryParser = new JtsBinaryParser();

    class DataMapper implements RowMapper<Data> {
        ResultSetMetaData meta;
        String resource;

        public DataMapper(String resource) {
            this.resource = resource;
        }

        private Object mapColumn(int i, ResultSet rs) throws SQLException {
            if (meta.getColumnTypeName(i).equals("geometry")) {
                // TODO: find out how to parse binary directly
                //byte[] bytes = rs.getBytes(i);
                //Geometry geometry = binaryParser.parse(bytes);
                String hex = rs.getString(i);
                Geometry geometry = binaryParser.parse(hex);
                return geometry;
            } else {
                return rs.getString(i);
            }
        }

        @Override
        public Data map(ResultSet rs, StatementContext ctx) throws SQLException {
            Data data = new Data();
            data.type = resource;
            for (int i = 1; i <= meta.getColumnCount(); i++)
                data.add(meta.getColumnName(i), mapColumn(i, rs));
            return data;
        }

        @Override
        public DataMapper specialize(ResultSet rs, StatementContext ctx) throws SQLException {
            meta = rs.getMetaData();
            return this;
        }
    }

    private List<Data> getData(String search, String resource) {
        return jdbi.withHandle(handle -> {
            String sql = "select (api." + resource + "(:search, NULL, 1, 100)).*";
            handle.registerRowMapper(FieldMapper.factory(Data.class));
            List<Data> data = handle
                .createQuery(sql)
                .bind("search", search)
                .map(new DataMapper(resource))
                .list();
            return data;
        });
    }

    @GetMapping(path = "/geosearch", produces = MediaType.APPLICATION_JSON_VALUE)
    public Result geosearch(@RequestParam("search") String search, @RequestParam("resources") String resources) {
        logger.debug("geosearch called");

        if (search == null || search.isEmpty())
            throw new RuntimeException("Query string parameter search is required");

        if (resources == null || resources.isEmpty())
            throw new RuntimeException("Query string parameter resources is required");

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!resourceTypes.getTypes().contains(requestedTypes[i]))
                throw new RuntimeException("Resource " + requestedTypes[i] + " does not exist");

        List<Data> data = Stream.of(requestedTypes)
            .parallel()
            .map(t -> getData(search, t))
            .flatMap(List::stream)
            .collect(Collectors.toList());

        Result result = new Result();
        result.status = "OK";
        result.message = "OK";
        result.data = data;
        return result;
    }
}
