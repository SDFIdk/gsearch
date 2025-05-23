package dk.dataforsyningen.gsearch.configuration;

import dk.dataforsyningen.gsearch.Application;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {
  static Logger logger = LoggerFactory.getLogger(Application.class);
  final String securitySchemeNameQuery = "QueryToken";
  final String securitySchemeNameHeader = "HeaderToken";
  @Autowired
  private Jdbi jdbi;

  /**
   * @return OpenAPI custom object
   */
  @Bean
  public OpenAPI customImplementation() {
    return new OpenAPI()
        .info(new Info()
            .title("Gsearch")
            .version("2.0.0"))
        // AddSecurityItem section applies created scheme/paths globally
        .addSecurityItem(new SecurityRequirement().addList(securitySchemeNameHeader))
        .addSecurityItem(new SecurityRequirement().addList(securitySchemeNameQuery))
        // Components section defines Security Scheme
        .components(new Components()
            .addSecuritySchemes(securitySchemeNameHeader, new SecurityScheme()
                .type(SecurityScheme.Type.APIKEY)
                .in(SecurityScheme.In.HEADER)
                .name("token"))
            .addSecuritySchemes(securitySchemeNameQuery, new SecurityScheme()
                .type(SecurityScheme.Type.APIKEY)
                .in(SecurityScheme.In.QUERY)
                .name("token")));
  }
}
