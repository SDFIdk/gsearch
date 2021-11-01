package dk.dataforsyningen.gsearch;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

  @ExceptionHandler(value = {
    IllegalArgumentException.class,
    RuntimeException.class,
    Exception.class
  })
  protected ResponseEntity<Object> handleConflict(RuntimeException ex, WebRequest request) {
    Result result = new Result();
    result.status = "ERROR";
    result.message = ex.getMessage();
    return handleExceptionInternal(ex, result, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR, request);
  }
}
