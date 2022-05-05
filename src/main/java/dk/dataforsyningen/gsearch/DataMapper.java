package dk.dataforsyningen.gsearch;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

import net.postgis.jdbc.jts.JtsBinaryParser;

/**
 * Maps dynamic row data into the generic Data entity
 */
class DataMapper implements RowMapper<Data> {
    JtsBinaryParser binaryParser = new JtsBinaryParser();
    ResultSetMetaData meta;
    String resource;

    public DataMapper(String resource) {
        this.resource = resource;
    }

    /**
     * Maps column value to either geometry or String
     * @param i
     * @param rs
     * @return
     * @throws SQLException
     */
    private Object mapColumn(int i, ResultSet rs) throws SQLException {
        if (meta.getColumnTypeName(i).equals("geometry")) {
            // TODO: find out how to parse binary directly
            //byte[] bytes = rs.getBytes(i);
            //Geometry geometry = binaryParser.parse(bytes);
            String hex = rs.getString(i);
            Geometry geometry = this.binaryParser.parse(hex);
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

    /**
     * Get metadata to know what column type we have
     * @param rs
     * @param ctx
     * @return
     * @throws SQLException
     */
    @Override
    public DataMapper specialize(ResultSet rs, StatementContext ctx) throws SQLException {
        meta = rs.getMetaData();
        return this;
    }
}