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

  private List<Integer> allowedEPSGs = Arrays.asList(2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833);
  private static final illigalEPSGMessage = "SRID is not allowed. Allowlist: 2197, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833"
  private final ISearchService iSearchService;

  @Autowired
  public Controller(ISearchService iSearchService) {
    this.iSearchService = iSearchService;
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<adresse> result = iSearchService.getResult(q, "adresse", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<husnummer> result = iSearchService.getResult(q, "husnummer", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<kommune> result = iSearchService.getResult(q, "kommune", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<matrikel> result = iSearchService.getResult(q, "matrikel", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<matrikel_udgaaet> result = iSearchService.getResult(q, "matrikel_udgaaet", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<navngivenvej> result = iSearchService.getResult(q, "navngivenvej", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<opstillingskreds> result = iSearchService.getResult(q, "opstillingskreds", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<politikreds> result = iSearchService.getResult(q, "politikreds", filter, limit,  srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<postnummer> result = iSearchService.getResult(q, "postnummer", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<region> result = iSearchService.getResult(q, "region", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<retskreds> result = iSearchService.getResult(q, "retskreds", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<sogn> result = iSearchService.getResult(q, "sogn", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }

  /**
   * @param q
   * @param filter
   * @param limit
   * @param srid
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
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for output og filter som EPSG kode. Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid)
      throws FilterToSQLException, CQLException {

    if (allowedEPSGs.contains(srid)) {
        List<stednavn> result = iSearchService.getResult(q, "stednavn", filter, limit, srid);

        return result;
    }
    throw new IllegalArgumentException(illigalEPSGMessage);
  }
}
