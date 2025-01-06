package mixture.hutech.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DiseaseResponse {
    @JsonProperty("disease_id")
    private String diseaseId;
    @JsonProperty("disease_name")
    private String diseaseName;
}
