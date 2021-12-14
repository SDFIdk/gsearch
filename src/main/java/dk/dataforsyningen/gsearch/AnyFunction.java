package dk.dataforsyningen.gsearch;

import static org.geotools.filter.capability.FunctionNameImpl.parameter;

import java.util.List;

import org.geotools.filter.FunctionExpressionImpl;
import org.geotools.filter.capability.FunctionNameImpl;
import org.opengis.filter.capability.FunctionName;
import org.opengis.filter.expression.Expression;

public class AnyFunction extends FunctionExpressionImpl {

    public static final FunctionName NAME =
            new FunctionNameImpl("any", Boolean.class, parameter("values", Object.class, 1, -1));

    public AnyFunction(List<Expression> args) {
        super(NAME);
        setParameters(args);
    }

    public static boolean isAnyFunction(Expression expression) {
        return expression instanceof AnyFunction;
    }

    @Override
    public Object evaluate(Object feature) {
        for (Expression expression : getParameters())
            if (Boolean.TRUE.equals(expression.evaluate(feature)))
                return Boolean.TRUE;
        return Boolean.FALSE;
    }
}