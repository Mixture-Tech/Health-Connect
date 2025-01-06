package mixture.hutech.backend.repository;

import mixture.hutech.backend.dto.response.DoctorResponse;
import mixture.hutech.backend.dto.response.DoctorScheduleResponse;
import mixture.hutech.backend.dto.response.DoctorSpecializationResponse;
import mixture.hutech.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends JpaRepository<User, String> {

    @Query("""
        SELECT NEW mixture.hutech.backend.dto.response.DoctorResponse(
            u.id, 
            u.username, 
            u.professionalStatement, 
            u.avatar,
            u.specialization.specializationName
        )
        FROM User u
        WHERE u.role.name = 'DOCTOR'
    """)
    List<DoctorResponse> findAllDoctor();

    @Query("SELECT u FROM User u WHERE u.role.name = 'DOCTOR' AND u.id = :doctorId")
    Optional<User> findDoctorById(String doctorId);

    @Query("SELECT new mixture.hutech.backend.dto.response.DoctorScheduleResponse(ds.id, ds.dayOfWeek, ds.startTime, ds.endTime, ds.workingDate, ds.user.username) " +
            "FROM User u JOIN DoctorSchedule ds " +
            "ON u.id = ds.user.id " +
            "WHERE u.role.name = 'DOCTOR' " +
            "AND u.specialization.id = :specializationId " +
            "AND ds.currentAppointment < 3 " +
            "ORDER BY ds.id, ds.workingDate, ds.dayOfWeek, ds.startTime"
    )
    List<DoctorScheduleResponse> listDoctorScheduleBySpecializationId(String specializationId);

    @Query("SELECT new mixture.hutech.backend.dto.response.DoctorSpecializationResponse(u.id, u.username, u.professionalStatement, u.avatar, null) " +
            "FROM User u " +
            "WHERE u.role.name = 'DOCTOR' " +
            "AND  u.specialization.id = :specializationId"
    )
    List<DoctorSpecializationResponse> listDoctorsBySpecializationId(String specializationId);

    @Query("SELECT new mixture.hutech.backend.dto.response.DoctorResponse(u.id, u.username, u.description, u.avatar) " +
            "FROM User u WHERE u.role.name = 'DOCTOR' " +
            "AND LOWER(u.username) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<DoctorResponse> searchDoctorsByName(String name);

}
