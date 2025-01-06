package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.response.DiseaseResponse;

import java.util.List;

public interface DiseaseService {
    List<DiseaseResponse> listDiseaseBySpecializationId(String specializationId);
}
