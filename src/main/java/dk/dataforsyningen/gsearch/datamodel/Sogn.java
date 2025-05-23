package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Sogn {

  @Schema(description = "Sognekode")
  private String sognekode;

  @Schema(description = "Navn på sogn")
  private String sognenavn;

  @Schema(description = "Præsentationsform for et sogn")
  private String visningstekst;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil sogn")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Sogn() {
  }

  public Sogn(String sognekode, String sognenavn, String visningstekst, String kommunekode,
              Geometry geometri, Geometry bbox) {
    this.sognekode = sognekode;
    this.sognenavn = sognenavn;
    this.visningstekst = visningstekst;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public String getSognekode() {
    return sognekode;
  }

  public void setSognekode(String sognekode) {
    this.sognekode = sognekode;
  }

  public String getSognenavn() {
    return sognenavn;
  }

  public void setSognenavn(String sognenavn) {
    this.sognenavn = sognenavn;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public String getKommunekode() {
    return kommunekode;
  }

  public void setKommunekode(String kommunekode) {
    this.kommunekode = kommunekode;
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
