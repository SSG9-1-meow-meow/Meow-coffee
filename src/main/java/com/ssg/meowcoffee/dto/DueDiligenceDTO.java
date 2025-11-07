package com.ssg.meowcoffee.dto;

import lombok.*;
import org.apache.logging.log4j.core.config.plugins.validation.constraints.NotBlank;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class DueDiligenceDTO {
    private Long ddId;
    private String stkId;
    private Integer stkQuantity;

    @NotBlank(message = "실제 재고 입력은 필수입니다.")
    private Integer realStkQuantity;
    private String ddLog;
    private String whCode;
    private String maId;
}
