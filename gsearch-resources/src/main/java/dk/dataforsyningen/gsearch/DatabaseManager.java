package dk.dataforsyningen.gsearch;

import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.ws.rs.ServerErrorException;
import javax.ws.rs.core.Response;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Slf4JSqlLogger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatabaseManager {
    static Logger logger = LoggerFactory.getLogger(DatabaseManager.class);

    private static DatabaseManager instance;

    private final HikariDataSource hikariDataSource;
    private final Jdbi jdbi;

    private Set<String> types = ConcurrentHashMap.newKeySet();

    private DatabaseManager() {
        logger.debug("constructor called");

        // TODO: get data source via JNDI?
        //HikariDataSource hikariDataSource = (HikariDataSource) new InitialContext().lookup("java:comp/env/jdbc/hikariDataSource");
        HikariDataSource hikariDataSource = null;
        if (hikariDataSource == null) {
            String PGUSER = System.getenv("PGUSER");
            if (PGUSER == null || PGUSER.isEmpty())
                PGUSER = "postgres";
            String PGPASSWORD = System.getenv("PGPASSWORD");
            if (PGPASSWORD == null || PGPASSWORD.isEmpty())
                PGPASSWORD = "postgres";
            String PGDATABASE = System.getenv("PGDATABASE");
            if (PGDATABASE == null || PGDATABASE.isEmpty())
                PGDATABASE = "postgres";
            String PGHOST = System.getenv("PGHOST");
            if (PGHOST == null || PGHOST.isEmpty())
                PGHOST = "localhost";
            String PGPORT = System.getenv("PGPORT");
            if (PGPORT == null || PGPORT.isEmpty())
                PGPORT = "5432";
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:postgresql://" + PGHOST + ":" + PGPORT + "/" + PGDATABASE);
            config.setUsername(PGUSER);
            config.setPassword(PGPASSWORD);
            hikariDataSource = new HikariDataSource(config);
        }

        this.hikariDataSource = hikariDataSource;
        this.jdbi = Jdbi.create(hikariDataSource);
        if (logger.isDebugEnabled())
            this.jdbi.setSqlLogger(new Slf4JSqlLogger());
    }

    public static DatabaseManager getInstance() {
        return instance;
    }

    public Set<String> getTypes() {
        return types;
    }

    private static void determineTypes() {
        List<String> types = instance.jdbi.withHandle(handle -> {
            String sql = "select typname from pg_catalog.pg_type t join pg_catalog.pg_namespace pn on (pn.oid = t.typnamespace) join pg_catalog.pg_class pc on (pc.reltype = t.oid) where pn.nspname = 'api' and pc.relkind = 'c'";
            List<String> typnames = handle
                .createQuery(sql)
                .mapTo(String.class)
                .list();
            return typnames;
        });
        logger.info("Retrieved api types from database: {}", String.join(",", types));
        // TODO: mutate with diff
        instance.types.addAll(types);
    }

    public static synchronized void start() throws ServerErrorException {
        if (instance == null) {
            logger.debug("called first time will create singleton instance");
            try {
                instance = new DatabaseManager();
                determineTypes();
                // TODO: setup notify listener for types
            } catch (Exception ex) {
                throw new ServerErrorException(Response.Status.INTERNAL_SERVER_ERROR, ex);
            }
        }
    }

    public static void shutdown() {
        logger.debug("shutdown called");
        instance.hikariDataSource.close();
    }

    public static Jdbi getJdbi() {
        return instance.jdbi;
    }
}
