package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.ExpenseUpdateDTO;
import com.ssg.meowcoffee.dto.FinanceChartDTO;
import com.ssg.meowcoffee.dto.InvoiceUpdateDTO;
import com.ssg.meowcoffee.service.ChartService;
import com.ssg.meowcoffee.service.FinanceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/finance/api")
public class FinanceApiController {

    private final FinanceService financeService;
    private final ChartService chartService;

    /* =====================================================================
       EXPENSE (지출)
       ===================================================================== */

    // 지출 목록 조회 (조건: whId / category / userId)
    @GetMapping("/expense")
    public ResponseEntity<List<ExpenseVO>> readExpenseList(
            @RequestParam(required = false) Long whId,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String userId
    ) {
        log.info("readExpenseList()");
        List<ExpenseVO> list;
        if (whId != null) {
            list = financeService.getExpensesByWhId(whId);
        } else if (category != null) {
            list = financeService.getExpensesByCategory(category);
        } else if (userId != null) {
            list = financeService.getExpensesByUserId(userId);
        } else {
            list = financeService.getExpenses();
        }
        return ResponseEntity.ok(list);
    }

    // 지출 생성 (관리비 전용)
    @PostMapping("/expense")
    public ResponseEntity<Long> createExpense(@RequestBody ExpenseInputDTO dto) {
        log.info("createExpense()");
        long id = financeService.registerExpense(dto);
        return new ResponseEntity<>(id, HttpStatus.CREATED);
    }

    // 지출 확정(draft → posted)
    @PostMapping("/expense/{eId}")
    public ResponseEntity<Void> postExpense(@PathVariable Long eId) {
        log.info("postExpense()");
        financeService.modifyExpenseStatus(eId);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // 지출 수정 (draft + 관리비만 수정 가능)
    @PutMapping("/expense/{eId}")
    public ResponseEntity<Void> updateExpense(
            @RequestBody ExpenseUpdateDTO dto,
            @PathVariable String eId
    ) {
        log.info("updateExpense()");
        financeService.modifyExpense(dto);
        return ResponseEntity.ok().build();
    }

    // 지출 삭제 (Soft delete)
    @DeleteMapping("/expense/{eId}")
    public ResponseEntity<Void> deleteExpense(@PathVariable Long eId) {
        log.info("deleteExpense()");
        financeService.removeExpense(eId);
        return ResponseEntity.ok().build();
    }


    /* =====================================================================
       INVOICE (청구)
       ===================================================================== */

    private static final Set<String> ALLOWED =
            new HashSet<>(Arrays.asList("draft", "issued", "paid", "canceled"));

    private static boolean hasText(String s) {
        return s != null && !s.trim().isEmpty();
    }

    // 청구 목록 조회 (상태/거래처 필터)
    @GetMapping("/invoice")
    public ResponseEntity<List<InvoiceVO>> readInvoiceList(
            @RequestParam(required = false) String userId,
            @RequestParam(required = false, name = "status") String status
    ) {
        log.info("readInvoiceList()");
        List<InvoiceVO> list;
        if (hasText(userId)) {
            list = financeService.getInvoicesByUserId(userId);
        } else if (hasText(status)) {
            list = financeService.getInvoicesByStatus(status);
        } else {
            list = financeService.getInvoices();
        }
        return ResponseEntity.ok(list);
    }

    // 청구 상태 변경
    @PutMapping("/invoice/{invoiceId}")
    public ResponseEntity<Void> updateInvoiceStatus(
            @PathVariable Long invoiceId,
            @RequestBody InvoiceUpdateDTO dto
    ) {
        log.info("updateInvoiceStatus()");
        dto.setInvoiceId(invoiceId);

        String st = dto.getInvoiceStatus();
        if (!hasText(st) || !ALLOWED.contains(st)) {
            return ResponseEntity.badRequest().build();
        }

        int updated = financeService.modifyInvoiceStatus(dto);
        if (updated == 0) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().build();
    }


    /* =====================================================================
       REVENUE (매출)
       ===================================================================== */

    // 매출 전체 조회
    @GetMapping("/revenue")
    public ResponseEntity<List<RevenueVO>> readRevenueList() {
        log.info("readRevenueList()");
        return ResponseEntity.ok(financeService.getRevenues());
    }


    /* =====================================================================
       DASHBOARD & KPI CHARTS
       ===================================================================== */

    // 지출 KPI (이번 달 합계, pending 등)
    @GetMapping("/expenseChart")
    public ResponseEntity<FinanceChartDTO> getExpenseChart() {
        log.info("getExpenseChart()");
        return ResponseEntity.ok(chartService.getFinanceChart());
    }

    // 청구 KPI
    @GetMapping("/invoiceChart")
    public ResponseEntity<Map<String, Object>> getInvoiceChart() {
        log.info("getInvoiceChart()");
        return ResponseEntity.ok(chartService.getInvoiceKpisForThisMonth());
    }

    // 매출 KPI (월 총액, MoM 변화율)
    @GetMapping("/revenueChart1")
    public ResponseEntity<Map<String, Object>> getRevenueChart1() {
        log.info("getRevenueChart1()");
        return ResponseEntity.ok(chartService.getKpis());
    }

    // 월별 매출 그래프 데이터
    @GetMapping("/revenueChart2")
    public ResponseEntity<List<Map<String, Object>>> getRevenueChart2() {
        log.info("getRevenueChart2()");
        return ResponseEntity.ok(chartService.getMonthlySeries());
    }

    // 창고 목록 조회 (필터용)
    @GetMapping("/warehouses")
    public ResponseEntity<List<Map<String, Object>>> readWarehouseList() {
        return ResponseEntity.ok(financeService.getWarehouses());
    }
}