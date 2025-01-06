package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import mixture.hutech.backend.entity.DoctorSchedule;
import mixture.hutech.backend.entity.User;
import mixture.hutech.backend.enums.AppointmentStatusEnum;
import mixture.hutech.backend.enums.BookingTypeEnum;
import mixture.hutech.backend.enums.ErrorCodeEnum;

import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentResponse {
//    @JsonProperty("error_code")
//    private ErrorCodeEnum errorCode;
//    @JsonProperty("message")
//    private String message;
    @JsonProperty("appointment_id")
    private String id;
    @JsonProperty("start_time")
    private LocalTime probableStartTime;
    @JsonProperty("end_time")
    private LocalTime actualEndTime;
    @JsonProperty("taken_date")
    private LocalDate appointmentTakenDate;
    @JsonProperty("type")
    private BookingTypeEnum bookingType;
    @JsonProperty("username")
    private String username;
    @JsonProperty("phone")
    private String phone;
    @JsonProperty("address")
    private String address;
    @JsonProperty("date_of_birth")
    private LocalDate dateOfBirth;
    @JsonProperty("gender")
    private String gender;
    @JsonProperty("email")
    private String email;
    @JsonProperty("doctor_name")
    private String doctorName;
    @JsonProperty("status")
    private AppointmentStatusEnum status;
    @JsonProperty("created_at")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Ho_Chi_Minh")
    private Timestamp createdAt;

    public AppointmentResponse(String appointmentId, LocalTime probableStartTime, LocalTime actualEndTime, LocalDate appointmentTakenDate, String doctorName, AppointmentStatusEnum status, Timestamp createdAt) {
        this.id = appointmentId;
        this.probableStartTime = probableStartTime;
        this.actualEndTime = actualEndTime;
        this.appointmentTakenDate = appointmentTakenDate;
        this.doctorName = doctorName;
        this.status = status;
        this.createdAt = createdAt;
    }
}
