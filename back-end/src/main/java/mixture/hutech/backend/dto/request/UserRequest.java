package mixture.hutech.backend.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserRequest {
    private String username;
    private LocalDate dateOfBirth;
    private String gender;
    private String address;
}
