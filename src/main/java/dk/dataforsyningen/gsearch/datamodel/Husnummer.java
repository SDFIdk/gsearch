package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.UUID;
import org.locationtech.jts.geom.Geometry;

public class Husnummer {
  @Schema(description = "UUID på husnummer")
  private UUID id;

  @Schema(description = "Kommunenavn for husnummer")
  private String kommunenavn;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil et husnummer")
  private String kommunekode;

  @Schema(description = "Vejkode for husnummer")
  private String vejkode;

  @Schema(description = "Vejnavn for husnummer")
  private String vejnavn;

  @Schema(description = "Husnummertekst evt. med bogstavsbetegnelse")
  private String husnummertekst;

  @Schema(description = "Supplerende bynavn(e) for husnummer")
  private String supplerendebynavn;

  @Schema(description = "Postnummer på husnummer")
  private String postnummer;

  @Schema(description = "Postnummernavn på husnummer")
  private String postnummernavn;

  @Schema(description = "Adgangsadresse for husnummer")
  private String visningstekst;

  @Schema(description = "Geometri for vejpunkt i den valgte EPSG kode, default EPSG:25832")
  private Geometry vejpunkt_geometri;

  @Schema(description = "Geometri for adgangspunkt i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  public Husnummer() {
  }

  public Husnummer(UUID id, String kommunenavn, String kommunekode, String vejkode,
                   String vejnavn,
                   String husnummertekst, String supplerendebynavn, String postnummer,
                   String postnummernavn, String visningstekst, Geometry vejpunkt_geometri,
                   Geometry geometri) {
    this.id = id;
    this.kommunenavn = kommunenavn;
    this.kommunekode = kommunekode;
    this.vejkode = vejkode;
    this.vejnavn = vejnavn;
    this.husnummertekst = husnummertekst;
    this.supplerendebynavn = supplerendebynavn;
    this.postnummer = postnummer;
    this.postnummernavn = postnummernavn;
    this.visningstekst = visningstekst;
    this.vejpunkt_geometri = vejpunkt_geometri;
    this.geometri = geometri;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
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

  public String getVejkode() {
    return vejkode;
  }

  public void setVejkode(String vejkode) {
    this.vejkode = vejkode;
  }

  public String getVejnavn() {
    return vejnavn;
  }

  public void setVejnavn(String vejnavn) {
    this.vejnavn = vejnavn;
  }

  public String getHusnummertekst() {
    return husnummertekst;
  }

  public void setHusnummertekst(String husnummertekst) {
    this.husnummertekst = husnummertekst;
  }

  public String getSupplerendebynavn() {
    return supplerendebynavn;
  }

  public void setSupplerendebynavn(String supplerendebynavn) {
    this.supplerendebynavn = supplerendebynavn;
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

  public Geometry getVejpunkt_geometri() {
    return vejpunkt_geometri;
  }

  public void setVejpunkt_geometri(Geometry vejpunkt_geometri) {
    this.vejpunkt_geometri = vejpunkt_geometri;
  }

  public Geometry getGeometri() {
    return geometri;
  }

  public void setGeometri(Geometry geometri) {
    this.geometri = geometri;
  }
}
