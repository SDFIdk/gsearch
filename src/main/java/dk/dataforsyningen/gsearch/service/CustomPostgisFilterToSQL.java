package dk.dataforsyningen.gsearch.service;

import org.geotools.data.postgis.PostGISDialect;
import org.geotools.data.postgis.PostgisFilterToSQL;
import org.opengis.filter.expression.Literal;

/**
 * Custom GeoTools PostgisFilterToSQL to avoid coercing string literals to numbers
 * NOTE: This is needed because GeoTools is not aware of the schema and will
 * will make filtering on text columns possible but not numeric ones
 */
public class CustomPostgisFilterToSQL extends PostgisFilterToSQL {

    public CustomPostgisFilterToSQL(PostGISDialect dialect) {
        super(dialect);
    }

    public Object evaluateLiteral(Literal expression, Class<?> target) {
        Object literal = null;

        // if the target was not known, of the conversion failed, try the
        // type guessing dance literal expression does only for the following
        // method call
        if (literal == null) literal = expression.evaluate(null);

        // if that failed as well, grab the value as is
        if (literal == null) literal = expression.getValue();

        return literal;
    }
}
