package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Politikreds {

  @Schema(description = "Politikredsnummer")
  private Integer politikredsnummer;

  @Schema(description = "Navn på politikreds")
  private String navn;

  @Schema(description = "Præsentationsform for en politikreds")
  private String visningstekst;

  @Schema(description = "Politikredsens myndighedskode. Er unik for hver politikreds. 4 cifre.")
  private String myndighedskode;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil politikreds")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Politikreds() {
  }

  public Politikreds(Integer politikredsnummer, String navn, String visningstekst,
                     String myndighedskode, String kommunekode, Geometry geometri, Geometry bbox) {
    this.politikredsnummer = politikredsnummer;
    this.navn = navn;
    this.visningstekst = visningstekst;
    this.myndighedskode = myndighedskode;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public Integer getPolitikredsnummer() {
    return politikredsnummer;
  }

  public void setPolitikredsnummer(Integer politikredsnummer) {
    this.politikredsnummer = politikredsnummer;
  }

  public String getNavn() {
    return navn;
  }

  public void setNavn(String navn) {
    this.navn = navn;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public String getMyndighedskode() {
    return myndighedskode;
  }

  public void setMyndighedskode(String myndighedskode) {
    this.myndighedskode = myndighedskode;
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
