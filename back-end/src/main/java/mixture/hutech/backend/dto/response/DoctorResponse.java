package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import mixture.hutech.backend.entity.DoctorSchedule;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DoctorResponse {
    @JsonProperty("doctor_id")
    private String doctorId;
    @JsonProperty("doctor_name")
    private String doctorName;
    @JsonProperty("doctor_description")
    private String doctorDescription;
    @JsonProperty("doctor_image")
    private String doctorImage;
    @JsonProperty("specialization_name")
    private String specializationName;
    @JsonProperty("schedules")
    private List<DoctorScheduleResponse> schedules;

    // Constructor for JPA projection
    public DoctorResponse(String doctorId, String doctorName, String doctorDescription, String doctorImage, String specializationName) {
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.doctorDescription = doctorDescription;
        this.doctorImage = doctorImage;
        this.specializationName = specializationName;
    }

    public DoctorResponse(String doctorId, String doctorName, String description, String avatar){
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.doctorDescription = description;
        this.doctorImage = avatar;
    }
}
