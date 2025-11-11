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
public class OutboundItemVO {
    private Long outReqItemsId;         //출고 요청 상세 ID
    private Long outReqId;              //출고 요청 ID
    private String stkId;               //재고 ID
    private String vehicleId;           //차량 번호
    private String status;              //출고 상태
    private Integer outQtyReq;          //출고 요청 수량
    private String outOrderAddr;        //출고 지시서 URL
    private LocalDateTime outDttmSchd;  //출고 예정 시각
    private LocalDateTime outDttmInsp;  //검수 시작 시각
    private LocalDateTime outDttmShip;  //출고 완료 시각
}
