package com.ssg.meowcoffee.dto;

import lombok.*;
import org.apache.logging.log4j.core.config.plugins.validation.constraints.NotBlank;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WarehouseDTO {
    private Long whId;

    @NotBlank(message = "창고 이름은 필수 입력입니다.")
    private String whName;

    @NotBlank(message = "창고 주소는 필수 입력입니다.")
    private String whAddress;

    private String whTelephone;

    @NotBlank(message = "창고 등급은 필수 입력입니다.")
    private String whGrade;

    @NotBlank(message = "창고 평수는 필수 입력입니다.")
    private Integer whField;

    @NotBlank(message = "창고 최대 수용용량은 필수 입력입니다.")
    private Integer whTotalCapa;

    private Integer whUseCapa;
}