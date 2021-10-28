package dk.dataforsyningen.gsearch;

import static org.junit.jupiter.api.Assertions.assertTrue;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import org.junit.jupiter.api.Test;

/*public class HelloMockTest {
    @Test
    public void testMock() {
        System.setProperty("karate.env", "mock");
        Results results = Runner.path("classpath:dk/dataforsyningen/gsearch")
                .systemProperty("karate.env", "mock")
                .clientFactory(new MockSpringMvcServlet())
                .parallel(1);
        assertTrue(results.getFailCount() == 0, "there are scenario failures");
    }
}*/