package dk.dataforsyningen.gsearch.mapper;

import dk.dataforsyningen.gsearch.datamodel.Region;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import org.locationtech.jts.geom.Geometry;

public class RegionMapper implements RowMapper<Region> {

  MapGeometryHelper mapGeometryHelper = new MapGeometryHelper();

  public RegionMapper() {
  }

  @Override
  public Region map(ResultSet rs, StatementContext ctx) throws SQLException {
    Region data = new Region();

    data.setRegionskode(rs.getString("regionskode"));
    data.setRegionsnavn(rs.getString("regionsnavn"));
    data.setVisningstekst(rs.getString("visningstekst"));
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

