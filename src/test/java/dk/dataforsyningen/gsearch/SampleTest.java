package dk.dataforsyningen.gsearch;

import com.intuit.karate.junit5.Karate;

class SampleTest {

    @Karate.Test
    Karate testSample() {
        return Karate.run("geosearch").relativeTo(getClass());
    }

}