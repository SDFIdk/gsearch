package dk.dataforsyningen.gsearch.rest;

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
import dk.dataforsyningen.gsearch.service.ISearchService;
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
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.filter.text.cql2.CQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
public class Controller {

  private final ISearchService iSearchService;

  @Autowired
  public Controller(ISearchService iSearchService) {
    this.iSearchService = iSearchService;
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

    List<adresse> result = iSearchService.getResult(q, "adresse", filter, limit);
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

    List<husnummer> result = iSearchService.getResult(q, "husnummer", filter, limit);
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

    List<kommune> result = iSearchService.getResult(q, "kommune", filter, limit);
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

    List<matrikel> result = iSearchService.getResult(q, "matrikel", filter, limit);
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

    List<matrikel_udgaaet> result = iSearchService.getResult(q, "matrikel_udgaaet", filter, limit);
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

    List<navngivenvej> result = iSearchService.getResult(q, "navngivenvej", filter, limit);
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

    List<opstillingskreds> result = iSearchService.getResult(q, "opstillingskreds", filter, limit);
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

    List<politikreds> result = iSearchService.getResult(q, "politikreds", filter, limit);
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

    List<postnummer> result = iSearchService.getResult(q, "postnummer", filter, limit);
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

    List<region> result = iSearchService.getResult(q, "region", filter, limit);
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

    List<retskreds> result = iSearchService.getResult(q, "retskreds", filter, limit);
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

    List<sogn> result = iSearchService.getResult(q, "sogn", filter, limit);
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

    List<stednavn> result = iSearchService.getResult(q, "stednavn", filter, limit);
    return result;
  }
}
