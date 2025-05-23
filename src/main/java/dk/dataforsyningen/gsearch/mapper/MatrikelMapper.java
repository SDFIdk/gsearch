package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Matrikel;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class MatrikelMapper implements RowMapper<Matrikel> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public MatrikelMapper() {
  }

  @Override
  public Matrikel map(ResultSet rs, StatementContext ctx) throws SQLException {
    Matrikel data = new Matrikel();

    data.setEjerlavsnavn(rs.getString("ejerlavsnavn"));
    data.setEjerlavskode(Integer.valueOf(rs.getString("ejerlavskode")));
    data.setKommunenavn(rs.getString("kommunenavn"));
    data.setKommunekode(rs.getString("kommunekode"));
    data.setMatrikelnummer(rs.getString("matrikelnummer"));
    data.setVisningstekst(rs.getString("visningstekst"));

    // rs.getInt returns the primtive type, but we want the Integer data type
    data.setJordstykke_id(rs.getObject("jordstykke_id", Integer.class));
    data.setBfenummer(rs.getObject("bfenummer", Integer.class));

    // rs.getBigDecimal returns the primtive type, but we want the BigDecimal data type
    data.setCentroid_x(rs.getObject("centroid_x", BigDecimal.class));
    data.setCentroid_y(rs.getObject("centroid_y", BigDecimal.class));

    String geometriString = rs.getString("geometri");
    byte[] geometriBytes = mapGeometryHelper.hexStringToByteArray(geometriString);
    Geometry geometri = mapGeometryHelper.deserialize(geometriBytes);
    data.setGeometri(geometri);

    return data;
  }
}

