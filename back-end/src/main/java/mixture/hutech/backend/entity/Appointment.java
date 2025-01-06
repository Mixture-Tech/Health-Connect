package mixture.hutech.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import mixture.hutech.backend.enums.AppointmentStatusEnum;
import mixture.hutech.backend.enums.BookingTypeEnum;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.enums.PasswordResetTokenEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.utils.DateTimeUtils;
import org.hibernate.validator.constraints.Length;
import org.springframework.cglib.core.Local;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
@Table
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(name = "probable_start_time")
    private LocalTime probableStartTime;

    @Column(name = "actual_end_time")
    private LocalTime actualEndTime;

    @Column(name = "appointment_taken_date")
    private LocalDate appointmentTakenDate;

    @Column(name = "appointment_booked_date")
    private LocalDateTime appointmentBookedDate;

//    @Column(name = "is_self_booking", nullable = false)
//    private Boolean isSelfBooking;

    @Enumerated(EnumType.STRING)
    public AppointmentStatusEnum appointmentStatus;

    @Enumerated(EnumType.STRING)
    private BookingTypeEnum bookingType = BookingTypeEnum.SELF_BOOKING;

    @Column(name = "username")
    private String username;

    @Column(name = "phone", length = 10)
    @Length(min = 10, max = 10, message = "Phone must be 10 characters")
    @Pattern(regexp = "^[0-9]*$", message = "Phone must be number")
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "gender")
    private String gender;

    @Column(name = "reminder_sent")
    private Boolean reminderSent = false;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp createdAt;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp updatedAt;

    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp deletedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = new Timestamp(System.currentTimeMillis());
        updatedAt = new Timestamp(System.currentTimeMillis());
        if (id == null) {
            id = UUID.randomUUID().toString();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Timestamp(System.currentTimeMillis());
    }

    @PreRemove
    protected void onDelete() {
        deletedAt = new Timestamp(System.currentTimeMillis());
    }

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "doctor_schedule_id")
    private DoctorSchedule doctorSchedule;

//    public void setAppointmentTakenDate(LocalDate appointmentTakenDate) {
//        this.appointmentTakenDate = DateTimeUtils.p
//    }
}
