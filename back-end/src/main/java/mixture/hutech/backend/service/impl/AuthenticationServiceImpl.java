package mixture.hutech.backend.service.impl;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.dto.request.AuthenticationRequest;
import mixture.hutech.backend.dto.request.RegisterRequest;
import mixture.hutech.backend.dto.response.AuthenticationResponse;
import mixture.hutech.backend.dto.response.MessageResponse;
import mixture.hutech.backend.entity.CustomUserDetail;
import mixture.hutech.backend.entity.PasswordResetToken;
import mixture.hutech.backend.entity.Role;
import mixture.hutech.backend.entity.User;
import mixture.hutech.backend.enums.ErrorCodeEnum;
import mixture.hutech.backend.enums.PasswordResetTokenEnum;
import mixture.hutech.backend.exceptions.ApiException;
import mixture.hutech.backend.exceptions.ConflictException;
import mixture.hutech.backend.repository.PasswordResetTokenRepository;
import mixture.hutech.backend.repository.RoleRepository;
import mixture.hutech.backend.repository.UserRepository;
import mixture.hutech.backend.service.AuthenticationService;
import mixture.hutech.backend.service.EmailService;
import mixture.hutech.backend.service.JwtService;
import mixture.hutech.backend.service.TokenService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthenticationServiceImpl implements AuthenticationService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final TokenService tokenService;
    private final EmailService emailService;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final SecureRandom secureRandom = new SecureRandom();

    private PasswordResetToken createAndSavePasswordResetToken(User user, PasswordResetTokenEnum tokenType) {
        String token = "MIXTURE_" + UUID.randomUUID().toString() + System.currentTimeMillis();
        PasswordResetToken passwordResetToken = PasswordResetToken.builder()
                .token(token)
                .user(user)
                .tokenType(tokenType)
                .expiryDate(Timestamp.valueOf(LocalDateTime.now().plusHours(24)))
                .build();
        passwordResetTokenRepository.save(passwordResetToken);
        return passwordResetToken;
    }

    @Override
    public AuthenticationResponse register(RegisterRequest request) {
        if(userRepository.findByEmail(request.getEmail()).isPresent()){
            throw new ApiException(ErrorCodeEnum.EMAIL_ALREADY_EXISTS);
        }
        if(userRepository.findByPhone(request.getPhone()).isPresent()){
            throw new ApiException(ErrorCodeEnum.PHONE_ALREADY_EXISTS);
        }
        Role role = roleRepository.findById(request.getRole())
                .orElse(roleRepository.findFirstByOrderByIdAsc());

        var user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .phone(request.getPhone())
                .username(request.getUsername())
                .role(role)
                .isDoctorInfoCompleted(false)
                .build();
        userRepository.save(user);

        PasswordResetToken verificationToken = createAndSavePasswordResetToken(user, PasswordResetTokenEnum.EMAIL_VERIFICATION_TOKEN);

        try{
            emailService.sendMailWithTokenRegister(user.getEmail(), user.getUsername(), verificationToken.getToken());
        }catch (Exception e){
            System.out.println("Mail error: " + e.getMessage());
        }

        return AuthenticationResponse.builder()
                .errorCode(ErrorCodeEnum.OK)
                .message("Registration Successful")
                .accessToken(null)
                .refreshToken(null)
                .build();
    }

    @Override
    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        User user = userRepository.findByEmail(request.getEmail()).orElseThrow(
                () -> new ApiException(ErrorCodeEnum.USER_NOT_FOUND)
        );

        CustomUserDetail userDetails = new CustomUserDetail(user);
        if(!userDetails.isEnabled()){
            throw new ApiException(ErrorCodeEnum.ACCOUNT_NOT_ACTIVATED);
        }

        try{
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getEmail(),
                            request.getPassword()
                    )
            );
        } catch (BadCredentialsException exception){
            throw new ApiException(ErrorCodeEnum.INVALID_CREDENTIALS);
        }

        var jwtToken = jwtService.generateToken(userDetails);
        var refreshToken = jwtService.generateRefreshToken(userDetails);
        tokenService.revokeAllUserTokens(user);
        tokenService.saveUserToken(user, jwtToken);

        return AuthenticationResponse.builder()
                .name(user.getUsername())
                .role(user.getRole().getName())
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .errorCode(ErrorCodeEnum.OK)
                .message("Login Successful")
                .build();
    }

    @Transactional
    @Override
    public MessageResponse verifyTokenRegister(String token) {
        // Tìm token và xử lý lỗi nếu không tồn tại
        PasswordResetToken passwordResetToken = passwordResetTokenRepository
                .findByToken(token)
                .orElseThrow(() -> new ApiException(ErrorCodeEnum.TOKEN_NOT_FOUND));

        // Kiểm tra token đã được kích hoạt chưa
        if (passwordResetToken.isActivated()) {
            throw new ApiException(ErrorCodeEnum.TOKEN_ALREADY_ACTIVATED);
        }

        // Kiểm tra token còn hạn không
        if (passwordResetToken.getExpiryDate().before(new Timestamp(System.currentTimeMillis()))) {
            throw new ApiException(ErrorCodeEnum.TOKEN_EXPIRED);
        }

        try {
            // Kích hoạt tài khoản người dùng
            User user = passwordResetToken.getUser();
            user.setActive(true);
            userRepository.save(user);

            // Đánh dấu token đã được sử dụng
            passwordResetToken.setActivated(true);
            passwordResetTokenRepository.save(passwordResetToken);

            return MessageResponse.builder()
                    .errorCode(ErrorCodeEnum.OK)
                    .message("Xác thực email thành công")
                    .build();

        } catch (Exception e) {
            throw new ApiException(ErrorCodeEnum.VERIFICATION_FAILED);
        }
    }

    @Override
    public MessageResponse forgotPassword(String email) {
        User user = userRepository.findByEmail(email).orElseThrow(
                () -> new ApiException(ErrorCodeEnum.USER_NOT_FOUND)
        );

        // Tạo mã số ngẫu nhiên 10 chữ số bằng SecureRandom
        String randomPassword = "Mixture" + String.format("%010d", Math.abs(secureRandom.nextInt(1000000000)));
        user.setPassword(passwordEncoder.encode(randomPassword));
        userRepository.save(user);

        try {
            // Gửi mã qua email
            emailService.sendMailWithTokenResetPassword(user.getEmail(), user.getUsername(), randomPassword);
        } catch (Exception e) {
            System.out.println("Mail error: " + e.getMessage());
        }

        return MessageResponse.builder()
                .errorCode(ErrorCodeEnum.OK)
                .message("New password has been sent to your email")
                .build();
    }

    @Override
    public MessageResponse changePassword(String userEmail, String currentPassword, String newPassword) {
        // Tìm người dùng dựa trên username
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ApiException(ErrorCodeEnum.USER_NOT_FOUND));

        // Kiểm tra xem mật khẩu hiện tại có đúng không
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new ApiException(ErrorCodeEnum.INVALID_CURRENT_PASSWORD);
        }

        // Cập nhật mật khẩu mới sau khi kiểm tra thành công
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return MessageResponse.builder()
                .errorCode(ErrorCodeEnum.OK)
                .message("Password changed successfully")
                .build();
    }
}
