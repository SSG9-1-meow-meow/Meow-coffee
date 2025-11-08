package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 일별/월별 차트 데이터 조회를 위한 DTO
 */
@Data
@NoArgsConstructor
public class InOutChartDTO {
    /**
     * 차트의 X축 레이블 (예: "2025-10-28", "2025-10")
     */
    private String chartKey;

    /**
     * 차트의 Y축 값 (집계된 수량)
     */
    private double totalQuantity;
}
