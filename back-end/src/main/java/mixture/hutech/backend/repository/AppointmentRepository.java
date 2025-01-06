package mixture.hutech.backend.repository;

import mixture.hutech.backend.dto.response.AppointmentResponse;
import mixture.hutech.backend.entity.Appointment;
import mixture.hutech.backend.enums.AppointmentStatusEnum;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, String> {
    Optional<Appointment> findById(String id);

    @Query("SELECT a FROM Appointment a WHERE a.user.id = :userId")
    List<Appointment> findByUserId(String userId);

    @Query("SELECT a FROM Appointment a " +
            "WHERE a.appointmentTakenDate = CURRENT_DATE " +
            "AND a.probableStartTime BETWEEN ?1 AND ?2 " +
            "AND a.appointmentStatus = ?3 " +
            "AND (a.reminderSent = false OR a.reminderSent IS NULL)")
    List<Appointment> findUpcomingAppointments(LocalTime start, LocalTime end, AppointmentStatusEnum status);

    @Query("SELECT new mixture.hutech.backend.dto.response.AppointmentResponse(a.id,a.probableStartTime,a.actualEndTime,a.appointmentTakenDate,a.doctorSchedule.user.username,a.appointmentStatus,a.createdAt) FROM Appointment a WHERE a.user.email = :userId")
    List<AppointmentResponse> listAppointmentByUserId(String userId);
}
