package dk.dataforsyningen.gsearch.datamodel;

public enum ResourceType {
  ADRESSE,
  HUSNUMMER,
  KOMMUNE,
  MATRIKEL,
  MATRIKEL_UDGAAET,
  NAVNGIVENVEJ,
  OPSTILLINGSKREDS,
  POLITIKREDS,
  POSTNUMMER,
  REGION,
  RETSKREDS,
  SOGN,
  STEDNAVN;

  @Override
  public String toString() {
    return name().toLowerCase();
  }
}
