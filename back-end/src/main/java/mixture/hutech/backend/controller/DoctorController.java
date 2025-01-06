package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.DoctorResponse;
import mixture.hutech.backend.dto.response.DoctorSpecializationResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.DoctorService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/doctors")
public class DoctorController {
    private final DoctorService doctorService;

    @GetMapping
    public ResponseEntity<MessageResponse> findAllDoctor(){
        try{
            List<DoctorResponse> doctorResponseList = doctorService.listDoctor();
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(doctorResponseList)
                    .build());
        }
        catch (ApiException e){
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }

    @GetMapping("/search/specialization")
    public ResponseEntity<MessageResponse> findDoctorsBySpecialization(@RequestParam String specializationId) {
        try {
            List<DoctorSpecializationResponse> doctors = doctorService.listDoctorBySpecializationId(specializationId);

            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(doctors)
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

    @GetMapping("/search/name")
    public ResponseEntity<MessageResponse> searchDoctorsByName(@RequestParam String name) {
        try {
            List<DoctorResponse> doctors = doctorService.searchDoctorsByName(name);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(doctors)
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
