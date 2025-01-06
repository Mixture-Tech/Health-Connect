package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.response.DoctorScheduleResponse;

import java.util.List;

public interface DoctorScheduleService {
    List<DoctorScheduleResponse> listDoctorScheduleByDoctorId(String doctorId);
}
