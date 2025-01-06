package mixture.hutech.backend.repository;

import mixture.hutech.backend.dto.response.SpecializationResponse;
import mixture.hutech.backend.entity.Specialization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpecializationRepository extends JpaRepository<Specialization, String> {

    @Query("SELECT new mixture.hutech.backend.dto.response.SpecializationResponse(s.id, s.specializationName, s.image) FROM Specialization s")
    List<SpecializationResponse> findAllSpecialization();
}
