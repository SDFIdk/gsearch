package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Retskreds {

  @Schema(description = "Retskredsnummer")
  private Integer retskredsnummer;

  @Schema(description = "Navn på retskreds")
  private String retkredsnavn;

  @Schema(description = "Præsentationsform for en retskreds")
  private String visningstekst;

  @Schema(description = "Retskredsens myndighedskode. Er unik for hver retskreds. 4 cifre.")
  private String myndighedskode;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil retskredsen")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Retskreds() {
  }

  public Retskreds(Integer retskredsnummer, String retkredsnavn, String visningstekst,
                   String myndighedskode, String kommunekode, Geometry geometri, Geometry bbox) {
    this.retskredsnummer = retskredsnummer;
    this.retkredsnavn = retkredsnavn;
    this.visningstekst = visningstekst;
    this.myndighedskode = myndighedskode;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public Integer getRetskredsnummer() {
    return retskredsnummer;
  }

  public void setRetskredsnummer(Integer retskredsnummer) {
    this.retskredsnummer = retskredsnummer;
  }

  public String getRetkredsnavn() {
    return retkredsnavn;
  }

  public void setRetkredsnavn(String retkredsnavn) {
    this.retkredsnavn = retkredsnavn;
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
