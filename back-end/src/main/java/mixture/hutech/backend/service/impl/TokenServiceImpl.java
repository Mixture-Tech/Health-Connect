package mixture.hutech.backend.service.impl;

import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.entity.Token;
import mixture.hutech.backend.entity.User;
import mixture.hutech.backend.enums.TokenTypeEnum;
import mixture.hutech.backend.repository.TokenRepository;
import mixture.hutech.backend.service.TokenService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TokenServiceImpl implements TokenService {
    private final TokenRepository tokenRepository;

    @Override
    public void revokeAllUserTokens(User user) {
        var validUserTokens = tokenRepository.findAllValidTokenByUser(user.getId());
        if(validUserTokens.isEmpty()) {
            return;
        }
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }

    @Override
    public void saveUserToken(User user, String jwtToken) {
        var token = Token.builder()
                .user(user)
                .token(jwtToken)
                .tokenTypeEnum(TokenTypeEnum.BEARER)
                .expired(false)
                .revoked(false)
                .build();
        tokenRepository.save(token);
    }
}
