package dk.dataforsyningen.gsearch.configuration;

import dk.dataforsyningen.gsearch.Application;
import dk.dataforsyningen.gsearch.ResourceTypes;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.media.ComposedSchema;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.media.StringSchema;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import java.util.AbstractMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springdoc.core.customizers.OpenApiCustomizer;
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

  @Autowired
  private ResourceTypes resourceTypes;

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

  /**
   * Make a dynamic data schema with name and properties (same as the columns name + comments)
   *
   * @param resourceType
   * @return
   */
  ComposedSchema getSchema(String resourceType) {
    ComposedSchema schema = new ComposedSchema();
    schema.properties(getProperties(resourceType));
    return schema;
  }

  /**
   * Enumerate resource types and creates open api schemas from them
   *
   * @return
   */
  @Bean
  public OpenApiCustomizer customerGlobalHeaderOpenApiCustomizer() {
    logger.info("Generating custom OpenAPI");
    return openApi -> {

      // Add all schemas
      for (String resourceType : resourceTypes.getTypes()) {
        openApi.getComponents().addSchemas(resourceType, getSchema(resourceType));
      }
    };
  }

  /**
   * Sorts the schemas alphabetically
   * https://github.com/springdoc/springdoc-openapi/issues/741
   *
   * @return OpenApiCustomizer
   */
  @Bean
  public OpenApiCustomizer sortSchemasAlphabetically() {
    return openApi -> {
      Map<String, Schema> schemas = openApi.getComponents().getSchemas();
      openApi.getComponents().setSchemas(new TreeMap<>(schemas));
    };
  }

  /**
   * Creates Schema with description
   *
   * @param description
   * @return
   */
  private StringSchema createSchema(String description, String datatype) {
    StringSchema schema = new StringSchema();
    schema.description(description);

    // text and geometry gets map to string as default. Springdoc does not support geometry
    // Map postgresql data type integer and numeric to openapi data types
    if (datatype.equals("int4")) {
        schema.type("integer").format("int32");
    }
    else if (datatype.equals("numeric")) {
        schema.type("number").format("double");
    }

    return schema;
  }

  /**
   * Fetch metadata about columns from pg_catalog in the database and transform to StringSchema entity
   *
   * @param typname
   * @return full map of all the StringSchemas
   */
  public Map<String, Schema> getProperties(String typname) {
    return jdbi.withHandle(handle -> {
      String sql = "select attname, pgd.description, pt.typname\n" +
          "from pg_catalog.pg_type t\n" +
          "join pg_catalog.pg_namespace pn on (pn.oid = t.typnamespace)\n" +
          "join pg_catalog.pg_class pc on (pc.reltype = t.oid)\n" +
          "join pg_catalog.pg_attribute pa on (t.typrelid = pa.attrelid)\n" +
          "join pg_catalog.pg_description pgd on (pgd.objoid = pc.oid and pgd.objsubid = pa.attnum)\n" +
          "join pg_catalog.pg_type pt on (pa.atttypid = pt.oid)\n" +
          "where pn.nspname = 'api' and pc.relkind = 'c' and t.typname = :typname;";
      return handle
          .createQuery(sql)
          .bind("typname", typname)
          .map((rs, ctx) ->
              new AbstractMap.SimpleEntry<String, StringSchema>(
                  rs.getString("attname"),
                  createSchema(rs.getString("description"), rs.getString("typname"))))
          .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    });
  }
}
