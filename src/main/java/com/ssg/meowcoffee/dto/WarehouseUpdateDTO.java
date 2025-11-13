package com.ssg.meowcoffee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.logging.log4j.core.config.plugins.validation.constraints.NotBlank;

import javax.validation.constraints.NotNull;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WarehouseUpdateDTO {

    private String whCode;

    @NotBlank(message = "창고 이름은 필수 입력입니다.")
    private String whName;

    @NotNull(message = "창고 평수는 필수 입력입니다.")
    private Integer whField;

    private String whTelephone;
}
