package mixture.hutech.backend.enums;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum PasswordResetTokenEnum {
    EMAIL_VERIFICATION_TOKEN(1),
    PASSWORD_RESET_TOKEN(2);

    public final int value;
}
