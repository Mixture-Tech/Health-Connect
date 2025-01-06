package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.response.DiseaseResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.DiseaseService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/diseases")
public class DiseaseController {
    private final DiseaseService diseaseService;

    @GetMapping("/{specializationId}")
    public ResponseEntity<MessageResponse> listDiseaseBySpecialization(@PathVariable String specializationId){
        try {
            List<DiseaseResponse> diseaseResponseList = diseaseService.listDiseaseBySpecializationId(specializationId);
            return ResponseEntity.ok(MessageResponse.builder()
                            .errorCode(ErrorCodeEnum.OK)
                            .message(ErrorCodeEnum.OK.getMessage())
                            .data(diseaseResponseList)
                    .build());
        }
        catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }
}
