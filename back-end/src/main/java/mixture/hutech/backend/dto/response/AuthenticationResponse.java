package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import mixture.hutech.backend.enums.ErrorCodeEnum;

import java.util.Map;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationResponse {
    @JsonProperty("message")
    private String message;
    @JsonProperty("access_token")
    private String accessToken;
    @JsonProperty("refresh_token")
    private String refreshToken;
    @JsonProperty("name")
    private String name;
    @JsonProperty("role")
    private String role;
    @JsonProperty("error_code")
    private ErrorCodeEnum errorCode;

    public AuthenticationResponse(String message) {
        this.message = message;
    }
}
