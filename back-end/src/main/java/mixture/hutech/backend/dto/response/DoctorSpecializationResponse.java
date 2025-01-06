package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DoctorSpecializationResponse {
    // Doctor
    @JsonProperty("doctor_id")
    private String id;
    @JsonProperty("doctor_name")
    private String doctorName;
    @JsonProperty("doctor_description")
    private String doctorDescription;
    @JsonProperty("doctor_image")
    private String doctorImage;
    @JsonProperty("schedules")
    private List<DoctorScheduleResponse> schedules;

}
