package dk.dataforsyningen.gsearch.configuration;

import com.fasterxml.jackson.databind.ObjectMapper;
import dk.dataforsyningen.gsearch.ResourceTypes;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.spi.JdbiPlugin;
import org.n52.jackson.datatype.jts.JtsModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.List;

@Configuration
public class JdbiConfiguration {

    static Logger logger = LoggerFactory.getLogger(JdbiConfiguration.class);

    private ResourceTypes resourceTypes = new ResourceTypes();

    /**
     * The SQL data source that Jdbi will connect to. In this example we use an H2 database, but it can be any JDBC-compatible database.
     * https://jdbi.org/#_spring5
     *
     * @return
     */
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSource driverManagerDataSource() {
        return new DriverManagerDataSource();
    }

    @Bean
    public Jdbi jdbi(DataSource ds, List<JdbiPlugin> jdbiPlugins, List<RowMapper<?>> rowMappers) throws SQLException {
        TransactionAwareDataSourceProxy proxy = new TransactionAwareDataSourceProxy(ds);
        Jdbi jdbi = Jdbi.create(proxy);
        determineTypes(jdbi);
        jdbiPlugins.forEach(plugin -> jdbi.installPlugin(plugin));
        // TODO: Maybe this can be used to only register Row mapper once and not every time the getData gets called
        rowMappers.forEach(mapper -> jdbi.registerRowMapper(mapper));
        new Listener(ds, jdbi, this).start();
        return jdbi;
    }

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        final ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JtsModule());
        return mapper;
    }

    @Bean
    public ResourceTypes resourceTypes() {
        return resourceTypes;
    }

    public void determineTypes(Jdbi jdbi) {
        List<String> types = jdbi.withHandle(handle -> {
            String sql = "select typname from pg_catalog.pg_type t join pg_catalog.pg_namespace pn on (pn.oid = t.typnamespace) join pg_catalog.pg_class pc on (pc.reltype = t.oid) where pn.nspname = 'api' and pc.relkind = 'c'";
            List<String> typnames = handle
                .createQuery(sql)
                .mapTo(String.class)
                .list();
            return typnames;
        });
        logger.info("Retrieved api types from database: {}", String.join(",", types));
        // TODO: mutate with diff
        resourceTypes.getTypes().clear();
        resourceTypes.getTypes().addAll(types);
    }
}
