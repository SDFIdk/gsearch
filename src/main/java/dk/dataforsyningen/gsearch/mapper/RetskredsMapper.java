package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Retskreds;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class RetskredsMapper implements RowMapper<Retskreds> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public RetskredsMapper() {
  }

  @Override
  public Retskreds map(ResultSet rs, StatementContext ctx) throws SQLException {
    Retskreds data = new Retskreds();

    data.setRetskredsnummer(Integer.valueOf(rs.getString("retskredsnummer")));
    data.setRetkredsnavn(rs.getString("retkredsnavn"));
    data.setVisningstekst(rs.getString("visningstekst"));
    data.setMyndighedskode(rs.getString("myndighedskode"));
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

