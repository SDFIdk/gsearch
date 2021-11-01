package dk.dataforsyningen.gsearch;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

/**
 * Maps dynamic row data into the generic Data entity
 */
class DataMapper implements RowMapper<Data> {
    private final GSearchController gSearchController;
    ResultSetMetaData meta;
    String resource;

    public DataMapper(GSearchController gSearchController, String resource) {
        this.gSearchController = gSearchController;
        this.resource = resource;
    }

    private Object mapColumn(int i, ResultSet rs) throws SQLException {
        if (meta.getColumnTypeName(i).equals("geometry")) {
            // TODO: find out how to parse binary directly
            //byte[] bytes = rs.getBytes(i);
            //Geometry geometry = binaryParser.parse(bytes);
            String hex = rs.getString(i);
            Geometry geometry = this.gSearchController.binaryParser.parse(hex);
            return geometry;
        } else {
            return rs.getString(i);
        }
    }

    @Override
    public Data map(ResultSet rs, StatementContext ctx) throws SQLException {
        Data data = new Data();
        data.type = resource;
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    @Override
    public DataMapper specialize(ResultSet rs, StatementContext ctx) throws SQLException {
        meta = rs.getMetaData();
        return this;
    }
}