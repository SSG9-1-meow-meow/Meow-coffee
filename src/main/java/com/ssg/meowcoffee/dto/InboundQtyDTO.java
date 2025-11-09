package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 입고 수량 정보(요청량, 실제량) 조회를 위한 DTO
 */
@Data
@NoArgsConstructor
public class InboundQtyDTO {
    private Integer inQtyReq;
    /**
     * 관리자가 입력한 실제 입고 수량 (입력 전일 경우 null)
     */
    private Integer inQty;
}
