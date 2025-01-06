package mixture.hutech.backend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.request.*;
import mixture.hutech.backend.dto.response.AuthenticationResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.entity.CustomUserDetail;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.AuthenticationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/auth")
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationService authenticationService;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(
            @Valid @RequestBody RegisterRequest request
    ){
        try {
            AuthenticationResponse response = authenticationService.register(request);
            return ResponseEntity
                    .status(response.getErrorCode().getHttpStatus())
                    .body(response);
        } catch (ApiException e) {
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(AuthenticationResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }catch (Exception e){
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(AuthenticationResponse.builder()
                            .errorCode(ErrorCodeEnum.REGISTRATION_FAILED)
                            .message(ErrorCodeEnum.REGISTRATION_FAILED.getMessage())
                            .build());
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(
            @RequestBody AuthenticationRequest request
    ){  
        try{
            AuthenticationResponse response = authenticationService.authenticate(request);
            return ResponseEntity
                    .status(response.getErrorCode().getHttpStatus())
                    .body(response);
        }catch (ApiException e){
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(AuthenticationResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }catch (Exception e){
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(AuthenticationResponse.builder()
                            .errorCode(ErrorCodeEnum.AUTHENTICATION_FAILED)
                            .message(ErrorCodeEnum.AUTHENTICATION_FAILED.getMessage())
                            .build());
        }
    }

//    @PostMapping("/verify-email")
//    public ResponseEntity<MessageResponse> verifyEmail(
//            @RequestBody VerifyEmailRequest request
//    ) {
//        try {
//            MessageResponse messageResponse = authenticationService.verifyTokenRegister(request.getToken());
//            return ResponseEntity
//                    .status(messageResponse.getErrorCode().getHttpStatus())
//                    .body(messageResponse);
//        } catch (ApiException e) {
//            return ResponseEntity
//                    .status(e.getErrorCodeEnum().getHttpStatus())
//                    .body(MessageResponse.builder()
//                            .errorCode(e.getErrorCodeEnum())
//                            .message(e.getMessage())
//                            .build());
//        }
//    }

    @PostMapping("/forgot-password")
    public ResponseEntity<MessageResponse> forgotPassword(
            @RequestBody ForgotPasswordRequest request
    ){
        try {
            MessageResponse messageResponse = authenticationService.forgotPassword(request.getEmail());
            return ResponseEntity
                    .status(messageResponse.getErrorCode().getHttpStatus())
                    .body(messageResponse);
        }catch (ApiException e){
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<MessageResponse> changePassword(
            @RequestBody ChangePasswordRequest request,
            @AuthenticationPrincipal CustomUserDetail customUserDetail
            ){
        try{
            String userEmail = customUserDetail.getUsername();
            MessageResponse messageResponse = authenticationService.changePassword(
                    userEmail,
                    request.getCurrentPassword(),
                    request.getNewPassword());
            return ResponseEntity
                    .status(messageResponse.getErrorCode().getHttpStatus())
                    .body(messageResponse);
        }catch (ApiException e){
            return ResponseEntity
                    .status(e.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(e.getErrorCodeEnum())
                            .message(e.getMessage())
                            .build());
        }catch (Exception e){
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(MessageResponse.builder()
                            .errorCode(ErrorCodeEnum.AUTHENTICATION_FAILED)
                            .message(ErrorCodeEnum.AUTHENTICATION_FAILED.getMessage())
                            .build());
        }
    }
}
