package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Postnummer {

  @Schema(description = "Postnummer")
  private String postnummer;

  @Schema(description = "Navn på postnummernavn")
  private String postnummernavn;

  @Schema(description = "Præsentationsform for et postnummernavn")
  private String visningstekst;

  @Schema(description = "Om postnummeret kun dækker en gade")
  private Boolean gadepostnummer;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil postnummeret")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Postnummer() {
  }

  public Postnummer(String postnummer, String postnummernavn, String visningstekst,
                    Boolean gadepostnummer, String kommunekode, Geometry geometri, Geometry bbox) {
    this.postnummer = postnummer;
    this.postnummernavn = postnummernavn;
    this.visningstekst = visningstekst;
    this.gadepostnummer = gadepostnummer;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public String getPostnummer() {
    return postnummer;
  }

  public void setPostnummer(String postnummer) {
    this.postnummer = postnummer;
  }

  public String getPostnummernavn() {
    return postnummernavn;
  }

  public void setPostnummernavn(String postnummernavn) {
    this.postnummernavn = postnummernavn;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public Boolean getGadepostnummer() {
    return gadepostnummer;
  }

  public void setGadepostnummer(Boolean gadepostnummer) {
    this.gadepostnummer = gadepostnummer;
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
