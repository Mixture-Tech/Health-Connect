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
public class Specialization {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(name = "specialization_name")
    private String specializationName;

    @Column(name = "image_path")
    private String image;

    @OneToMany(mappedBy = "specialization")
    private Set<User> users = new HashSet<>();

    @OneToMany(mappedBy = "specialization", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Disease> diseases = new HashSet<>();
}
