package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Adresse;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class AdresseMapper implements RowMapper<Adresse> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public AdresseMapper() {
  }

  @Override
  public Adresse map(ResultSet rs, StatementContext ctx) throws SQLException {
    Adresse data = new Adresse();

    data.setId(UUID.fromString(rs.getString("id")));
    data.setKommunenavn(rs.getString("kommunenavn"));
    data.setKommunekode(rs.getString("kommunekode"));
    data.setVejkode(rs.getString("vejkode"));
    data.setVejnavn(rs.getString("vejnavn"));
    data.setHusnummer(rs.getString("husnummer"));
    data.setEtagebetegnelse(rs.getString("etagebetegnelse"));
    data.setDoerbetegnelse(rs.getString("doerbetegnelse"));
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

