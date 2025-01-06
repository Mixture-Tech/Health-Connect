package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import mixture.hutech.backend.enums.ErrorCodeEnum;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MessageResponse {
    @JsonProperty("error_code")
    private ErrorCodeEnum errorCode;
    @JsonProperty("message")
    private String message;
    @JsonProperty("data")
    private Object data;
}
