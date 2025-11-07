package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundItemVO {

    private Long inReqItemsId;
    private Long inReqId;
    private String cfId;
    private String locationId;
    private String status;
    private Integer inQtyReq;
    private String inOrderAddr;
    private Integer inQty;
    private LocalDateTime inDttmSchd;
    private LocalDateTime inDttmInsp;
    private LocalDateTime inDttmRecv;

}