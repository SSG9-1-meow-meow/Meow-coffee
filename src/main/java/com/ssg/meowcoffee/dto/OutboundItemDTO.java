package com.ssg.meowcoffee.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OutboundItemDTO {
    private Long   outReqItemsId;
    private Long   outReqId;
    private String stkId;
    private Integer outQtyReq;
    private String  vehicleId;

    /** ▲ 여기!! Enum 말고 String (DB는 '승인대기/승인완료/출고완료/반려') */
    private String status;        // 한글 상태 (테이블 원문)
    private String outOrderAddr;
    private LocalDateTime outDttmSchd;
    private LocalDateTime outDttmInsp;
    private LocalDateTime outDttmShip;

    // 필요하면 프런트 뱃지용 보조필드도 추가 가능(선택)
    // private String statusCode;   // PENDING/APPROVED/SHIPPED/REJECTED
    // private String statusValue;  // 한글표시
}