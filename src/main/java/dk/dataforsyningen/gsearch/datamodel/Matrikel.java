package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import org.locationtech.jts.geom.Geometry;

public class Matrikel {

  @Schema(description = "Ejerlavsnavn for matrikel")
  private String ejerlavsnavn;

  @Schema(description = "Ejerlavskode for matrikel")
  private Integer ejerlavskode;

  @Schema(description = "Kommunenavn for matrikel")
  private String kommunenavn;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil matrikel")
  private String kommunekode;

  @Schema(description = "Matrikelnummer")
  private String matrikelnummer;

  @Schema(description = "Præsentationsform for et matrikel")
  private String visningstekst;

  @Schema(description = "Jordstykke lokalid")
  private Integer jordstykke_id;

  @Schema(description = "BFE-nummer for matrikel")
  private Integer bfenummer;

  @Schema(description = "Centroide X for matriklens geometri i den valgte EPSG kode, default EPSG:25832")
  private BigDecimal centroid_x;

  @Schema(description = "Centroide Y for matriklens geometri i den valgte EPSG kode, default EPSG:25832")
  private BigDecimal centroid_y;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  public Matrikel() {
  }

  public Matrikel(String ejerlavsnavn, Integer ejerlavskode, String kommunenavn, String kommunekode,
                  String matrikelnummer, String visningstekst, Integer jordstykke_id,
                  Integer bfenummer, BigDecimal centroid_x, BigDecimal centroid_y,
                  Geometry geometri) {
    this.ejerlavsnavn = ejerlavsnavn;
    this.ejerlavskode = ejerlavskode;
    this.kommunenavn = kommunenavn;
    this.kommunekode = kommunekode;
    this.matrikelnummer = matrikelnummer;
    this.visningstekst = visningstekst;
    this.jordstykke_id = jordstykke_id;
    this.bfenummer = bfenummer;
    this.centroid_x = centroid_x;
    this.centroid_y = centroid_y;
    this.geometri = geometri;
  }

  public String getEjerlavsnavn() {
    return ejerlavsnavn;
  }

  public void setEjerlavsnavn(String ejerlavsnavn) {
    this.ejerlavsnavn = ejerlavsnavn;
  }

  public Integer getEjerlavskode() {
    return ejerlavskode;
  }

  public void setEjerlavskode(Integer ejerlavskode) {
    this.ejerlavskode = ejerlavskode;
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

  public String getMatrikelnummer() {
    return matrikelnummer;
  }

  public void setMatrikelnummer(String matrikelnummer) {
    this.matrikelnummer = matrikelnummer;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public Integer getJordstykke_id() {
    return jordstykke_id;
  }

  public void setJordstykke_id(Integer jordstykke_id) {
    this.jordstykke_id = jordstykke_id;
  }

  public Integer getBfenummer() {
    return bfenummer;
  }

  public void setBfenummer(Integer bfenummer) {
    this.bfenummer = bfenummer;
  }

  public BigDecimal getCentroid_x() {
    return centroid_x;
  }

  public void setCentroid_x(BigDecimal centroid_x) {
    this.centroid_x = centroid_x;
  }

  public BigDecimal getCentroid_y() {
    return centroid_y;
  }

  public void setCentroid_y(BigDecimal centroid_y) {
    this.centroid_y = centroid_y;
  }

  public Geometry getGeometri() {
    return geometri;
  }

  public void setGeometri(Geometry geometri) {
    this.geometri = geometri;
  }
}
