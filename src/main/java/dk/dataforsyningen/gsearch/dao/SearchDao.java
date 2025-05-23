package dk.dataforsyningen.gsearch.dao;

import dk.dataforsyningen.gsearch.datamodel.Adresse;
import dk.dataforsyningen.gsearch.datamodel.Husnummer;
import dk.dataforsyningen.gsearch.datamodel.Kommune;
import dk.dataforsyningen.gsearch.datamodel.Matrikel;
import dk.dataforsyningen.gsearch.datamodel.MatrikelUdgaaet;
import dk.dataforsyningen.gsearch.datamodel.Navngivenvej;
import dk.dataforsyningen.gsearch.datamodel.Opstillingskreds;
import dk.dataforsyningen.gsearch.datamodel.Politikreds;
import dk.dataforsyningen.gsearch.datamodel.Postnummer;
import dk.dataforsyningen.gsearch.datamodel.Region;
import dk.dataforsyningen.gsearch.datamodel.Retskreds;
import dk.dataforsyningen.gsearch.datamodel.Sogn;
import dk.dataforsyningen.gsearch.datamodel.Stednavn;
import java.util.List;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SearchDao implements ISearchDao {

  @Autowired
  private Jdbi jdbi;

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Adresse> getAdresse(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.adresse(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Adresse.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Husnummer> getHusnummer(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.husnummer(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Husnummer.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Kommune> getKommune(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.kommune(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Kommune.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Matrikel> getMatrikel(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.matrikel(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Matrikel.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<MatrikelUdgaaet> getMatrikelUdgaaet(String q, String where, Integer limit,
                                                  Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.matrikel_udgaaet(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(MatrikelUdgaaet.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Navngivenvej> getNavngivenvej(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.navngivenvej(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Navngivenvej.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Opstillingskreds> getOpstillingskreds(String q, String where, Integer limit,
                                                    Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.opstillingskreds(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Opstillingskreds.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Politikreds> getPolitikreds(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.politikreds(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Politikreds.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Postnummer> getPostnummer(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.postnummer(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Postnummer.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Region> getRegion(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.region(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Region.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Retskreds> getRetskreds(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.retskreds(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Retskreds.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Sogn> getSogn(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.sogn(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Sogn.class)
          .list();
    });
  }

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities.
   *
   * @param q
   * @param where
   * @param limit
   * @return
   */
  public List<Stednavn> getStednavn(String q, String where, Integer limit, Integer srid) {
    return jdbi.withHandle(handle -> {
      String sql = "select (api.stednavn(:q, :where, 1, :limit, :srid)).*";
      return handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .bind("srid", srid)
          .mapTo(Stednavn.class)
          .list();
    });
  }
}
