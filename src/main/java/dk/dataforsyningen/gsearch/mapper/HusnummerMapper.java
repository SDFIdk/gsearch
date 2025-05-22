package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Husnummer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class HusnummerMapper implements RowMapper<Husnummer> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public HusnummerMapper() {
  }

  @Override
  public Husnummer map(ResultSet rs, StatementContext ctx) throws SQLException {
    Husnummer data = new Husnummer();

    data.setId(UUID.fromString(rs.getString("id")));
    data.setKommunenavn(rs.getString("kommunenavn"));
    data.setKommunekode(rs.getString("kommunekode"));
    data.setVejkode(rs.getString("vejkode"));
    data.setVejnavn(rs.getString("vejnavn"));
    data.setHusnummertekst(rs.getString("husnummertekst"));
    data.setSupplerendebynavn(rs.getString("supplerendebynavn"));
    data.setPostnummer(rs.getString("postnummer"));
    data.setPostnummernavn(rs.getString("postnummernavn"));
    data.setVisningstekst(rs.getString("visningstekst"));


    String vejpunktGeometriString = rs.getString("vejpunkt_geometri");
    byte[] vejpunktGeometriBytes = mapGeometryHelper.hexStringToByteArray(vejpunktGeometriString);
    Geometry vejpunktGeometri = mapGeometryHelper.deserialize(vejpunktGeometriBytes);
    data.setVejpunkt_geometri(vejpunktGeometri);

    String geometriString = rs.getString("geometri");
    byte[] geometriBytes = mapGeometryHelper.hexStringToByteArray(geometriString);
    Geometry geometri = mapGeometryHelper.deserialize(geometriBytes);
    data.setGeometri(geometri);

    return data;
  }
}

