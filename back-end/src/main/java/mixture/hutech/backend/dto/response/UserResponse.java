package mixture.hutech.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserResponse {
    private String id;
    private String username;
    private String email;
    private String role;
    private String avatar;
    private String phone;
    private LocalDate dateOfBirth;
    private String address;
    private String gender;
    private Set<AppointmentResponse> appointments;

    public UserResponse(String id, String email, String username, String phone, String address, LocalDate dateOfBirth, String gender) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.gender = gender;
    }
}