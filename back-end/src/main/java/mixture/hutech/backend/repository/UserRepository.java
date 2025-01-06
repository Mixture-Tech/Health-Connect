package mixture.hutech.backend.repository;

import mixture.hutech.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.swing.text.html.Option;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u WHERE u.id = :userId")
    Optional<User> findById(String userId);

    Optional<User> findByPhone(String phone);

//    @Query("SELECT u FROM User u WHERE u.role.name = 'DOCTOR'")
//    Optional<User> findDoctorById(String id);
}
