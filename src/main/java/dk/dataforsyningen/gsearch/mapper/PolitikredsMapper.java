package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Politikreds;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class PolitikredsMapper implements RowMapper<Politikreds> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public PolitikredsMapper() {
  }

  @Override
  public Politikreds map(ResultSet rs, StatementContext ctx) throws SQLException {
    Politikreds data = new Politikreds();

    data.setPolitikredsnummer(Integer.valueOf(rs.getString("politikredsnummer")));
    data.setNavn(rs.getString("navn"));
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

