package dk.dataforsyningen.gsearch;

import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Represents a geosearch result response
 */
public class Result {
    @Schema(allowableValues = {"OK", "ERROR"})
    public String status;
    public String message;
    public List<Data> data;
}