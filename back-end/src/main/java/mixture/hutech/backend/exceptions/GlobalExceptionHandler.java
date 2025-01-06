package mixture.hutech.backend.exceptions;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import mixture.hutech.backend.dto.response.AuthenticationResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<AuthenticationResponse> handleApiException(ApiException exception) {
        AuthenticationResponse response = AuthenticationResponse.builder()
                .message(exception.getMessage())
                .errorCode(exception.getErrorCodeEnum())
                .build();
        return new ResponseEntity<>(response, exception.getHttpStatus());
    }

//    @ExceptionHandler(ConstraintViolationException.class)
//    @ResponseStatus(HttpStatus.BAD_REQUEST)
//    public ResponseEntity<Map<String, String>> handleConstraintViolationException(ConstraintViolationException exception) {
//        Map<String, String> errors = new HashMap<>();
//        Set<ConstraintViolation<?>> violations = exception.getConstraintViolations();
//
//        for (ConstraintViolation<?> violation : violations) {
//            String field = violation.getPropertyPath().toString();
//            String message = violation.getMessage();
//            errors.put(field, message);
//        }
//
//        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
//    }

//    @ExceptionHandler(value = {BadRequestException.class})
//    @ResponseStatus(HttpStatus.BAD_REQUEST)
//    public ResponseEntity<Object> handleBadRequestException(BadRequestException ex){
//        // 1. Create payload containing exception details
//        ApiException apiException = new ApiException(
//                ex.getMessage(),
//                HttpStatus.BAD_REQUEST
//        );
//        // 2. Return response entity
//        return new ResponseEntity<>(apiException,HttpStatus.BAD_REQUEST);
//    }
//
//    @ExceptionHandler(value = {NotFoundException.class})
//    @ResponseStatus(HttpStatus.NOT_FOUND)
//    public ResponseEntity<Object> handleNotFoundException(NotFoundException ex){
//        ApiException apiException = new ApiException(
//                ex.getMessage(),
//                HttpStatus.NOT_FOUND
//        );
//        return new ResponseEntity<>(apiException,HttpStatus.NOT_FOUND);
//    }
//
//    @ExceptionHandler(value = {ConflictException.class})
//    @ResponseStatus(HttpStatus.CONFLICT)
//    public ResponseEntity<Object> handleConflictException(ConflictException ex){
//        ApiException apiException = new ApiException(
//                ex.getMessage(),
//                HttpStatus.CONFLICT
//        );
//        return new ResponseEntity<>(apiException,HttpStatus.CONFLICT);
//    }
//
//    @ExceptionHandler(value = {UnauthorizedException.class})
//    @ResponseStatus(HttpStatus.UNAUTHORIZED)
//    public ResponseEntity<Object> handleUnauthorizedException(UnauthorizedException ex){
//        ApiException apiException = new ApiException(
//                ex.getMessage(),
//                HttpStatus.UNAUTHORIZED
//        );
//        return new ResponseEntity<>(apiException,HttpStatus.UNAUTHORIZED);
//    }
}
