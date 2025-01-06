package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.request.AuthenticationRequest;
import mixture.hutech.backend.dto.request.RegisterRequest;
import mixture.hutech.backend.dto.response.AuthenticationResponse;
import mixture.hutech.backend.dto.response.MessageResponse;

public interface AuthenticationService {
    AuthenticationResponse register(RegisterRequest request);
    AuthenticationResponse authenticate(AuthenticationRequest request);
    MessageResponse verifyTokenRegister(String token);
    MessageResponse forgotPassword(String email);
    MessageResponse changePassword(String userEmail, String currentPassword, String newPassword);
}
