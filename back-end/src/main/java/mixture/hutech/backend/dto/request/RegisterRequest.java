package mixture.hutech.backend.dto.request;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    private String username;
    private String email;
    private String password;
    private String phone;
    private String address;
    private LocalDate dateOfBirth;
    private String gender;
    private int role;
}
