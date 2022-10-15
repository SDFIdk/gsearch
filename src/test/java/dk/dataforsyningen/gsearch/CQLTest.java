package dk.dataforsyningen.gsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.junit.jupiter.api.Test;
import org.opengis.filter.Filter;

import dk.dataforsyningen.gsearch.rest.CustomPostgisFilterToSQL;

public class CQLTest {
    static FilterToSQL filterToSQL;

    static {
        PostGISDialect dialect = new PostGISDialect(null);
        dialect.setFunctionEncodingEnabled(true);
        filterToSQL = new CustomPostgisFilterToSQL(dialect);
        filterToSQL.setInline(true);
    }

    @Test
    void BasicCQLTest() throws CQLException, FilterToSQLException {
        Filter filter = ECQL.toFilter("a = 1");
        String where = filterToSQL.encodeToString(filter);
        assertEquals("a = 1", where);
    }

    @Test
    void ArrayCQLTest() throws CQLException, FilterToSQLException {
        String where = filterToSQL.encodeToString(ECQL.toFilter("a in (1,2)"));
        assertEquals("a IN (1, 2)", where);
    }

    @Test
    void TextCQLTest() throws CQLException, FilterToSQLException {
        Filter filter = ECQL.toFilter("a = '0101'");
        String where = filterToSQL.encodeToString(filter);
        assertEquals("a = '0101'", where);
    }
}
