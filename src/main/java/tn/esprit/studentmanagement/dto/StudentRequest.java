package tn.esprit.studentmanagement.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Payload used to create or update a student")
public class StudentRequest {
    @Schema(description = "Set only when updating an existing student", example = "1", nullable = true)
    private Long idStudent;

    @Schema(example = "John")
    private String firstName;

    @Schema(example = "Doe")
    private String lastName;

    @Schema(example = "john.doe@example.com")
    private String email;

    @Schema(example = "+21612345678")
    private String phone;

    @Schema(example = "2001-05-20")
    private LocalDate dateOfBirth;

    @Schema(example = "Tunis")
    private String address;

    @Schema(description = "Optional existing department id", example = "1", nullable = true)
    private Long departmentId;
}
