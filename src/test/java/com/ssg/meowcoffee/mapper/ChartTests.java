package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.dto.InOutChartDTO;
import com.ssg.meowcoffee.service.ChartService;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ChartTests {

    @Autowired(required = false)
    private ChartMapper chartMapper;


    @Test
    void testSelectMonthExpenseTotal() {
        BigDecimal result = chartMapper.selectMonthExpenseTotal();
        log.info("이번 달 지출 합계: ₩" + result);
    }

    @Test
    void testSelectInvoiceKpisForThisMonth() {
        Map<String, Object> result = chartMapper.selectInvoiceKpisForThisMonth();
        log.info("이번 달 청구 KPI: " + result);
    }

    @Test
    void testSelectRevenueKpisForThisMonth() {
        Map<String, Object> result = chartMapper.selectRevenueKpisForThisMonth();
        log.info("이번 달 매출 KPI: " + result);
    }

    @Test
    void testSelectRevenueMonthlySeries() {
        List<Map<String, Object>> list = chartMapper.selectRevenueMonthlySeries();
        log.info("매출 월별 시리즈: " + list);
    }

    @Test
    void testSelectNetProfitForThisMonth() {
        BigDecimal profit = chartMapper.selectNetProfitForThisMonth();
        log.info("이번 달 순이익: ₩" + profit);
    }

    @Test
    void testSelectWarehouseUtilization() {
        Map<String, Object> map = chartMapper.selectWarehouseUtilization();
        log.info("창고 사용률: " + map);
    }

    @Test
    void testSelectInOutDailyStats() {
        List<InOutChartDTO> inList = chartMapper.selectInDailyRecvStatsForLastMonth();
        List<InOutChartDTO> outList = chartMapper.selectOutDailyShipStatsForLastMonth();
        log.info("입고 일별 수량: " + inList);
        log.info("출고 일별 수량: " + outList);
    }

    @Test
    void testSelectAvgLeadTimes() {
        Double inLead = chartMapper.selectAvgInLeadTimeForLastMonth();
        Double outLead = chartMapper.selectAvgOutLeadTimeForLastMonth();
        log.info("입고 리드타임(최근30일): " + inLead + "h");
        log.info("출고 리드타임(최근30일): " + outLead + "h");
    }

    @Test
    void testSelectMonthlyLeadTimeSeries() {
        List<Map<String, Object>> inSeries = chartMapper.selectInboundLeadTimeMonthlySeries();
        List<Map<String, Object>> outSeries = chartMapper.selectOutboundLeadTimeMonthlySeries();
        log.info("입고 월별 리드타임: " + inSeries);
        log.info("출고 월별 리드타임: " + outSeries);
    }

    @Autowired
    ChartService chartService;

    @Test
    void testSelectMonthlyLeadTimeSeries2() {
        List<Map<String, Object>> inSeries = chartMapper.selectInboundLeadTimeMonthlySeries();
        List<Map<String, Object>> outSeries = chartMapper.selectOutboundLeadTimeMonthlySeries();
        log.info(inSeries);
        log.info(outSeries);
    }
}
