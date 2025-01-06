package mixture.hutech.backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class Office {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "appointment_duration")
    private Long appointmentDuration;

    @Column(name = "initial_fee")
    private Double initialFee;

    @Column(name = "follow_up_fee")
    private Double followupFee;

    @Column(name = "address")
    private String address;

    @OneToMany(mappedBy = "office")
    private Set<User> users = new HashSet<>();
}
