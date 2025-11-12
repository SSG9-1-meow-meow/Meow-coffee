package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.FinanceChartDTO;
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
    public Map<String,Object> getInvoiceKpisForThisMonth() {
        log.info("getInvoiceKpisForThisMonth() 호출");
        return chartMapper.selectInvoiceKpisForThisMonth();
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

}
