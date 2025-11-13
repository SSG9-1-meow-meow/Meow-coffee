package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.InboundStatus; // Enum import
import java.time.LocalDateTime;
import javax.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InboundApprovalDTO {
    @NotNull
    private Long inReqItemsId;

    @NotNull
    private String managerId;

    @NotNull
    private InboundStatus newStatus;

    // 승인 시 필수
    private String locationId;
    private LocalDateTime inDttmSchd;

    @NotNull
    private Integer isTempo; // 0 또는 1
}