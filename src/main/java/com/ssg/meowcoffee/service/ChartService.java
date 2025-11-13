package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.FinanceChartDTO;
import com.ssg.meowcoffee.dto.InOutChartDTO;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface ChartService {
//     ===== Finance Chart =====
    FinanceChartDTO getFinanceChart();
    Map<String,Object> getKpis();
    List<Map<String,Object>> getMonthlySeries();

//     ===== index Chart =====
    // ── 지출 카드/차트
    BigDecimal getMonthExpenseTotal();      // 지출 차트(KPI)
    int getPendingExpenseCount();           // 지출 차트 보조 KPI
    int getWarehouseCount();                // 지출 카드 보조 KPI

    // ── 청구 카드/차트
    Map<String, Object> getInvoiceKpisForThisMonth(); // 청구 차트(KPI 묶음)

    // ── 매출 라인 차트
    Map<String, Object> getRevenueKpisForThisMonth();       // KPI 카드
    List<Map<String, Object>> getRevenueMonthlySeries();    // Line chart 데이터

    // ── 순이익 카드
    BigDecimal getNetProfitForThisMonth();

    // ── 창고 사용량 도넛 차트
    Map<String, Object> getWarehouseUtilization(); // usedCapa, totalCapa, usageRatePct, unusedCapa 포함

    // ── 최근 한달 입고/출고 수량 현황 (일별 bar/line)
    List<InOutChartDTO> getInDailyRecvStatsForLastMonth();
    List<InOutChartDTO> getOutDailyShipStatsForLastMonth();

    // ── 최근 한달 평균 리드타임(bar chart 또는 숫자 카드)
    Double getAvgInLeadTimeForLastMonth();   // 시간 단위(HOUR)
    Double getAvgOutLeadTimeForLastMonth();  // 시간 단위(HOUR)

    // ── 월별 리드타임 추이(Line chart)
    List<Map<String, Object>> getInboundLeadTimeMonthlySeries();
    List<Map<String, Object>> getOutboundLeadTimeMonthlySeries();
}
