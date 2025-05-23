package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Navngivenvej;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class NavngivenvejMapper implements RowMapper<Navngivenvej> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public NavngivenvejMapper() {
  }

  @Override
  public Navngivenvej map(ResultSet rs, StatementContext ctx) throws SQLException {
    Navngivenvej data = new Navngivenvej();

    data.setId(UUID.fromString(rs.getString("id")));
    data.setVejnavn(rs.getString("vejnavn"));
    data.setSupplerendebynavn(rs.getString("supplerendebynavn"));
    data.setVisningstekst(rs.getString("visningstekst"));
    data.setPostnummer(rs.getString("postnummer"));
    data.setPostnummernavn(rs.getString("postnummernavn"));
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

