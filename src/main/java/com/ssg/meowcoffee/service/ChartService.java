package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.FinanceChartDTO;
import java.util.List;
import java.util.Map;

public interface ChartService {
//     ===== Chart =====
    FinanceChartDTO getFinanceChart();
    Map<String,Object> getInvoiceKpisForThisMonth();
    Map<String,Object> getKpis();
    List<Map<String,Object>> getMonthlySeries();
}
