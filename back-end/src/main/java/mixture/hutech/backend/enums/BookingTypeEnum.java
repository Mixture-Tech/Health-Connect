package mixture.hutech.backend.enums;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum BookingTypeEnum {
    SELF_BOOKING(1),
    OTHER_BOOKING(2);

    public final int value;
}
