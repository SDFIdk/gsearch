package dk.dataforsyningen.gsearch.configuration;

import dk.dataforsyningen.gsearch.Application;
import dk.dataforsyningen.gsearch.ResourceTypes;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.media.ComposedSchema;
import io.swagger.v3.oas.models.media.ObjectSchema;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.media.StringSchema;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import java.util.AbstractMap;
import java.util.Map;
import java.util.stream.Collectors;
import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springdoc.core.customizers.OpenApiCustomiser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {
  final String securitySchemeNameQuery = "QueryToken";
  final String securitySchemeNameHeader = "HeaderToken";

    static Logger logger = LoggerFactory.getLogger(Application.class);

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
            .version("1.0.0")
            .description("""
                APIet __Gsearch__ er velegnet til implementering af typeahead fritekstsøgninger på websites.

                Gsearch understøtter fritekstsøgninger, type-ahead, fonetisk genkendelse af stavemåder, samt søgning i Danmarks adresser og vejnavne, Danmarks administrative geografiske enheder (DAGI), Danske Stednavne og Matriklen.
                """))
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
        ObjectSchema data = new ObjectSchema();
        data.set$ref("#/components/schemas/Data");
        schema.addAllOfItem(data);
        schema.setType("object");
        schema.properties(getProperties(resourceType));
        return schema;
    }

    /**
     * Enumerate resource types and creates open api schemas from them
     *
     * @return
     */
    @Bean
    public OpenApiCustomiser customerGlobalHeaderOpenApiCustomiser() {
        logger.info("Generating custom OpenAPI");
        return openApi -> {
            ComposedSchema data = new ComposedSchema();
            for (String resourceType : resourceTypes.getTypes()) {
                ObjectSchema ref = new ObjectSchema();
                ref.set$ref("#/components/schemas/" + resourceType);
                data.addAnyOfItem(ref);
            }
            openApi.getComponents().getSchemas().get("Data").getProperties().put("data", data);
            for (String resourceType : resourceTypes.getTypes())
                openApi.getComponents().addSchemas(resourceType, getSchema(resourceType));
        };
    }

    /**
     * Creates Schema with description
     *
     * @param description
     * @return
     */
    private StringSchema createSchema(String description) {
        StringSchema schema = new StringSchema();
        schema.description(description);
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
            String sql = "select attname, pgd.description\n" +
                "from pg_catalog.pg_type t\n" +
                "join pg_catalog.pg_namespace pn on (pn.oid = t.typnamespace)\n" +
                "join pg_catalog.pg_class pc on (pc.reltype = t.oid)\n" +
                "join pg_catalog.pg_attribute pa on (t.typrelid = pa.attrelid)\n" +
                "join pg_catalog.pg_description pgd on (pgd.objoid = pc.oid and pgd.objsubid = pa.attnum)\n" +
                "where pn.nspname = 'api' and pc.relkind = 'c' and t.typname = :typname;";
            return handle
                .createQuery(sql)
                .bind("typname", typname)
                .map((rs, ctx) ->
                    new AbstractMap.SimpleEntry<String, StringSchema>(
                        rs.getString("attname"),
                        createSchema(rs.getString("description"))))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        });
    }
}
