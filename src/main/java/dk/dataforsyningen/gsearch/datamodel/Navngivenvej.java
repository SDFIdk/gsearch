package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.UUID;
import org.locationtech.jts.geom.Geometry;

public class Navngivenvej {

  @Schema(description = "UUID på navngiven vej")
  private UUID id;

  @Schema(description = "Navn på vej")
  private String vejnavn;

  @Schema(description = "Supplerende bynavn(e) for navngiven vej")
  private String supplerendebynavn;

  @Schema(description = "Præsentationsform for navngiven vej")
  private String visningstekst;

  @Schema(description = "Postnummer(postnumre) for navngiven vej")
  private String postnummer;

  @Schema(description = "Postnummernavn(e) for navngiven vej")
  private String postnummernavn;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil navngiven vej")
  private String kommunekode;

  @Schema(description = "Geometri for navngivne vej i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Navngivenvej() {
  }

  public Navngivenvej(UUID id, String vejnavn, String supplerendebynavn, String visningstekst,
                      String postnummer, String postnummernavn, String kommunekode,
                      Geometry geometri,
                      Geometry bbox) {
    this.id = id;
    this.vejnavn = vejnavn;
    this.supplerendebynavn = supplerendebynavn;
    this.visningstekst = visningstekst;
    this.postnummer = postnummer;
    this.postnummernavn = postnummernavn;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public String getVejnavn() {
    return vejnavn;
  }

  public void setVejnavn(String vejnavn) {
    this.vejnavn = vejnavn;
  }

  public String getSupplerendebynavn() {
    return supplerendebynavn;
  }

  public void setSupplerendebynavn(String supplerendebynavn) {
    this.supplerendebynavn = supplerendebynavn;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
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
