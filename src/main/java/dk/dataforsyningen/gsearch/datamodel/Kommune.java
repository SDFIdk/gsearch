package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Kommune {

  @Schema(description = "Navn på kommune")
  private String kommunenavn;

  @Schema(description = "Kommunekode")
  private String kommunekode;

  @Schema(description = "Præsentationsform for en kommune")
  private String visningstekst;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Kommune() {
  }

  public Kommune(String kommunenavn, String kommunekode, String visningstekst, Geometry geometri,
                 Geometry bbox) {
    this.kommunenavn = kommunenavn;
    this.kommunekode = kommunekode;
    this.visningstekst = visningstekst;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public String getKommunenavn() {
    return kommunenavn;
  }

  public void setKommunenavn(String kommunenavn) {
    this.kommunenavn = kommunenavn;
  }

  public String getKommunekode() {
    return kommunekode;
  }

  public void setKommunekode(String kommunekode) {
    this.kommunekode = kommunekode;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public Geometry getGeometri() {
    return geometri;
  }

  public void setGeometri(Geometry geometri) {
    this.geometri = geometri;
  }

  public Geometry getBbox() {
    return bbox;
  }

  public void setBbox(Geometry bbox) {
    this.bbox = bbox;
  }
}
