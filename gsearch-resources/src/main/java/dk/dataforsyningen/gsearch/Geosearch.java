package dk.dataforsyningen.gsearch;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

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
    Jdbi jdbi = DatabaseManager.getJdbi();

    class DataMapper implements RowMapper<Data> {
        ResultSetMetaData meta;

        @Override
        public Data map(ResultSet rs, StatementContext ctx) throws SQLException {
            Data data = new Data();
            data.type = "postdistrikt";
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                data.add(meta.getColumnName(i), rs.getString(i));
            }
            return data;
        }

        @Override
        public DataMapper specialize(ResultSet rs, StatementContext ctx) throws SQLException {
            meta = rs.getMetaData();
            return this;
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Result geosearch(@QueryParam("search") String search) {
        Logger logger = LoggerFactory.getLogger(Demo.class.getName());

        logger.info("geosearch called");

        return jdbi.withHandle(handle -> {
            String sql = "select (api.demo('" + search + "', NULL, 1, 100)).*";
            logger.info("Executing SQL " + sql);
            handle.registerRowMapper(FieldMapper.factory(Data.class));
            List<Data> data = handle
                .createQuery(sql)
                .map(new DataMapper())
                .list();
            Result result = new Result();
            result.status = "OK";
            result.message = "OK";
            result.data = data;
            return result;
        });
    }
}
