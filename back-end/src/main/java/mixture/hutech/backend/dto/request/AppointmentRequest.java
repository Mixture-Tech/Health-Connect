package mixture.hutech.backend.dto.request;

import jakarta.persistence.*;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import mixture.hutech.backend.entity.DoctorSchedule;
import mixture.hutech.backend.entity.User;
import mixture.hutech.backend.enums.AppointmentStatusEnum;
import mixture.hutech.backend.enums.BookingTypeEnum;
import org.hibernate.validator.constraints.Length;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentRequest {
//    private LocalTime probableStartTime;
//    private LocalTime actualEndTime;
//    private LocalDate appointmentTakenDate;
//    private BookingTypeEnum bookingType;
//    private String username;
//    private String phone;
//    private String address;
//    private LocalDate dateOfBirth;
//    private String gender;
//    private User user;
//    private DoctorSchedule doctorSchedule;
//    private AppointmentStatusEnum status;

    private String doctor;
    private LocalDate appointmentTakenDate;
    private LocalDate appointmentBookedDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private BookingTypeEnum bookingType;

    // Thông tin người bệnh (nếu đặt cho người khác)
    private String patientName;
    private String patientPhone;
    private String patientAddress;
    private LocalDate patientDateOfBirth;
    private String patientGender;
    private AppointmentStatusEnum status;
}
