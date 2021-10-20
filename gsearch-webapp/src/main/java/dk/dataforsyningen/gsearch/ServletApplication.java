package dk.dataforsyningen.gsearch;

import javax.ws.rs.ApplicationPath;

import org.glassfish.jersey.server.ResourceConfig;

@ApplicationPath("/rest")
public class ServletApplication extends ResourceConfig {
  public ServletApplication() {
    packages("dk.dataforsyningen.gsearch");
  }
}