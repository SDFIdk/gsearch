package dk.dataforsyningen.gsearch.datamodel;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import java.util.HashMap;
import java.util.Map;

public class retskreds {

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
