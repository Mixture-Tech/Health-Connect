package mixture.hutech.backend.service.impl;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.SpecializationResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.repository.SpecializationRepository;
import mixture.hutech.backend.service.SpecializationService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SpecializationServiceImpl implements SpecializationService {
    private final SpecializationRepository specializationRepository;

    @Override
    public List<SpecializationResponse> listSpecialization() {
        if(specializationRepository.findAll().isEmpty()){
            throw new ApiException(ErrorCodeEnum.SPECIALIZATION_NOT_FOUND);
        }
        return specializationRepository.findAllSpecialization();
    }
}
