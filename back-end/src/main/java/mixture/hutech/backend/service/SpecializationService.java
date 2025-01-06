package mixture.hutech.backend.service;


import mixture.hutech.backend.dto.response.SpecializationResponse;

import java.util.ArrayList;
import java.util.List;

public interface SpecializationService {
    List<SpecializationResponse> listSpecialization();
}
