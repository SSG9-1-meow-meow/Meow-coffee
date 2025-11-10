package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.InboundStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundItemDTO {

    private Long inReqItemsId;
    private Long inReqId;
    private String cfId;
    private String locationId;
    private InboundStatus status;
    private Integer inQtyReq;
    private String inOrderAddr;
    private Integer inQty;
    private LocalDateTime inDttmSchd;
    private LocalDateTime inDttmInsp;
    private LocalDateTime inDttmRecv;

}