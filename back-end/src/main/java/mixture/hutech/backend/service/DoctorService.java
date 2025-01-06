package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.response.DoctorResponse;
import mixture.hutech.backend.dto.response.DoctorSpecializationResponse;

import java.util.List;

public interface DoctorService {
    List<DoctorResponse> listDoctor();
    List<DoctorResponse> searchDoctorsByName(String name);
    List<DoctorSpecializationResponse> listDoctorBySpecializationId(String specializationId);
}
