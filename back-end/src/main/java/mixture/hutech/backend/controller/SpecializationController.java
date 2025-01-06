package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.AppointmentResponse;
import mixture.hutech.backend.dto.response.DoctorSpecializationResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.dto.response.SpecializationResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.DoctorService;
import mixture.hutech.backend.service.SpecializationService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/specializations")
public class SpecializationController {
    private final SpecializationService specializationService;
    private final DoctorService doctorService;

    @GetMapping
    public ResponseEntity<MessageResponse> listSpecialization() {
        try {
            List<SpecializationResponse> specializationResponse = specializationService.listSpecialization();
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(specializationResponse)
                    .build());
        }catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }

    @GetMapping("/{specializationId}")
    public ResponseEntity<MessageResponse> listDoctorBySpecializationId(@PathVariable String specializationId) {
        try {
            List<DoctorSpecializationResponse> doctorSpecializationResponse = doctorService.listDoctorBySpecializationId(specializationId);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(doctorSpecializationResponse)
                    .build());
        }catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }

}
