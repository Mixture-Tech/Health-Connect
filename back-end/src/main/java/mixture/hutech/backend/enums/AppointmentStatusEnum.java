package mixture.hutech.backend.enums;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum AppointmentStatusEnum {
    CONFIRMED(1),
    RESCHEDULED(2),
    CANCELLED(3);

    private final int value;

}
