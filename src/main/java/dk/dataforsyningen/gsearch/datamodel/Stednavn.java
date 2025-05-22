package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.UUID;
import org.locationtech.jts.geom.Geometry;

public class Stednavn {

  @Schema(description = "UUID for stednavn")
  private UUID id;

  @Schema(description = "Skrivemåde for stednavn")
  private String skrivemaade;

  @Schema(description = "Præsentationsform for et stednavn")
  private String visningstekst;

  @Schema(description = "Officiel skrivemåde for stednavn")
  private String skrivemaade_officiel;

  @Schema(description = "Uofficiel skrivemåde for stednavn")
  private String skrivemaade_uofficiel;

  @Schema(description = "Featuretype på stednavn")
  private String stednavn_type;

  @Schema(description = "Topografitype på stednavn")
  private String stednavn_subtype;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil stednavn")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Stednavn() {
  }

  public Stednavn(UUID id, String skrivemaade, String visningstekst, String skrivemaade_officiel,
                  String skrivemaade_uofficiel, String stednavn_type, String stednavn_subtype,
                  String kommunekode, Geometry geometri, Geometry bbox) {
    this.id = id;
    this.skrivemaade = skrivemaade;
    this.visningstekst = visningstekst;
    this.skrivemaade_officiel = skrivemaade_officiel;
    this.skrivemaade_uofficiel = skrivemaade_uofficiel;
    this.stednavn_type = stednavn_type;
    this.stednavn_subtype = stednavn_subtype;
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

  public String getSkrivemaade() {
    return skrivemaade;
  }

  public void setSkrivemaade(String skrivemaade) {
    this.skrivemaade = skrivemaade;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public String getSkrivemaade_officiel() {
    return skrivemaade_officiel;
  }

  public void setSkrivemaade_officiel(String skrivemaade_officiel) {
    this.skrivemaade_officiel = skrivemaade_officiel;
  }

  public String getSkrivemaade_uofficiel() {
    return skrivemaade_uofficiel;
  }

  public void setSkrivemaade_uofficiel(String skrivemaade_uofficiel) {
    this.skrivemaade_uofficiel = skrivemaade_uofficiel;
  }

  public String getStednavn_type() {
    return stednavn_type;
  }

  public void setStednavn_type(String stednavn_type) {
    this.stednavn_type = stednavn_type;
  }

  public String getStednavn_subtype() {
    return stednavn_subtype;
  }

  public void setStednavn_subtype(String stednavn_subtype) {
    this.stednavn_subtype = stednavn_subtype;
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
