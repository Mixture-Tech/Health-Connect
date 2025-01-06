package mixture.hutech.backend.controller;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.request.UserRequest;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.dto.response.UserResponse;
import mixture.hutech.backend.entity.CustomUserDetail;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/user")
public class UserController {
    private final UserService userService;

    @GetMapping("/getUser/{email}")
    public ResponseEntity<MessageResponse> getCurrentUserByEmail(@PathVariable String email){
        try {
            UserResponse userResponse = userService.getCurrentUserByEmail(email);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(userResponse)
                    .build());
        } catch (ApiException ex){
            return ResponseEntity
                    .status(ex.getErrorCodeEnum().getHttpStatus())
                    .body(MessageResponse.builder()
                            .errorCode(ex.getErrorCodeEnum())
                            .message(ex.getMessage())
                            .build());
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<MessageResponse> getCurrentUser(@AuthenticationPrincipal CustomUserDetail userDetail) {
        try {
            String currentUserEmail = userDetail.getUsername();
            Optional<UserResponse> userResponse = userService.getUserProfile(currentUserEmail);

            return ResponseEntity.ok(
                    MessageResponse.builder()
                            .errorCode(ErrorCodeEnum.OK)
                            .message(ErrorCodeEnum.OK.getMessage())
                            .data(userResponse)
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

    @PostMapping("/update")
    public ResponseEntity<MessageResponse> editProfile(
            @AuthenticationPrincipal CustomUserDetail userDetail,
            @RequestBody UserRequest request) {
        try {
            String userEmail = userDetail.getUsername();
            Optional<UserResponse> updatedUser = userService.updateProfile(userEmail, request);
            return ResponseEntity.ok(MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message(ErrorCodeEnum.OK.getMessage())
                    .data(updatedUser.get())
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
}
