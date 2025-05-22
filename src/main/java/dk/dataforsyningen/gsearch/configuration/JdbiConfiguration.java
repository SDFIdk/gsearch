package dk.dataforsyningen.gsearch.configuration;

import com.fasterxml.jackson.databind.ObjectMapper;
import dk.dataforsyningen.gsearch.mapper.AdresseMapper;
import dk.dataforsyningen.gsearch.mapper.HusnummerMapper;
import dk.dataforsyningen.gsearch.mapper.KommuneMapper;
import dk.dataforsyningen.gsearch.mapper.MatrikelMapper;
import dk.dataforsyningen.gsearch.mapper.MatrikelUdgaaetMapper;
import dk.dataforsyningen.gsearch.mapper.NavngivenvejMapper;
import dk.dataforsyningen.gsearch.mapper.OpstillingskredsMapper;
import dk.dataforsyningen.gsearch.mapper.PolitikredsMapper;
import dk.dataforsyningen.gsearch.mapper.PostnummerMapper;
import dk.dataforsyningen.gsearch.mapper.RegionMapper;
import dk.dataforsyningen.gsearch.mapper.RetskredsMapper;
import dk.dataforsyningen.gsearch.mapper.SognMapper;
import dk.dataforsyningen.gsearch.mapper.StednavnMapper;
import javax.sql.DataSource;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.SqlStatements;
import org.jdbi.v3.jackson2.Jackson2Plugin;
import org.jdbi.v3.postgis.PostgisPlugin;
import org.jdbi.v3.postgres.PostgresPlugin;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;
import org.n52.jackson.datatype.jts.JtsModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy;

@Configuration
public class JdbiConfiguration {

  static Logger logger = LoggerFactory.getLogger(JdbiConfiguration.class);

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
  public Jdbi jdbi(DataSource ds) {
    TransactionAwareDataSourceProxy proxy = new TransactionAwareDataSourceProxy(ds);
    Jdbi jdbi = Jdbi.create(proxy)
        .installPlugin(new SqlObjectPlugin())
        .installPlugin(new PostgresPlugin())
        .installPlugin(new PostgisPlugin())
        .installPlugin(new Jackson2Plugin());

    jdbi.registerRowMapper(new AdresseMapper());
    jdbi.registerRowMapper(new HusnummerMapper());
    jdbi.registerRowMapper(new KommuneMapper());
    jdbi.registerRowMapper(new MatrikelMapper());
    jdbi.registerRowMapper(new MatrikelUdgaaetMapper());
    jdbi.registerRowMapper(new NavngivenvejMapper());
    jdbi.registerRowMapper(new OpstillingskredsMapper());
    jdbi.registerRowMapper(new PolitikredsMapper());
    jdbi.registerRowMapper(new PostnummerMapper());
    jdbi.registerRowMapper(new RegionMapper());
    jdbi.registerRowMapper(new RetskredsMapper());
    jdbi.registerRowMapper(new SognMapper());
    jdbi.registerRowMapper(new StednavnMapper());

    // This cancels the sql statement so the database don't use unnecessary ressources on requests
    // taking to long.
    // Gravitee timeout is 10 seconds, and it sends the correct 504 timeout http code.
    // In the code we set it to 11 seconds because it triggers the UnableToExecuteStatementException,
    // that returns a 400 http code (bad request), but in this case it should have been a 504 timeout.
    // So the 11 seconds is for always be later than Gravitee, but still cancels the ongoing statement
    // from being executed longer
    jdbi.getConfig(SqlStatements.class).setQueryTimeout(11);
    return jdbi;
  }


  /**
   * Makes it possible for Jackson to deserialize Geometry so it can be returned in json response
   *
   * @return
   */
  @Bean
  @Primary
  public ObjectMapper objectMapper() {
    final ObjectMapper mapper = new ObjectMapper();
    mapper.registerModule(new JtsModule());
    return mapper;
  }
}
