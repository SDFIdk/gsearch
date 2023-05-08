package dk.dataforsyningen.gsearch.rest;

import dk.dataforsyningen.gsearch.datamodel.ResourceType;
import dk.dataforsyningen.gsearch.datamodel.adresse;
import dk.dataforsyningen.gsearch.datamodel.husnummer;
import dk.dataforsyningen.gsearch.datamodel.kommune;
import dk.dataforsyningen.gsearch.datamodel.matrikel;
import dk.dataforsyningen.gsearch.datamodel.matrikel_udgaaet;
import dk.dataforsyningen.gsearch.datamodel.navngivenvej;
import dk.dataforsyningen.gsearch.datamodel.opstillingskreds;
import dk.dataforsyningen.gsearch.datamodel.politikreds;
import dk.dataforsyningen.gsearch.datamodel.postnummer;
import dk.dataforsyningen.gsearch.datamodel.region;
import dk.dataforsyningen.gsearch.datamodel.retskreds;
import dk.dataforsyningen.gsearch.datamodel.sogn;
import dk.dataforsyningen.gsearch.datamodel.stednavn;
import net.postgis.jdbc.jts.JtsBinaryParser;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/**
 * Maps dynamic row data into the generic Data entity
 */
class DataMapper implements RowMapper<Object> {
    JtsBinaryParser binaryParser = new JtsBinaryParser();
    ResultSetMetaData meta;
    String resource;

    public DataMapper(String resource) {
        this.resource = resource;
    }

    /**
     * Maps column value to either geometry or String
     *
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
    public Object map(ResultSet rs, StatementContext ctx) throws SQLException {
        if (resource.equals(ResourceType.ADRESSE.toString())) {
            return mapAdresse(rs, ctx);
        }
        if (resource.equals(ResourceType.HUSNUMMER.toString())) {
            return mapHusnummer(rs, ctx);
        }
        if (resource.equals(ResourceType.KOMMUNE.toString())) {
            return mapKommune(rs, ctx);
        }
        if (resource.equals(ResourceType.MATRIKEL.toString())) {
            return mapMatrikel(rs, ctx);
        }
        if (resource.equals(ResourceType.MATRIKEL_UDGAAET.toString())) {
            return mapMatrikelUdgaaet(rs, ctx);
        }
        if (resource.equals(ResourceType.NAVNGIVENVEJ.toString())) {
            return mapNavngivenvej(rs, ctx);
        }
        if (resource.equals(ResourceType.OPSTILLINGSKREDS.toString())) {
            return mapOpstillingskreds(rs, ctx);
        }
        if (resource.equals(ResourceType.POLITIKREDS.toString())) {
            return mapPolitikreds(rs, ctx);
        }
        if (resource.equals(ResourceType.POSTNUMMER.toString())) {
            return mapPostnummer(rs, ctx);
        }
        if (resource.equals(ResourceType.REGION.toString())) {
            return mapRegion(rs, ctx);
        }
        if (resource.equals(ResourceType.RETSKREDS.toString())) {
            return mapRetskreds(rs, ctx);
        }
        if (resource.equals(ResourceType.SOGN.toString())) {
            return mapSogn(rs, ctx);
        }
        if (resource.equals(ResourceType.STEDNAVN.toString())) {
            return mapStednavn(rs, ctx);
        }
        throw new IllegalStateException("Could not resolve mapping strategy for object");
    }

    private adresse mapAdresse(ResultSet rs, StatementContext ctx) throws SQLException {
        adresse data = new adresse();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private husnummer mapHusnummer(ResultSet rs, StatementContext ctx) throws SQLException {
        husnummer data = new husnummer();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private kommune mapKommune(ResultSet rs, StatementContext ctx) throws SQLException {
        kommune data = new kommune();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private matrikel mapMatrikel(ResultSet rs, StatementContext ctx) throws SQLException {
        matrikel data = new matrikel();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private matrikel_udgaaet mapMatrikelUdgaaet(ResultSet rs, StatementContext ctx) throws SQLException {
        matrikel_udgaaet data = new matrikel_udgaaet();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private navngivenvej mapNavngivenvej(ResultSet rs, StatementContext ctx) throws SQLException {
        navngivenvej data = new navngivenvej();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private opstillingskreds mapOpstillingskreds(ResultSet rs, StatementContext ctx) throws SQLException {
        opstillingskreds data = new opstillingskreds();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private politikreds mapPolitikreds(ResultSet rs, StatementContext ctx) throws SQLException {
        politikreds data = new politikreds();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private postnummer mapPostnummer(ResultSet rs, StatementContext ctx) throws SQLException {
        postnummer data = new postnummer();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private region mapRegion(ResultSet rs, StatementContext ctx) throws SQLException {
        region data = new region();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private retskreds mapRetskreds(ResultSet rs, StatementContext ctx) throws SQLException {
        retskreds data = new retskreds();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private sogn mapSogn(ResultSet rs, StatementContext ctx) throws SQLException {
        sogn data = new sogn();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    private stednavn mapStednavn(ResultSet rs, StatementContext ctx) throws SQLException {
        stednavn data = new stednavn();
        for (int i = 1; i <= meta.getColumnCount(); i++)
            data.add(meta.getColumnName(i), mapColumn(i, rs));
        return data;
    }

    /**
     * Get metadata to know what column type we have
     *
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
