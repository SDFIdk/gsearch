package dk.dataforsyningen.gsearch;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("geosearch")
public class Geosearch {
    Logger logger = LoggerFactory.getLogger(Geosearch.class);

    Jdbi jdbi = DatabaseManager.getJdbi();
    Set<String> types = DatabaseManager.getInstance().getTypes();

    class DataMapper implements RowMapper<Data> {
        ResultSetMetaData meta;
        String resource;

        public DataMapper(String resource) {
            this.resource = resource;
        }

        @Override
        public Data map(ResultSet rs, StatementContext ctx) throws SQLException {
            Data data = new Data();
            data.type = resource;
            for (int i = 1; i <= meta.getColumnCount(); i++)
                data.add(meta.getColumnName(i), rs.getString(i));
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

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Result geosearch(@QueryParam("search") String search, @QueryParam("resources") String resources) {
        logger.debug("geosearch called");

        if (search == null || search.isEmpty())
            throw new RuntimeException("Query string parameter search is required");

        if (resources == null || resources.isEmpty())
            throw new RuntimeException("Query string parameter resources is required");

        String[] requestedTypes = resources.split(",");

        for (int i = 0; i < requestedTypes.length; i++)
            if (!types.contains(requestedTypes[i]))
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
