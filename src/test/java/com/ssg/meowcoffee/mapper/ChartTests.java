package com.ssg.meowcoffee.mapper;

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
    public void selectMonthExpenseTotalTest() {
        BigDecimal count = chartMapper.selectMonthExpenseTotal();
        log.info("count:{}", count);
    }

    @Test
    public void selectPendingCount() {
        int count = chartMapper.selectPendingExpenseCount();
        log.info("count:{}", count);
    }

    @Test
    public void selectWareHouseTest() {
        int count = chartMapper.selectWarehouseCount();
        log.info("count:{}", count);
    }

    @Test
    public void selectInvoiceKpisForThisMonth() {
        Map<String, Object> map = chartMapper.selectInvoiceKpisForThisMonth();
        log.info("map:{}", map);
    }

    @Test
    public void selectRevenueKpisForThisMonth(){
        Map<String, Object> map = chartMapper.selectRevenueKpisForThisMonth();
        log.info("map:{}", map);
    }

    @Test
    public void selectRevenueMonthlySeries(){
        List<Map<String,Object>> list = chartMapper.selectRevenueMonthlySeries();
        log.info("list:{}", list);
    }
}
