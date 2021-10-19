package dk.dataforsyningen.gsearch;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Root resource (exposed at "helloworld" path)
 */
@Path("helloworld")
public class HelloWorld {

    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String helloWorld() {
        Logger logger = LoggerFactory.getLogger(HelloWorld.class.getName());

        logger.info("helloWorld called");

        String PGUSER = System.getenv("PGUSER");
        if (PGUSER == null || PGUSER.isEmpty())
            PGUSER = "postgres";
        String PGPASSWORD = System.getenv("PGPASSWORD");
        if (PGPASSWORD == null || PGPASSWORD.isEmpty())
            PGPASSWORD = "postgres";
        String PGDATABASE = System.getenv("PGDATABASE");
        if (PGDATABASE == null || PGDATABASE.isEmpty())
            PGDATABASE = "postgres";
        String PGHOST = System.getenv("PGHOST");
        if (PGHOST == null || PGHOST.isEmpty())
            PGHOST = "localhost";
        String PGPORT = System.getenv("PGPORT");
        if (PGPORT == null || PGPORT.isEmpty())
            PGPORT = "5432";

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:postgresql://" + PGHOST + ":" + PGPORT + "/" + PGDATABASE);
        config.setUsername(PGUSER);
        config.setPassword(PGPASSWORD);

        HikariDataSource ds = new HikariDataSource(config);
        Jdbi jdbi = Jdbi.create(ds);
        String helloWorld = jdbi.withHandle(handle -> {
            return handle.createQuery("select 'Hello world!'").mapTo(String.class).first();
        });

        return helloWorld;
    }
}
