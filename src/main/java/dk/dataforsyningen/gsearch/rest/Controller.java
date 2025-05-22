package dk.dataforsyningen.gsearch.rest;

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
import dk.dataforsyningen.gsearch.service.ISearchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import java.util.AbstractMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.geotools.data.jdbc.FilterToSQLException;
import org.geotools.filter.text.cql2.CQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
public class Controller {

  private static final String illegalMessage =
      "SRID is not allowed. Allow list: 2197, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833";

  private static final Map<Integer, String> epsgMap = Map.ofEntries(
      new AbstractMap.SimpleEntry<Integer, String>(2196,
          "https://www.opengis.net/def/crs/EPSG/0/2196"),
      new AbstractMap.SimpleEntry<Integer, String>(2197,
          "https://www.opengis.net/def/crs/EPSG/0/2197"),
      new AbstractMap.SimpleEntry<Integer, String>(2198,
          "https://www.opengis.net/def/crs/EPSG/0/2198"),
      new AbstractMap.SimpleEntry<Integer, String>(3857,
          "https://www.opengis.net/def/crs/EPSG/0/3857"),
      new AbstractMap.SimpleEntry<Integer, String>(4093,
          "https://www.opengis.net/def/crs/EPSG/0/4093"),
      new AbstractMap.SimpleEntry<Integer, String>(4094,
          "https://www.opengis.net/def/crs/EPSG/0/4094"),
      new AbstractMap.SimpleEntry<Integer, String>(4095,
          "https://www.opengis.net/def/crs/EPSG/0/4095"),
      new AbstractMap.SimpleEntry<Integer, String>(4096,
          "https://www.opengis.net/def/crs/EPSG/0/4096"),
      new AbstractMap.SimpleEntry<Integer, String>(4326,
          "https://www.opengis.net/def/crs/EPSG/0/4326"),
      new AbstractMap.SimpleEntry<Integer, String>(25832,
          "https://www.opengis.net/def/crs/EPSG/0/25832"),
      new AbstractMap.SimpleEntry<Integer, String>(25833,
          "https://www.opengis.net/def/crs/EPSG/0/25833")
  );
  private final ISearchService iSearchService;

  @Autowired
  public Controller(ISearchService iSearchService) {
    this.iSearchService = iSearchService;
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/adresse", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "adresse", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Adresse.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Adresse>> getAdresse(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Adresse> result = iSearchService.getAdresseResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/husnummer", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "husnummer", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Husnummer.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Husnummer>> getHusnummer(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Husnummer> result =
          iSearchService.getHusnummerResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/kommune", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "kommune", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Kommune.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Kommune>> getKommune(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Kommune> result = iSearchService.getKommuneResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/matrikel", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "matrikel", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Matrikel.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Matrikel>> getMatrikel(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Matrikel> result = iSearchService.getMatrikelResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/matrikel_udgaaet", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "matrikel_udgaaet", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = MatrikelUdgaaet.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<MatrikelUdgaaet>> getMatrikelUdgaaet(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<MatrikelUdgaaet> result =
          iSearchService.getMatrikelUdgaaetResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }


  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/navngivenvej", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "navngivenvej", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Navngivenvej.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Navngivenvej>> getNavngivenvej(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Navngivenvej> result =
          iSearchService.getNavngivenvejResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/opstillingskreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "opstillingskreds", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Opstillingskreds.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Opstillingskreds>> getOpstillingskreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Opstillingskreds> result =
          iSearchService.getOpstillingskredsResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/politikreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "politikreds", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Politikreds.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Politikreds>> getPolitikreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Politikreds> result =
          iSearchService.getPolitikredsResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/postnummer", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "postnummer", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Postnummer.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Postnummer>> getPostnummer(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Postnummer> result =
          iSearchService.getPostnummerResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/region", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "region", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Region.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Region>> getRegion(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Region> result = iSearchService.getRegionResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
   * @param q
   * @param filter
   * @param limit
   * @param srid
   * @return
   * @throws CQLException
   * @throws FilterToSQLException
   */
  @GetMapping(path = "/retskreds", produces = MediaType.APPLICATION_JSON_VALUE)
  @Operation(operationId = "retskreds", tags = {"Gsearch"}, responses = {
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Retskreds.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Retskreds>> getRetskreds(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Retskreds> result =
          iSearchService.getRetskredsResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
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
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Sogn.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Sogn>> getSogn(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Sogn> result = iSearchService.getSognResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }

  /**
   * Add header Content-Crs to inform what crs geometry is in response json
   *
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
      @ApiResponse(description = "Successful Operation", responseCode = "200",
          content = @Content(mediaType = "application/json",
              array = @ArraySchema(schema = @Schema(implementation = Stednavn.class)))),
      @ApiResponse(responseCode = "404", description = "Not found", content = @Content),
      @ApiResponse(responseCode = "401", description = "Authentication Failure",
          content = @Content(schema = @Schema(hidden = true)))})
  public ResponseEntity<List<Stednavn>> getStednavn(
      @Parameter(description = "Søgestreng")
      @RequestParam(value = "q", required = true) @NotBlank String q,
      @Parameter(description = "Angives med ECQL-text. Er kun kompatibelt med én resource angivet i requesten. Mulige atribut filtreringer er forskellige fra resource til resource. Se de mulige atribut filteringer i 'Schemas'. ECQL Dokumentation: https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#ecql-expr. Vejledning ECQL: https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html")
      @RequestParam(required = false) Optional<String> filter,
      @Parameter(description = "Maksantallet af returneret data elementer. Maks = 100")
      @RequestParam(defaultValue = "10") @Max(100) @Positive Integer limit,
      @Parameter(description = "Koordinatsystem for returnerede geometrier som ESPG kode Default: 25832. Tilladte koder: 2196, 2197, 2198, 3857, 4093, 4094, 4095, 4096, 4326, 25832, 25833")
      @RequestParam(value = "srid", defaultValue = "25832") @Positive Integer srid,
      HttpServletResponse response)
      throws FilterToSQLException, CQLException {

    if (epsgMap.containsKey(srid)) {
      List<Stednavn> result = iSearchService.getStednavnResult(q, filter, limit, srid);

      response.addHeader("Content-Crs", "<" + epsgMap.get(srid) + ">");

      return new ResponseEntity<>(result, HttpStatus.OK);
    }
    throw new IllegalArgumentException(illegalMessage);
  }
}
