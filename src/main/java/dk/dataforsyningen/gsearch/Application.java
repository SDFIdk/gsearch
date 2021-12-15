package dk.dataforsyningen.gsearch;

import java.util.AbstractMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import org.jdbi.v3.core.Jdbi;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springdoc.core.customizers.OpenApiCustomiser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.media.ComposedSchema;
import io.swagger.v3.oas.models.media.ObjectSchema;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.media.StringSchema;

@SpringBootApplication
public class Application {

    static Logger logger = LoggerFactory.getLogger(Application.class);

	@Autowired
	private Jdbi jdbi;

	@Autowired
	private ResourceTypes resourceTypes;

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Bean
	public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
		return args -> { };
	}

	ComposedSchema getSchema(String resourceType) {
		ComposedSchema schema = new ComposedSchema();
        ObjectSchema data = new ObjectSchema();
        data.set$ref("#/components/schemas/Data");
        schema.addAllOfItem(data);
		schema.setType("object");
		schema.properties(getProperties(resourceType));
		return schema;
	}

    @Bean
    public OpenAPI customOpenAPI() {
        OpenAPI openApi = new OpenAPI();
        return openApi;
    }

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
            openApi.getComponents().getSchemas().get("Result").getProperties().put("data", data);
			for (String resourceType : resourceTypes.getTypes())
				openApi.getComponents().addSchemas(resourceType, getSchema(resourceType));
		};
	}

    private StringSchema createSchema(String description) {
        StringSchema schema = new StringSchema();
        schema.description(description);
        return schema;
    }

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
                .collect(Collectors.toMap(Entry::getKey, Entry::getValue));
        });
    }

}
