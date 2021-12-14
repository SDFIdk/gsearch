package dk.dataforsyningen.gsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.IOException;

import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.junit.jupiter.api.Test;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory;

public class CQLTest {
    static FilterToSQL filterToSQL;

    static {
        PostGISDialect dialect = new PostGISDialect(null);
        dialect.setFunctionEncodingEnabled(true);
        filterToSQL = new CustomFilterToSQL(dialect);
    }

    @Test
    void BasicCQLTest() throws CQLException, FilterToSQLException {
        String where = filterToSQL.encodeToString(ECQL.toFilter("a=1"));
        assertEquals("WHERE a = 1", where);
    }

    @Test
    void ArrayCQLTest() throws CQLException, FilterToSQLException {
        String where = filterToSQL.encodeToString(ECQL.toFilter("a in (1,2)"));
        assertEquals("WHERE a IN (1, 2)", where);
    }

    @Test
    void Array2CQLTest() throws CQLException, FilterToSQLException, IOException {
        FilterFactory filterFactory = CommonFactoryFinder.getFilterFactory();
        Filter filter = ECQL.toFilter("a=any(1,2)", filterFactory);
        String where = filterToSQL.encodeToString(filter);
        assertEquals("WHERE a = ANY (1, 2)", where);
    }
}
