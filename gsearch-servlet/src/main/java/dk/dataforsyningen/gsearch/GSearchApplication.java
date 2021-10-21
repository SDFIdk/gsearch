package dk.dataforsyningen.gsearch;

import javax.ws.rs.ApplicationPath;

import org.glassfish.jersey.moxy.json.MoxyJsonFeature;
import org.glassfish.jersey.server.ResourceConfig;

import io.swagger.v3.jaxrs2.integration.resources.AcceptHeaderOpenApiResource;
import io.swagger.v3.jaxrs2.integration.resources.OpenApiResource;

@ApplicationPath("/")
public class GSearchApplication extends ResourceConfig {
  public GSearchApplication() {
    packages("dk.dataforsyningen.gsearch");
    register(MoxyJsonFeature.class);
    register(OpenApiResource.class);
    register(AcceptHeaderOpenApiResource.class);
  }
}