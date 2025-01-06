package mixture.hutech.backend.service;

import mixture.hutech.backend.entity.User;

public interface TokenService {
    void revokeAllUserTokens(User user);
    void saveUserToken(User user, String token);
}
