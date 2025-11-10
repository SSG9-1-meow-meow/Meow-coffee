package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.OutboundStatus;
import lombok.*;

import java.time.LocalDateTime;

// 관리자/회원 출고 관리 UI용 DTO (ERD 기반)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundReqItemDTO {

    private Long outReqId;          // 출고 요청 ID
    private String comName;         // 거래처명
    private String stkId;           // 재고 ID
    private String vehicleId;       // 차량 ID
    private Integer outQtyReq;      // 요청 수량
    private Integer outQty;         // 출고 수량
    private OutboundStatus status;  // 출고 상태 (ENUM)
    private LocalDateTime outDttmReq;   // 출고 요청 일시
    private LocalDateTime outDttmAppr;  // 출고 승인 일시
    private Integer isTempo;        // 임시 저장 여부
}