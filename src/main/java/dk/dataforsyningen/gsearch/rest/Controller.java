package dk.dataforsyningen.gsearch.rest;

import dk.dataforsyningen.gsearch.ResourceTypes;
import dk.dataforsyningen.gsearch.datamodel.adresse;
import dk.dataforsyningen.gsearch.datamodel.husnummer;
import dk.dataforsyningen.gsearch.datamodel.kommune;
import dk.dataforsyningen.gsearch.datamodel.matrikel;
import dk.dataforsyningen.gsearch.datamodel.matrikel_udgaaet;
import dk.dataforsyningen.gsearch.datamodel.navngivenvej;
import dk.dataforsyningen.gsearch.datamodel.opstillingskreds;
import dk.dataforsyningen.gsearch.datamodel.politikreds;
import dk.dataforsyningen.gsearch.datamodel.postnummer;
import dk.dataforsyningen.gsearch.datamodel.region;
import dk.dataforsyningen.gsearch.datamodel.retskreds;
import dk.dataforsyningen.gsearch.datamodel.sogn;
import dk.dataforsyningen.gsearch.datamodel.stednavn;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

import java.util.List;
import java.util.Optional;
import org.geotools.data.jdbc.FilterToSQL;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.data.postgis.PostGISDialect;
import org.geotools.filter.text.cql2.CQLException;
import org.geotools.filter.text.ecql.ECQL;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.FieldMapper;
import org.opengis.filter.Filter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
public class Controller {

  static Logger logger = LoggerFactory.getLogger(Controller.class);

  static PostGISDialect dialect = new PostGISDialect(null);
  static FilterToSQL filterToSQL = new CustomPostgisFilterToSQL(dialect);

  static {
    dialect.setFunctionEncodingEnabled(true);
    filterToSQL.setInline(true);
  }

  @Autowired
  private Jdbi jdbi;

  @Autowired
  private ResourceTypes resourceTypes;

  /**
   * It assembles full sql query from the parameters and maps the result to list of data entities
   *
   * @param q
   * @param resource
   * @param where
   * @param limit
   * @return
   */
  private <T> List<T> getData(String q, String resource, String where, Integer limit) {
    return (List<T>) jdbi.withHandle(handle -> {
      String sql = "select (api." + resource + "(:q, :where, 1, :limit)).*";
      // TODO: This gets register every time this method gets called
      handle.registerRowMapper(FieldMapper.factory(Object.class));
      List<Object> data = handle
          .createQuery(sql)
          .bind("q", q)
          .bind("where", where)
          .bind("limit", limit)
          .map(new DataMapper(resource))
          .list();
      return data;
    });
  }

  /**
   * Transform request to database query, execute query and return the result
   *
   * @param q
   * @param resource
   * @param filter
   * @param limit
   * @return
   * @throws FilterToSQLException
   * @throws CQLException
   */
  private <T> List<T> getResult(String q, String resource, Optional<String> filter, Integer limit)
      throws FilterToSQLException, CQLException {

    String where = null;
    // If filter is present we need to change the CQl to SQL
    if (filter.isPresent()) {
      // To transform cql filter to sql where clause
      Filter ogcFilter = ECQL.toFilter(filter.get());
      logger.debug("ogcFilter: " + ogcFilter);
      // TODO: visit filter to apply restrictions
      // TODO: visit filter to remove non applicable (field name not in type fx.)
      // Fixes shared memory issue with out
      synchronized (this) {
        where = filterToSQL.encodeToString(ogcFilter);
      }

      logger.debug("where: " + where);
    }

    // NOTE: Hack correct SRID
    String finalWhere = where == null ? null : where.replaceAll("', null", "', 25832");
    logger.debug("finalWhere: " + finalWhere);

    List<T> result = getData(q, resource, finalWhere, limit);

    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/adresse", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "adresse", tags = {"Gsearch"})
  public List<adresse> getAdresse(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<adresse> result = getResult(q, "adresse", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/husnummer", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "husnummer", tags = {"Gsearch"})
  public List<husnummer> getHusnummer(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<husnummer> result = getResult(q, "husnummer", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/kommune", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "kommune", tags = {"Gsearch"})
  public List<kommune> getKommune(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<kommune> result = getResult(q, "kommune", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/matrikel", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "matrikel", tags = {"Gsearch"})
  public List<matrikel> getMatrikel(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<matrikel> result = getResult(q, "matrikel", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/matrikel_udgaaet", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "matrikel_udgaaet", tags = {"Gsearch"})
  public List<matrikel_udgaaet> getMatrikelUdgaaet(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<matrikel_udgaaet> result = getResult(q, "matrikel_udgaaet", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/navngivenvej", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "navngivenvej", tags = {"Gsearch"})
  public List<navngivenvej> getNavngivenvej(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<navngivenvej> result = getResult(q, "navngivenvej", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/opstillingskreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "opstillingskreds", tags = {"Gsearch"})
  public List<opstillingskreds> getOpstillingskreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<opstillingskreds> result = getResult(q, "opstillingskreds", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/politikreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "politikreds", tags = {"Gsearch"})
  public List<politikreds> getPolitikreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<politikreds> result = getResult(q, "politikreds", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/postnummer", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "postnummer", tags = {"Gsearch"})
  public List<postnummer> getPostnummer(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<postnummer> result = getResult(q, "postnummer", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/region", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "region", tags = {"Gsearch"})
  public List<region> getRegion(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<region> result = getResult(q, "region", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/retskreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "retskreds", tags = {"Gsearch"})
  public List<retskreds> getRetskreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<retskreds> result = getResult(q, "retskreds", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/sogn", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "sogn", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200", content = @Content(mediaType = "application/json", schema = @Schema(implementation = sogn.class))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure", content = @Content(schema = @Schema(hidden = true)))})
  public List<sogn> getSogn(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<sogn> result = getResult(q, "sogn", filter, limit);
    return result;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/stednavn", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "stednavn", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200", content = @Content(mediaType = "application/json", schema = @Schema(implementation = stednavn.class))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure", content = @Content(schema = @Schema(hidden = true)))})
  public List<stednavn> getStednavn(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit)
      throws FilterToSQLException, CQLException {

    List<stednavn> result = getResult(q, "stednavn", filter, limit);
    return result;
  }
}
