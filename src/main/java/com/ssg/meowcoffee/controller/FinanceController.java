package com.ssg.meowcoffee.controller;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
@Controller
@RequiredArgsConstructor
@RequestMapping("/finance")
public class FinanceController {

    // ───── Expense 화면 ─────
    @GetMapping("/expense")
    public String expenseList() {
        return "finance/expense/list";
    }

    // ───── Invoice 화면 ─────
    @GetMapping("/invoice")
    public String invoiceList() {
        return "finance/invoice/list";
    }

    // ───── Revenue 화면 ─────
    @GetMapping("/revenue")
    public String revenueList() {
        return "finance/revenue/list";
    }
}
