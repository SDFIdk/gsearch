package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Kommune;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class KommuneMapper implements RowMapper<Kommune> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public KommuneMapper() {
  }

  @Override
  public Kommune map(ResultSet rs, StatementContext ctx) throws SQLException {
    Kommune data = new Kommune();

    data.setKommunenavn(rs.getString("kommunenavn"));
    data.setKommunekode(rs.getString("kommunekode"));
    data.setVisningstekst(rs.getString("visningstekst"));

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

