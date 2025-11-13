package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.InOutChartDTO;
import com.ssg.meowcoffee.service.ChartService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/charts")
public class ChartApiController {

    private final ChartService chartService;

    // ── 지출
    @GetMapping("/expense/month-total")
    public BigDecimal monthExpenseTotal() { return chartService.getMonthExpenseTotal(); }

    @GetMapping("/expense/pending-count")
    public Integer pendingExpenseCount() { return chartService.getPendingExpenseCount(); }

    @GetMapping("/expense/warehouse-count")
    public Integer warehouseCount() { return chartService.getWarehouseCount(); }

    // ── 청구
    @GetMapping("/invoice/kpis")
    public Map<String, Object> invoiceKpis() { return chartService.getInvoiceKpisForThisMonth(); }

    // ── 매출
    @GetMapping("/revenue/kpis")
    public Map<String, Object> revenueKpis() { return chartService.getRevenueKpisForThisMonth(); }

    @GetMapping("/revenue/monthly-series")
    public List<Map<String, Object>> revenueMonthlySeries() { return chartService.getRevenueMonthlySeries(); }

    // ── 순이익
    @GetMapping("/net-profit")
    public BigDecimal netProfit() { return chartService.getNetProfitForThisMonth(); }

    // ── 창고 사용률
    @GetMapping("/warehouse-utilization")
    public Map<String, Object> warehouseUtilization() { return chartService.getWarehouseUtilization(); }

    // ── 입출고 현황
    @GetMapping("/in/daily-qty-30d")
    public List<InOutChartDTO> inDailyQtyLast30d() { return chartService.getInDailyRecvStatsForLastMonth(); }

    @GetMapping("/out/daily-qty-30d")
    public List<InOutChartDTO> outDailyQtyLast30d() { return chartService.getOutDailyShipStatsForLastMonth(); }

    // ── 평균 리드타임
    @GetMapping("/in/avg-leadtime-30d")
    public Double avgInLeadTime30d() { return chartService.getAvgInLeadTimeForLastMonth(); }

    @GetMapping("/out/avg-leadtime-30d")
    public Double avgOutLeadTime30d() { return chartService.getAvgOutLeadTimeForLastMonth(); }

    // ── 월별 리드타임 추이
    @GetMapping("/in/leadtime-monthly")
    public List<Map<String, Object>> inLeadTimeMonthly() { return chartService.getInboundLeadTimeMonthlySeries(); }

    @GetMapping("/out/leadtime-monthly")
    public List<Map<String, Object>> outLeadTimeMonthly() { return chartService.getOutboundLeadTimeMonthlySeries(); }
}