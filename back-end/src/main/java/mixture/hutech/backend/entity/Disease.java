package mixture.hutech.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class Disease {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(name = "disease_name")
    private String diseaseName;

    @ManyToOne
    @JoinColumn(name = "specialization_id")
    private Specialization specialization;
}
