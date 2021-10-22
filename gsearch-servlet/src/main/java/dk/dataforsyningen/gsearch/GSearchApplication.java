package dk.dataforsyningen.gsearch;

import javax.ws.rs.ApplicationPath;

import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.ServerProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.swagger.v3.jaxrs2.integration.resources.AcceptHeaderOpenApiResource;
import io.swagger.v3.jaxrs2.integration.resources.OpenApiResource;

@ApplicationPath("/")
public class GSearchApplication extends ResourceConfig {
  static Logger logger = LoggerFactory.getLogger(GSearchApplication.class);

  public GSearchApplication() {
    logger.debug("constructor called");
    packages("dk.dataforsyningen.gsearch");
    register(JacksonFeature.class);
    register(OpenApiResource.class);
    register(AcceptHeaderOpenApiResource.class);
    property(ServerProperties.WADL_FEATURE_DISABLE, true);
  }
}