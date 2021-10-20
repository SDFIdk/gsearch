package dk.dataforsyningen.gsearch;

import javax.ws.rs.ServerErrorException;
import javax.ws.rs.core.Response;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import org.jdbi.v3.core.Jdbi;

public class DatabaseManager {
    private static DatabaseManager instance;

    private final HikariDataSource hikariDataSource;
    private final Jdbi jdbi;

    private DatabaseManager() {
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
    }

    public static DatabaseManager getInstance() {
        return instance;
    }

    public static synchronized void start() throws ServerErrorException {
        if (instance == null) {
            try {
                instance = new DatabaseManager();
            } catch (Exception ex) {
                throw new ServerErrorException(Response.Status.INTERNAL_SERVER_ERROR, ex);
            }
        }
    }

    public static void shutdown() {
        instance.hikariDataSource.close();
    }

    public static Jdbi getJdbi() {
        return instance.jdbi;
    }
}
