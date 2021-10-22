package dk.dataforsyningen.gsearch;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Data {
    @JsonProperty
    String type;

    private Map<String, String> properties = new HashMap<String, String>();

    @JsonAnyGetter
    public Map<String, String> getProperties() {
        return properties;
    }
    @JsonAnySetter
    public void add(String property, String value) {
        properties.put(property, value);
    }
}
