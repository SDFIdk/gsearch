package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Region {

  @Schema(description = "Regionskode")
  private String regionskode;

  @Schema(description = "Navn på region")
  private String regionsnavn;

  @Schema(description = "Præsentationsform for en region")
  private String visningstekst;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil region")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Region() {
  }

  public Region(String regionskode, String regionsnavn, String visningstekst, String kommunekode,
                Geometry geometri, Geometry bbox) {
    this.regionskode = regionskode;
    this.regionsnavn = regionsnavn;
    this.visningstekst = visningstekst;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public String getRegionskode() {
    return regionskode;
  }

  public void setRegionskode(String regionskode) {
    this.regionskode = regionskode;
  }

  public String getRegionsnavn() {
    return regionsnavn;
  }

  public void setRegionsnavn(String regionsnavn) {
    this.regionsnavn = regionsnavn;
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
