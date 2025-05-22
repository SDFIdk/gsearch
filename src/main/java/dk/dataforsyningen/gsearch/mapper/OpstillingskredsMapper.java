package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Opstillingskreds;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class OpstillingskredsMapper implements RowMapper<Opstillingskreds> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public OpstillingskredsMapper() {
  }

  @Override
  public Opstillingskreds map(ResultSet rs, StatementContext ctx) throws SQLException {
    Opstillingskreds data = new Opstillingskreds();

    data.setOpstillingskredsnummer(Integer.valueOf(rs.getString("opstillingskredsnummer")));
    data.setOpstillingskredsnavn(rs.getString("opstillingskredsnavn"));
    data.setVisningstekst(rs.getString("visningstekst"));
    data.setValgkredsnummer(Integer.valueOf(rs.getString("valgkredsnummer")));
    data.setStorkredsnummer(Integer.valueOf(rs.getString("storkredsnummer")));
    data.setStorkredsnavn(rs.getString("storkredsnavn"));
    data.setKommunekode(rs.getString("kommunekode"));

    String geometriString = rs.getString("geometri");
    byte[] geometriBytes = mapGeometryHelper.hexStringToByteArray(geometriString);
    Geometry geometri = mapGeometryHelper.deserialize(geometriBytes);
    data.setGeometri(geometri);

    String bboxString = rs.getString("bbox");
    byte[] bboxBytes = mapGeometryHelper.hexStringToByteArray(bboxString);
    Geometry bbox = mapGeometryHelper.deserialize(bboxBytes);
    data.setBbox(bbox);

    return data;
  }
}

