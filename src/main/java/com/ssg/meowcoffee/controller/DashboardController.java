package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.service.ChartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final ChartService chartService;

    // 메인(index.jsp)
    @GetMapping({"/", "/index"})
    public String index(Model model) {
        model.addAttribute("expenseTotal", chartService.getMonthExpenseTotal());
        model.addAttribute("invoiceKpis", chartService.getInvoiceKpisForThisMonth());
        model.addAttribute("revenueKpis", chartService.getRevenueKpisForThisMonth());
        model.addAttribute("netProfit", chartService.getNetProfitForThisMonth());
        return "index"; // /WEB-INF/views/index.jsp
    }
}