package dk.dataforsyningen.gsearch;

import java.util.List;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("demo")
public class Demo {

    Jdbi jdbi = DatabaseManager.getJdbi();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<DemoResult> demo(@DefaultValue("Farum") @QueryParam("q") String q) {
        Logger logger = LoggerFactory.getLogger(Demo.class.getName());

        logger.info("demo called");

        return jdbi.withHandle(handle -> {
            String sql = "select (api.demo('" + q + "', NULL, 1, 100)).*";
            logger.info("Executing SQL " + sql);
            handle.registerRowMapper(FieldMapper.factory(DemoResult.class));
            List<DemoResult> results = handle
                .createQuery(sql)
                .mapTo(DemoResult.class)
                .list();
            return results;
        });
    }
}
