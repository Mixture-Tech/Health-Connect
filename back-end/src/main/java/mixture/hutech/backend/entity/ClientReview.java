package mixture.hutech.backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class ClientReview {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(name = "is_review_anonymous")
    private Boolean isReviewAnonymous;

    @Column(name = "wait_time_rating")
    private int waitTimeRating;

    @Column(name = "beside_manner_rating")
    private int bedsideMannersRating;

    @Column(name = "overall_rating")
    private int overallRating;

    private String review;

    @Column(name = "is_doctor_recommended")
    private Boolean isDoctorRecommended;

    @Column(name = "review_date")
    private LocalDate reviewDate;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp createdAt;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp updatedAt;

    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp deletedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = new Timestamp(System.currentTimeMillis());
        updatedAt = new Timestamp(System.currentTimeMillis());
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Timestamp(System.currentTimeMillis());
    }

    @PreRemove
    protected void onDelete() {
        deletedAt = new Timestamp(System.currentTimeMillis());
    }

//    @ManyToOne
//    @JoinColumn(name = "appointment_id")
//    private Appointment appointment;
//
//    @ManyToOne
//    @JoinColumn(name = "doctor_id")
//    private User user;

//    @ManyToOne
//    @JoinColumn(name = "patient_id")
//    private Patient patient;
}
