package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.FinanceChartDTO;
import com.ssg.meowcoffee.dto.InOutChartDTO;
import com.ssg.meowcoffee.mapper.ChartMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Log4j2
@RequiredArgsConstructor
public class ChartServiceImpl implements ChartService {

    private final ChartMapper chartMapper;

    @Override
    public FinanceChartDTO getFinanceChart() {
        log.info("getFinanceChart() 호출");
        FinanceChartDTO dto = new FinanceChartDTO();
        dto.setMonthExpenseTotal(chartMapper.selectMonthExpenseTotal());
        dto.setPendingCount(chartMapper.selectPendingExpenseCount());
        dto.setWarehouseCount(chartMapper.selectWarehouseCount());
        return dto;
    }

    @Override
    public Map<String,Object> getKpis() {
        log.info("getKips() 호출");
        Map<String,Object> m = chartMapper.selectRevenueKpisForThisMonth();
        BigDecimal thisM = new BigDecimal(String.valueOf(m.getOrDefault("monthRevenueTotal", 0)));
        BigDecimal prevM = new BigDecimal(String.valueOf(m.getOrDefault("prevMonthTotal", 0)));
        BigDecimal momPct = BigDecimal.ZERO;

        if (prevM.compareTo(BigDecimal.ZERO) > 0) {
            momPct = thisM.subtract(prevM)
                    .divide(prevM, 4, RoundingMode.HALF_UP)
                    .multiply(new BigDecimal("100"));
        }

        Map<String,Object> out = new HashMap<>();
        out.put("monthRevenueTotal", thisM);
        out.put("momRatePct", momPct.setScale(1, RoundingMode.HALF_UP)); // 예: +5.2%
        out.put("revenueCount", m.get("revenueCount")); // whId 없으므로 revenueCount로 변경
        return out;
    }

    @Override
    public List<Map<String,Object>> getMonthlySeries() {
        log.info("getMonthlySeries() 호출");
        return chartMapper.selectRevenueMonthlySeries();
    }

    @Override
    public BigDecimal getMonthExpenseTotal() {
        return chartMapper.selectMonthExpenseTotal();
    }

    @Override
    public int getPendingExpenseCount() {
        Integer v = chartMapper.selectPendingExpenseCount();
        return v == null ? 0 : v;
    }

    @Override
    public int getWarehouseCount() {
        Integer v = chartMapper.selectWarehouseCount();
        return v == null ? 0 : v;
    }

    // ── Invoice KPI set
    @Override
    public Map<String, Object> getInvoiceKpisForThisMonth() {
        return chartMapper.selectInvoiceKpisForThisMonth();
    }

    // ── Revenue
    @Override
    public Map<String, Object> getRevenueKpisForThisMonth() {
        return chartMapper.selectRevenueKpisForThisMonth();
    }

    @Override
    public List<Map<String, Object>> getRevenueMonthlySeries() {
        return chartMapper.selectRevenueMonthlySeries();
    }

    // ── Net Profit
    @Override
    public BigDecimal getNetProfitForThisMonth() {
        return chartMapper.selectNetProfitForThisMonth();
    }

    // ── Warehouse Utilization (Donut chart)
    @Override
    public Map<String, Object> getWarehouseUtilization() {
        Map<String, Object> m = chartMapper.selectWarehouseUtilization(); // usedCapa, totalCapa, usageRatePct
        double used = ((Number) m.getOrDefault("usedCapa", 0)).doubleValue();
        double total = ((Number) m.getOrDefault("totalCapa", 0)).doubleValue();
        double remain = Math.max(total - used, 0);
        // 프론트 도넛 데이터 편의를 위해 unusedCapa 추가
        Map<String, Object> out = new HashMap<>(m);
        out.put("unusedCapa", remain);
        return out;
    }

    // ── In/Out daily stats (Last 30 days)
    @Override
    public List<InOutChartDTO> getInDailyRecvStatsForLastMonth() {
        return chartMapper.selectInDailyRecvStatsForLastMonth();
    }

    @Override
    public List<InOutChartDTO> getOutDailyShipStatsForLastMonth() {
        return chartMapper.selectOutDailyShipStatsForLastMonth();
    }

    // ── Avg lead time (Last 30 days, hour)
    @Override
    public Double getAvgInLeadTimeForLastMonth() {
        return nz(chartMapper.selectAvgInLeadTimeForLastMonth());
    }

    @Override
    public Double getAvgOutLeadTimeForLastMonth() {
        return nz(chartMapper.selectAvgOutLeadTimeForLastMonth());
    }

    // ── Monthly lead time series (12 months)
    @Override
    public List<Map<String, Object>> getInboundLeadTimeMonthlySeries() {
        return chartMapper.selectInboundLeadTimeMonthlySeries();
    }

    @Override
    public List<Map<String, Object>> getOutboundLeadTimeMonthlySeries() {
        return chartMapper.selectOutboundLeadTimeMonthlySeries();
    }

    // ── util
    private Double nz(Double v) { return v == null ? 0d : v; }

}
