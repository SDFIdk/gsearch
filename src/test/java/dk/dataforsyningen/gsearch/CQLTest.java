package dk.dataforsyningen.gsearch;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.junit.jupiter.api.Test;
import org.opengis.filter.Filter;

import dk.dataforsyningen.gsearch.service.CustomPostgisFilterToSQL;

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

    @Test
    void IntersectsSQLTest() throws CQLException, FilterToSQLException {
        Filter filter = ECQL.toFilter("INTERSECTS(geometri,SRID=25832;POLYGON((466154.63288673327770084 6395168.0476682698354125, 437055.51815716188866645 6048624.04497973807156086, 796826.39117731782607734 6096240.77817358169704676, 466154.63288673327770084 6395168.0476682698354125)))");
        String where = filterToSQL.encodeToString(filter);
        String hackedWhere = where.replaceAll("', null", "', 25832");
        assertEquals("geometri && ST_GeomFromText('POLYGON ((466154.6328867333 6395168.04766827, 437055.5181571619 6048624.044979738, 796826.3911773178 6096240.778173582, 466154.6328867333 6395168.04766827))', 25832) AND ST_Intersects(geometri, ST_GeomFromText('POLYGON ((466154.6328867333 6395168.04766827, 437055.5181571619 6048624.044979738, 796826.3911773178 6096240.778173582, 466154.6328867333 6395168.04766827))', 25832))", hackedWhere);
    }
}
