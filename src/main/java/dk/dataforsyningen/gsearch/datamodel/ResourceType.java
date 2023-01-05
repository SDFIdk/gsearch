package dk.dataforsyningen.gsearch.datamodel;

public enum ResourceType {
  ADRESSE,
  HUSNUMMER,
  KOMMUNE,
  MATRIKELNUMMER,
  NAVNGIVENVEJ,
  OPSTILLINGSKREDS,
  POLITIKREDS,
  POSTDISTRIKT,
  REGION,
  RETSKREDS,
  SOGN,
  STEDNAVN;

  @Override
  public String toString() {
    return name().toLowerCase();
  }
}
