package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.DoctorScheduleResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.entity.DoctorSchedule;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.repository.DoctorScheduleRepository;
import mixture.hutech.backend.service.DoctorScheduleService;
import mixture.hutech.backend.service.DoctorService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/doctor-schedules")
@RequiredArgsConstructor
public class DoctorScheduleController {
    private final DoctorScheduleRepository doctorScheduleRepository;
    private final DoctorScheduleService doctorScheduleService;

    @GetMapping("/{doctorId}")
    public ResponseEntity<MessageResponse> getAllDoctorSchedules(@PathVariable String doctorId){
        try {
            List<DoctorScheduleResponse> doctorScheduleResponses = doctorScheduleService.listDoctorScheduleByDoctorId(doctorId);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(doctorScheduleResponses)
                    .build());
        } catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }
}
