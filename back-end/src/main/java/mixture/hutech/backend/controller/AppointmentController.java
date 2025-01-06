package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.request.AppointmentRequest;
import mixture.hutech.backend.dto.response.AppointmentResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.entity.CustomUserDetail;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.AppointmentService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/appointments")
@RequiredArgsConstructor
@Validated
public class AppointmentController {
    private final AppointmentService appointmentService;

    @PostMapping("/{doctorId}")
    public ResponseEntity<MessageResponse> createAppointment(
            @PathVariable String doctorId,
            @RequestBody AppointmentRequest appointmentRequest,
            @AuthenticationPrincipal CustomUserDetail userDetail) {

        try {
            String currentUserEmail = userDetail.getUsername();
            appointmentRequest.setDoctor(doctorId);

            AppointmentResponse appointmentResponse = appointmentService.createAppointment(appointmentRequest, currentUserEmail);
            return ResponseEntity.ok(
                    MessageResponse.builder()
                            .errorCode(ErrorCodeEnum.OK)
                            .message(ErrorCodeEnum.OK.getMessage())
                            .data(appointmentResponse)
                            .build()
            );
        } catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }

    @PostMapping("/{appointmentId}/cancel")
    public ResponseEntity<MessageResponse> updateAppointment(
            @PathVariable String appointmentId,
            @AuthenticationPrincipal CustomUserDetail userDetail){
        try {
                                    String currentUserEmail = userDetail.getUsername();
            AppointmentResponse appointmentResponse = appointmentService.cancelAppointment(appointmentId, currentUserEmail);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(appointmentResponse)
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

    @GetMapping
    public ResponseEntity<MessageResponse> listAppointmentByUser(
            @AuthenticationPrincipal CustomUserDetail userDetail){
        try {
            String currentUserEmail = userDetail.getUsername();
            List<AppointmentResponse> appointmentResponse = appointmentService.listAppointmentByUser(currentUserEmail);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(appointmentResponse)
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