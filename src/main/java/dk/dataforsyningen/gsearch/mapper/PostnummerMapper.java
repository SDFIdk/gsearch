package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Postnummer;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class PostnummerMapper implements RowMapper<Postnummer> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public PostnummerMapper() {
  }

  @Override
  public Postnummer map(ResultSet rs, StatementContext ctx) throws SQLException {
    Postnummer data = new Postnummer();

    data.setPostnummer(rs.getString("postnummer"));
    data.setPostnummernavn(rs.getString("postnummernavn"));
    data.setVisningstekst(rs.getString("visningstekst"));
    data.setGadepostnummer(rs.getObject("gadepostnummer", Boolean.class));
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

