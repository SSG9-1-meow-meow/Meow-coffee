package com.ssg.meowcoffee.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class FinanceChartDTO {
    private BigDecimal monthExpenseTotal;   // 이번 달 지출 합계(₩)
    private int pendingCount;         // 승인 대기 건수(draft 등 기준)
    private int warehouseCount;
}
