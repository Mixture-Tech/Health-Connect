package mixture.hutech.backend.exceptions;

import lombok.Getter;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import org.springframework.http.HttpStatus;

@Getter
public class ApiException extends RuntimeException {
  private final ErrorCodeEnum errorCodeEnum;

  public ApiException(ErrorCodeEnum errorCodeEnum) {
    super(errorCodeEnum.getMessage());
    this.errorCodeEnum = errorCodeEnum;
  }

  public int getCode() {
    return errorCodeEnum.getCode();
  }

  public HttpStatus getHttpStatus() {
    return errorCodeEnum.getHttpStatus();
  }
}
