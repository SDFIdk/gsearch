package dk.dataforsyningen.gsearch;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;

import org.glassfish.grizzly.http.server.HttpServer;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class GeosearchTest {

    private static HttpServer server;
    private static WebTarget target;

    @BeforeClass
    public static void setUp() throws Exception {
        server = Main.startServer();
        Client c = ClientBuilder.newClient();
        target = c.target(Main.BASE_URI);
    }

    @AfterClass
    public static void tearDown() throws Exception {
        server.shutdownNow();
    }

    @Test
    public void testGeosearch() {
        Result result = target
            .path("geosearch")
            .queryParam("search", "Farum")
            .queryParam("resources", "postdistrikt")
            .request().get(Result.class);
        assertEquals(1, result.data.size());
    }
}
