package dk.dataforsyningen.gsearch;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;

import org.glassfish.grizzly.http.server.HttpServer;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class HelloWorldTest {

    private static HttpServer server;
    private static WebTarget target;

    @BeforeClass
    public static void setUp() throws Exception {
        server = Main.startServer();
        Client c = ClientBuilder.newClient();

        // uncomment the following line if you want to enable
        // support for JSON in the client (you also have to uncomment
        // dependency on jersey-media-json module in pom.xml and Main.startServer())
        // --
        // c.configuration().enable(new org.glassfish.jersey.media.json.JsonJaxbFeature());

        target = c.target(Main.BASE_URI);
    }

    @AfterClass
    public static void tearDown() throws Exception {
        server.shutdownNow();
        DatabaseManager.shutdown();
    }

    /**
     * Test to see that the message "Hello world!" is sent in the response.
     */
    @Test
    public void testGetIt() {
        String responseMsg = target.path("helloworld").request().get(String.class);
        assertEquals("Hello world!", responseMsg);
    }

    /**
     * Test to see that the message "Hello world!" is sent in the response.
     */
    @Test
    public void testDemo() {
        String responseMsg = target.path("demo").request().get(String.class);
        assertEquals("[{\"vejnavn\":\"Brudedalen\",\"postdistrikt\":\"Farum\"},{\"vejnavn\":\"Suhrs Allé\",\"postdistrikt\":\"Farum\"}]", responseMsg);
    }
}
