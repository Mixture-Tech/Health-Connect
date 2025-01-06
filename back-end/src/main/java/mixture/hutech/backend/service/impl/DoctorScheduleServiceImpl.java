package mixture.hutech.backend.service.impl;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.DoctorScheduleResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.repository.DoctorRepository;
import mixture.hutech.backend.repository.DoctorScheduleRepository;
import mixture.hutech.backend.service.DoctorScheduleService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DoctorScheduleServiceImpl implements DoctorScheduleService {
    private final DoctorRepository doctorRepository;
    private final DoctorScheduleRepository doctorScheduleRepository;

    @Override
    public List<DoctorScheduleResponse> listDoctorScheduleByDoctorId(String doctorId) {
        List<DoctorScheduleResponse> doctorScheduleResponses = doctorScheduleRepository.listDoctorScheduleByDoctorId(doctorId);
        if(doctorScheduleResponses.isEmpty()){
            throw new ApiException(ErrorCodeEnum.DOCTOR_SCHEDULE_NOT_FOUND);
        }
        return doctorScheduleResponses;
    }
}
