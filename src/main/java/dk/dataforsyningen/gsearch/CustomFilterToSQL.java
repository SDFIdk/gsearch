package dk.dataforsyningen.gsearch;

import java.io.IOException;
import java.util.List;

import org.geotools.data.postgis.PostGISDialect;
import org.geotools.data.postgis.PostgisFilterToSQL;
import org.opengis.filter.expression.Expression;
import org.opengis.filter.expression.Function;

public class CustomFilterToSQL extends PostgisFilterToSQL {

    public CustomFilterToSQL(PostGISDialect dialect) {
        super(dialect);
    }

    @Override
    public Object visit(Function function, Object extraData) throws RuntimeException {
        if (inEncodingEnabled && AnyFunction.isAnyFunction(function)) {
            visitAnyFunction(function, true, false, extraData);
        } else {
            super.visit(function, extraData);
        }
        return extraData;
    }

    protected void visitAnyFunction(
            Function function, boolean encodeAsExpression, boolean negate, Object extraData) {
        try {
            List<Expression> parameters = function.getParameters();
            out.write("ANY (");
            int size = parameters.size();
            for (int i = 0; i < size; i++) {
                Expression e = function.getParameters().get(i);
                e.accept(this, null);
                if (i < size - 1)
                    out.write(", ");
            }
            out.write(")");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
