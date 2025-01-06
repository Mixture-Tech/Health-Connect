package mixture.hutech.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.PastOrPresent;
import lombok.*;

import java.time.LocalDate;

@Entity
@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class Qualification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name = "institute_name")
    private String instituteName;

    @Column(name = "practicing_from")
    @PastOrPresent(message = "Practicing from date must be in the past or present")
    private LocalDate procurementYear;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
