package mixture.hutech.backend.repository;

import mixture.hutech.backend.dto.response.DiseaseResponse;
import mixture.hutech.backend.entity.Disease;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DiseaseRepository extends JpaRepository<Disease, String> {

    @Query("SELECT new mixture.hutech.backend.dto.response.DiseaseResponse(d.id, d.diseaseName) FROM Disease d WHERE d.specialization.id = :specializationId")
    List<DiseaseResponse> listDiseaseBySpecializationId(String specializationId);
}
