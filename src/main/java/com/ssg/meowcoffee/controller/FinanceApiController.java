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
import java.net.URI;
import java.util.*;

@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/finance/api")
public class FinanceApiController {

    private final FinanceService financeService;

    private final ChartService chartService;

    // ───── Expense API ─────
    // 지출 목록 조회
    @GetMapping("/expense")
    public ResponseEntity<List<ExpenseVO>> readExpenseList(
            @RequestParam(required = false) Long whId,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String userId
    ) {
        log.info("readExpenseList() 호출");
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


    // 생성: 관리비 전용, 모달로 작성
    @PostMapping("/expense")
    public ResponseEntity<Long> createExpense(@RequestBody ExpenseInputDTO expenseInputDTO) {
        log.info("createExpense() 호출");
        long getExpenseId = financeService.registerExpense(expenseInputDTO);
        return new ResponseEntity<>(getExpenseId, HttpStatus.CREATED);
    }

    // 확정: draft → posted
    @PostMapping("/expense/{eId}")
    public ResponseEntity<Void> postExpense(@PathVariable Long eId) {
        log.info("postExpense() 호출");
        financeService.modifyExpenseStatus(eId);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // 수정: draft만 허용, '관리비' 금액만 수정 가능 -> JSON을 쓸지, (WhID,totalAmt) 따로따로 받을지 결정
    @PutMapping("/expense/{eId}")
    public ResponseEntity<Void> updateExpense(@RequestBody ExpenseUpdateDTO expenseUpdateDTO) {
        log.info("updateExpense() 호출");
        financeService.modifyExpense(expenseUpdateDTO);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // soft delete
    @DeleteMapping("/expense/{eId}")
    public ResponseEntity<Void> deleteExpense(@PathVariable Long eId) {
        log.info("deleteExpense() 호출");
        financeService.removeExpense(eId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // ───── Invoice API ─────
    private static final Set<String> ALLOWED =
            new HashSet<>(Arrays.asList("draft","issued","paid","canceled"));

    private static boolean hasText(String s) {
        return s != null && !s.trim().isEmpty();
    }

    // ───── Invoice 목록 조회 ─────
    @GetMapping("/invoice")
    public ResponseEntity<List<InvoiceVO>> readInvoiceList(
            @RequestParam(required = false) String userId,
            @RequestParam(required = false, name = "status") String invoiceStatus
    ) {
        log.info("readInvoiceList() 호출");
        List<InvoiceVO> list;
        if (hasText(userId)) {
            list = financeService.getInvoicesByUserId(userId);
        } else if (hasText(invoiceStatus)) {
            list = financeService.getInvoicesByStatus(invoiceStatus);
        } else {
            list = financeService.getInvoices();
        }
        return ResponseEntity.ok(list);
    }

    // ───── Invoice 상태 변경 ─────
    // PUT /finance/api/invoice/{invoiceId}
    // body: { "invoiceStatus": "issued" }  // 필요 시 memo 등 추가 가능
    @PutMapping("/invoice/{invoiceId}")
    public ResponseEntity<Void> updateInvoiceStatus(
            @PathVariable Long invoiceId,
            @RequestBody InvoiceUpdateDTO dto
    ) {
        log.info("updateInvoiceStatus() 호출");
        // path 변수 우선 적용
        dto.setInvoiceId(invoiceId);

        // 상태 값 검증
        String st = dto.getInvoiceStatus();
        if (!hasText(st) || !ALLOWED.contains(st)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

        int updated = financeService.modifyInvoiceStatus(dto);
        if (updated == 0) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok().build();
    }

    // ───── Revenue API ─────
    @GetMapping("/revenue")
    public ResponseEntity<List<RevenueVO>> readRevenueList() {
        log.info("readRevenueList() 호출");
        List<RevenueVO> list = financeService.getRevenues();
        return ResponseEntity.ok(list);
    }


    // ───── Chart API ─────
    @GetMapping("/expenseChart")
    public ResponseEntity<FinanceChartDTO> getExpenseChart() {
        log.info("getExpenseChart() 호출");
        return ResponseEntity.ok(chartService.getFinanceChart());
    }

    @GetMapping("/invoiceChart")
    public ResponseEntity<Map<String,Object>> getInvoiceChart() {
        log.info("getInvoiceChart() 호출");
        Map<String,Object> m = chartService.getInvoiceKpisForThisMonth();
        return ResponseEntity.ok(m);
    }

    @GetMapping("/revenueChart1")
    public ResponseEntity<Map<String,Object>> getRevenueChart1() {
        log.info("getRevenueChart1() 호출");
        return ResponseEntity.ok(chartService.getKpis());
    }

    @GetMapping("/revenueChart2")
    public ResponseEntity<List<Map<String,Object>>> getRevenueChart2() {
        log.info("getRevenueChart2() 호출");
        return ResponseEntity.ok(chartService.getMonthlySeries());
    }

}
