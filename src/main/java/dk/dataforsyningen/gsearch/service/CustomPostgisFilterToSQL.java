package dk.dataforsyningen.gsearch.service;

import org.geotools.api.filter.expression.Literal;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.data.postgis.PostgisFilterToSQL;

/**
 * Custom GeoTools PostgisFilterToSQL to avoid coercing string literals to numbers
 * NOTE: This is needed because GeoTools is not aware of the schemas and will
 * make filtering on text columns possible but not numeric ones
 */
public class CustomPostgisFilterToSQL extends PostgisFilterToSQL {

  public CustomPostgisFilterToSQL(PostGISDialect dialect) {
    super(dialect);
  }

  /**
   * Taking care of instances where user request fx. filer=kommunekode IN ('0561')
   * This method makes sure that '0561' remains as a string, and not converted to integer where the
   * leading 0 is removed.
   * <p>
   * If '0561' was converted to an interger, then textsearchable columns fails, because they
   * only can use strings for its searches.
   *
   * @param expression
   * @param target
   * @return
   */
  public Object evaluateLiteral(Literal expression, Class<?> target) {
    Object literal = null;

    // if the target was not known, of the conversion failed, try the
    // type guessing dance literal expression does only for the following
    // method call
    if (literal == null) {
      literal = expression.evaluate(null);
    }

    // if that failed as well, grab the value as is
    if (literal == null) {
      literal = expression.getValue();
    }

    return literal;
  }
}
