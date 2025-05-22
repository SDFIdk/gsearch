package dk.dataforsyningen.gsearch.datamodel;

import io.swagger.v3.oas.annotations.media.Schema;
import org.locationtech.jts.geom.Geometry;

public class Opstillingskreds {

  @Schema(description = "Opstillingskredsnummer")
  private Integer opstillingskredsnummer;

  @Schema(description = "Navn på opstillingskreds")
  private String opstillingskredsnavn;

  @Schema(description = "Præsentationsform for en opstillingskreds")
  private String visningstekst;

  @Schema(description = "Unik nummer indenfor storkredsen")
  private Integer valgkredsnummer;

  @Schema(description = "Unik nummer for storkreds, som opstillingskredsen tilhører")
  private Integer storkredsnummer;

  @Schema(description = "Storkredsens unikke navn")
  private String storkredsnavn;

  @Schema(description = "Kommunekode(r) for kommune(r) der ligger i eller optil opstillingskredsen")
  private String kommunekode;

  @Schema(description = "Geometri i den valgte EPSG kode, default EPSG:25832")
  private Geometry geometri;

  @Schema(description = "Geometriens boundingbox i den valgte EPSG kode, default EPSG:25832")
  private Geometry bbox;

  public Opstillingskreds() {
  }

  public Opstillingskreds(Integer opstillingskredsnummer, String opstillingskredsnavn,
                          String visningstekst, Integer valgkredsnummer, Integer storkredsnummer,
                          String storkredsnavn, String kommunekode, Geometry geometri,
                          Geometry bbox) {
    this.opstillingskredsnummer = opstillingskredsnummer;
    this.opstillingskredsnavn = opstillingskredsnavn;
    this.visningstekst = visningstekst;
    this.valgkredsnummer = valgkredsnummer;
    this.storkredsnummer = storkredsnummer;
    this.storkredsnavn = storkredsnavn;
    this.kommunekode = kommunekode;
    this.geometri = geometri;
    this.bbox = bbox;
  }

  public Integer getOpstillingskredsnummer() {
    return opstillingskredsnummer;
  }

  public void setOpstillingskredsnummer(Integer opstillingskredsnummer) {
    this.opstillingskredsnummer = opstillingskredsnummer;
  }

  public String getOpstillingskredsnavn() {
    return opstillingskredsnavn;
  }

  public void setOpstillingskredsnavn(String opstillingskredsnavn) {
    this.opstillingskredsnavn = opstillingskredsnavn;
  }

  public String getVisningstekst() {
    return visningstekst;
  }

  public void setVisningstekst(String visningstekst) {
    this.visningstekst = visningstekst;
  }

  public Integer getValgkredsnummer() {
    return valgkredsnummer;
  }

  public void setValgkredsnummer(Integer valgkredsnummer) {
    this.valgkredsnummer = valgkredsnummer;
  }

  public Integer getStorkredsnummer() {
    return storkredsnummer;
  }

  public void setStorkredsnummer(Integer storkredsnummer) {
    this.storkredsnummer = storkredsnummer;
  }

  public String getStorkredsnavn() {
    return storkredsnavn;
  }

  public void setStorkredsnavn(String storkredsnavn) {
    this.storkredsnavn = storkredsnavn;
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
