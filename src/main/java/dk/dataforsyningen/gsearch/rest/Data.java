package dk.dataforsyningen.gsearch;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;
import java.util.Map;

/**
 * Represents a dynamic object of properties that can be serialized into JSON
 */
public class Data {
    @JsonProperty
    String type;

    private Map<String, Object> properties = new HashMap<String, Object>();

    @JsonAnyGetter
    public Map<String, Object> getProperties() {
        return properties;
    }

    @JsonAnySetter
    public void add(String property, Object value) {
        properties.put(property, value);
    }
}
