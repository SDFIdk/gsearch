package dk.dataforsyningen.gsearch;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Root resource (exposed at "helloworld" path)
 */
@Path("helloworld")
public class HelloWorld {
    static Logger logger = LoggerFactory.getLogger(HelloWorld.class);

    Jdbi jdbi = DatabaseManager.getJdbi();

    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String helloWorld() {
        logger.debug("helloWorld called");
        String helloWorld = jdbi.withHandle(handle -> {
            String sql = "select 'Hello world!'";
            return handle.createQuery(sql).mapTo(String.class).first();
        });
        return helloWorld;
    }
}
