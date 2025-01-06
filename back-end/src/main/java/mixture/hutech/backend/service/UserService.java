package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.request.UserRequest;
import mixture.hutech.backend.dto.response.UserResponse;

import java.util.Optional;

public interface UserService {
    UserResponse getCurrentUserByEmail(String email);
    Optional<UserResponse> getUserProfile(String userId);
    Optional<UserResponse> updateProfile(String userId, UserRequest request);
}
