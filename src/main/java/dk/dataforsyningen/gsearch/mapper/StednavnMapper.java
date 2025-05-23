package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Stednavn;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class StednavnMapper implements RowMapper<Stednavn> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public StednavnMapper() {
  }

  @Override
  public Stednavn map(ResultSet rs, StatementContext ctx) throws SQLException {
    Stednavn data = new Stednavn();

    data.setId(UUID.fromString(rs.getString("id")));
    data.setSkrivemaade(rs.getString("skrivemaade"));
    data.setVisningstekst(rs.getString("visningstekst"));
    data.setSkrivemaade_officiel(rs.getString("skrivemaade_officiel"));
    data.setSkrivemaade_uofficiel(rs.getString("skrivemaade_uofficiel"));
    data.setStednavn_type(rs.getString("stednavn_type"));
    data.setStednavn_subtype(rs.getString("stednavn_subtype"));
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

