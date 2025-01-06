package mixture.hutech.backend.repository;

import jakarta.persistence.Id;
import mixture.hutech.backend.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByName(String name);
    Optional<Role> findById(int id);
    Role findFirstByOrderByIdAsc();
}
