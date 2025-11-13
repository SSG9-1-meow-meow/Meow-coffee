package com.ssg.meowcoffee.mapper;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.InOutChartDTO;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
public interface ChartMapper {

    // Expense
    BigDecimal selectMonthExpenseTotal();
    Integer selectPendingExpenseCount();
    Integer selectWarehouseCount();

    // Invoice
    Map<String, Object> selectInvoiceKpisForThisMonth();

    // Revenue
    Map<String, Object> selectRevenueKpisForThisMonth();
    List<Map<String, Object>> selectRevenueMonthlySeries();

    // Net Profit
    BigDecimal selectNetProfitForThisMonth();

    // Warehouse Utilization
    Map<String, Object> selectWarehouseUtilization();

    // Inbound / Outbound daily stats (30 days)
    List<InOutChartDTO> selectInDailyRecvStatsForLastMonth();
    List<InOutChartDTO> selectOutDailyShipStatsForLastMonth();

    // Avg lead time (30 days)
    Double selectAvgInLeadTimeForLastMonth();
    Double selectAvgOutLeadTimeForLastMonth();

    // Monthly lead time series (12 months)
    List<Map<String, Object>> selectInboundLeadTimeMonthlySeries();
    List<Map<String, Object>> selectOutboundLeadTimeMonthlySeries();
}
