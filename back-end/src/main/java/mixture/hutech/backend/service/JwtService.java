package mixture.hutech.backend.service;

import io.jsonwebtoken.Claims;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Date;
import java.util.Map;
import java.util.function.Function;

public interface JwtService {
    String extractUsername(String jwt);
    <T> T extractClaim(String token, Function<Claims, T> claimsResolver);
    String generateToken(UserDetails userDetails);
    boolean isTokenValid(String token, UserDetails userDetails);
    boolean isTokenExpired(String token);
    Date extractExpiration(String token);
    String generateRefreshToken(UserDetails userDetails);
}
