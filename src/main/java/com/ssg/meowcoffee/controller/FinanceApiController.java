package com.ssg.meowcoffee.controller;
import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.ExpenseUpdateDTO;
import com.ssg.meowcoffee.service.FinanceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/finance/api")
public class FinanceApiController {

    private final FinanceService financeService;

    // ───── Expense API ─────
    // 지출 목록 조회
    @GetMapping("/expense")
    public ResponseEntity<List<ExpenseVO>> readExpenseList(
            @RequestParam(required = false) Long whId,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String userId
    ) {
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
        long getExpenseId = financeService.registerExpense(expenseInputDTO);
        return new ResponseEntity<>(getExpenseId, HttpStatus.CREATED);
    }

    // 확정: draft → posted
    @PostMapping("/expense/{eId}")
    public ResponseEntity<Void> postExpense(@PathVariable Long eId) {
        financeService.modifyExpenseStatus(eId);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // 수정: draft만 허용, '관리비' 금액만 수정 가능 -> JSON을 쓸지, (WhID,totalAmt) 따로따로 받을지 결정
    @PutMapping("/expense/{eId}")
    public ResponseEntity<Void> updateExpense(@RequestBody ExpenseUpdateDTO expenseUpdateDTO) {
        financeService.modifyExpense(expenseUpdateDTO);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // soft delete
    @DeleteMapping("/expense/{eId}")
    public ResponseEntity<Void> deleteExpense(@PathVariable Long eId) {
        financeService.removeExpense(eId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
//
//    // ───── Invoice API ─────
//    @GetMapping("/invoice")
//    public ResponseEntity<List<InvoiceVO>> readInvoiceList() {
//        List<InvoiceVO> list = financeService.getInvoices();
//        return new ResponseEntity<>(list, HttpStatus.OK);
//    }
//
//    // ───── Revenue API ─────
//    @GetMapping("/revenue")
//    public ResponseEntity<List<RevenueVO>> readRevenueList() {
//        List<RevenueVO> list = financeService.getRevenues();
//        return new ResponseEntity<>(list, HttpStatus.OK);
//    }
}
