package dk.dataforsyningen.gsearch;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataSourceConfiguration {

    static Logger logger = LoggerFactory.getLogger(DataSourceConfiguration.class);

    @Bean
    @ConfigurationProperties("app.datasource")
    public DataSource getDataSource() {
        logger.debug("getDataSource called");
        DataSourceBuilder<?> dataSourceBuilder = DataSourceBuilder.create();
        return dataSourceBuilder.build();
    }
}