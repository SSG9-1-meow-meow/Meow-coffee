package com.ssg.meowcoffee.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class DueDiligenceReadDTO {
    private Long ddId;
    private String stkId;
    private String ddStatus;
    private String ddApproval;
    private LocalDateTime ddDate;
    private String maId;
    private String ddLog;
    private Integer realStkQuantity;
    private LocalDateTime ddUpdateDate;
    private Integer stkQuantity;
    private String zoneName;
    private String rackName;
    private String cellName;
    private String whCode;
}
