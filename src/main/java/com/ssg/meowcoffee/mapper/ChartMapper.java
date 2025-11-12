package com.ssg.meowcoffee.mapper;
import com.ssg.meowcoffee.domain.RevenueVO;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
public interface ChartMapper {

    BigDecimal selectMonthExpenseTotal();
    int selectPendingExpenseCount();
    int selectWarehouseCount();

    Map<String,Object> selectInvoiceKpisForThisMonth();

    Map<String,Object> selectRevenueKpisForThisMonth();
    List<Map<String,Object>> selectRevenueMonthlySeries();
}
