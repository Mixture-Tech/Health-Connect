package mixture.hutech.backend.service.impl;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.request.UserRequest;
import mixture.hutech.backend.dto.request.UserRequest;
import mixture.hutech.backend.dto.response.UserResponse;
import mixture.hutech.backend.entity.Appointment;
import mixture.hutech.backend.entity.User;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.repository.UserRepository;
import mixture.hutech.backend.service.UserService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public UserResponse getCurrentUserByEmail(String email) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            throw new ApiException(ErrorCodeEnum.USER_NOT_FOUND);
        }
        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .username(user.getUsername())
                .phone(user.getPhone())
                .dateOfBirth(user.getDateOfBirth())
                .address(user.getAddress())
                .gender(user.getGender())
                .build();
    }
    public Optional<UserResponse> getUserProfile(String email) {
        return userRepository.findByEmail(email).map(user -> new UserResponse(
                null,
                null,
                user.getUsername(),
                null,
                user.getAddress(),
                user.getDateOfBirth(),
                user.getGender()
        ));
    }

    @Override
    public Optional<UserResponse> updateProfile(String email, UserRequest request) {
        Optional<User> optionalUser = userRepository.findByEmail(email);
        User user = optionalUser.get();
        user.setUsername(request.getUsername());
        user.setDateOfBirth(request.getDateOfBirth());
        user.setGender(request.getGender());
        user.setAddress(request.getAddress());
        userRepository.save(user); // Lưu thay đổi
        return Optional.of(new UserResponse(
                null,
                null, // email
                user.getUsername(),
                null, // phone
                user.getAddress(),
                user.getDateOfBirth(),
                user.getGender()
        ));
    }
}