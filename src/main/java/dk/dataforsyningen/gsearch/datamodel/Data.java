package dk.dataforsyningen.gsearch.datamodel;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;

/**
 * Represents a dynamic object of properties that can be serialized into JSON
 */
public class Data {
  @JsonProperty
  private String type;

  @JsonGetter
  public String getType() {
    return type;
  }

  @JsonSetter
  public void setType(String type) {
    this.type = type;
  }
}
