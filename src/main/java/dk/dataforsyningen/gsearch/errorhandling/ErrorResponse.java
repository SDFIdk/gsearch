package dk.dataforsyningen.downloadmanager.errorhandling;

import java.time.Instant;
import java.util.List;
import org.springframework.http.HttpStatus;

public class ErrorResponse {
  /** The HTTP status code */
  private HttpStatus status;

  /** The error message associated with exception */
  private String message;

  /** List of constructed error messages */
  private List<String> errors;

  Instant instant = Instant.now();

  Instant epochSeconds = Instant.ofEpochSecond(instant.getEpochSecond());

  public ErrorResponse(String message) {
    this.message = epochSeconds.toString() + ": " + message;
  }

  public ErrorResponse(HttpStatus status, String message) {
    this.status = status;
    this.message = message;
  }

  public ErrorResponse(HttpStatus status, String message, List<String> errors) {
    super();
    this.status = status;
    this.message = epochSeconds.toString() + ": " + message;
    this.errors = errors;
  }

  public ErrorResponse(HttpStatus status, String message, String error) {
    super();
    this.status = status;
    this.message = epochSeconds.toString() + ": " + message;
    errors = List.of(error);
  }

  public HttpStatus getStatus() {
    return status;
  }

  public void setStatus(HttpStatus status) {
    this.status = status;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public List<String> getErrors() {
    return errors;
  }

  public void setErrors(List<String> errors) {
    this.errors = errors;
  }
}
