package dk.dataforsyningen.gsearch;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;

import org.glassfish.grizzly.http.server.HttpServer;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

import java.util.List;

public class HelloWorldTest {

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
    public void testGetIt() {
        String responseMsg = target.path("helloworld").request().get(String.class);
        assertEquals("Hello world!", responseMsg);
    }

    @Test
    public void testDemo() {
        List<DemoResult> results = target.path("demo").request().get(new GenericType<List<DemoResult>>() {});
        assertEquals(2, results.size());
        assertEquals("Brudedalen", results.get(0).vejnavn);
    }
}
