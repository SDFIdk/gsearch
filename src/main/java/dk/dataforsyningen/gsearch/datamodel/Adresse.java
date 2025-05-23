package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.UUID;
import org.locationtech.jts.geom.Geometry;

public class Adresse {

  @Schema(description = "UUID på adresse")
  private UUID id;

  @Schema(description = "Kommunenavn for adresse")
  private String kommunenavn;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil en adresse")
  private String kommunekode;

  @Schema(description = "Vejkode for adresse")
  private String vejkode;

  @Schema(description = "Vejnavn for adresse")
  private String vejnavn;

  @Schema(description = "Husnummer på adresse")
  private String husnummer;

  @Schema(description = "Etagebetegnelse for adresse")
  private String etagebetegnelse;

  @Schema(description = "Dørbetegnelse for adresse")
  private String doerbetegnelse;

  @Schema(description = "Supplerende bynavn(e) for adresse")
  private String supplerendebynavn;

  @Schema(description = "Postnummer på adresse")
  private String postnummer;

  @Schema(description = "Postnummernavn på adresse")
  private String postnummernavn;

  @Schema(description = "Fulde adresse")
  private String visningstekst;

  @Schema(description = "Geometri for vejpunkt i den valgte EPSG kode, default EPSG:25832")
  private Geometry vejpunkt_geometri;

  @Schema(description = "Geometri for adgangspunkt i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  public Adresse() {
  }

  public Adresse(UUID id, String kommunenavn, String kommunekode, String vejkode, String vejnavn,
                 String husnummer, String etagebetegnelse, String doerbetegnelse,
                 String supplerendebynavn, String postnummer, String postnummernavn,
                 String visningstekst, Geometry vejpunkt_geometri, Geometry geometri) {
    this.id = id;
    this.kommunenavn = kommunenavn;
    this.kommunekode = kommunekode;
    this.vejkode = vejkode;
    this.vejnavn = vejnavn;
    this.husnummer = husnummer;
    this.etagebetegnelse = etagebetegnelse;
    this.doerbetegnelse = doerbetegnelse;
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

  public String getHusnummer() {
    return husnummer;
  }

  public void setHusnummer(String husnummer) {
    this.husnummer = husnummer;
  }

  public String getEtagebetegnelse() {
    return etagebetegnelse;
  }

  public void setEtagebetegnelse(String etagebetegnelse) {
    this.etagebetegnelse = etagebetegnelse;
  }

  public String getDoerbetegnelse() {
    return doerbetegnelse;
  }

  public void setDoerbetegnelse(String doerbetegnelse) {
    this.doerbetegnelse = doerbetegnelse;
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
