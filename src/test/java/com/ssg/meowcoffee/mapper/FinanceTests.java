package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.InvoiceUpdateDTO;
import com.ssg.meowcoffee.service.FinanceService;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class FinanceTests {

    // ========== Mapper Tests ==========
    @Autowired(required = false)
    private FinanceMapper financeMapper;

    // ---------- Expense ----------
    @Test
    // 지출내역 전체 조회 테스트 -> Check!
    void selectExpensesTest() {
        List<ExpenseVO> list = financeMapper.selectExpenses();
        log.info(list);
    }

    @Test // 지출내역 창고별 조회 테스트 -> Check!
    void selectExpensesByWhIdTest() {
        Long whId = 1L;
        List<ExpenseVO> list = financeMapper.selectExpensesByWhId(whId);
        log.info(list);
    }

    @Test // 지출내역 카테고리별 조회 테스트 -> Check!
    void selectExpensesByCategoryTest() {
        List<ExpenseVO> list = financeMapper.selectExpensesByCategory("management");
        log.info(list);
    }

    @Test // 지출내역 거래처별 조회 테스트 -> Check!
    void selectExpensesByUserIdTest() {
        String userId = "coffeebiz02";
        List<ExpenseVO> list = financeMapper.selectExpensesByUserId(userId);
        log.info(list);
    }

    @Test // 생성 시 카테고리는 관리비 고정 -> Check!
    void insertExpenseTest() {
        ExpenseInputDTO expenseInputDTO = ExpenseInputDTO.builder()
                .totalAmt(new BigDecimal("35000.00"))
                .whId(1L).build();

        int rows = financeMapper.insertExpense(expenseInputDTO);
        log.info(rows);
    }

    @Test // 지출내역 확정 (draft -> posted) -> Check!
    void updateExpensePostedTest() {
        int rows = financeMapper.updateExpensePosted(9L);
        log.info(rows);
    }

    @Test // 지출내역 삭제 (soft delete) -> Check!
    void updateExpenseDeletedTest() {
        int rows = financeMapper.updateExpenseDeleted(9L);
        log.info(rows);
    }

    // ---------- Invoice ----------
    @Test // 청구내역 전체 조회 -> Check!
    void selectInvoicesTest() {
        List<InvoiceVO> list = financeMapper.selectInvoices();
        log.info(list);
    }

    @Test // 청구내역 거래처별 조회 -> Check!
    void selectInvoicesByUserIdTest() {
        String userId = "coffeebiz02";
        List<InvoiceVO> list = financeMapper.selectInvoicesByUserId(userId);
        log.info(list);
    }

    @Test // 청구내역 상태별 조회 -> Check!
    void selectInvoicesByStatusTest() {
        String status = "canceled";
        List<InvoiceVO> list = financeMapper.selectInvoicesByStatus(status);
        log.info(list);
    }

    @Test // 청구내역 상태 변경 -> Check!
    void updateInvoiceStatusTest() {
        InvoiceUpdateDTO invoiceUpdateDTO = InvoiceUpdateDTO.builder()
                .invoiceId(2L)
                .invoiceStatus("canceled").build();

        int rows = financeMapper.updateInvoiceStatus(invoiceUpdateDTO);
        log.info(rows);
    }

    // ---------- Revenue ----------
    @Test // 매출내역 전체 조회 -> Check!
    void selectRevenues() {
        List<RevenueVO> list = financeMapper.selectRevenues();
        log.info(list);
    }


    // ========== Service Tests ==========
    @Autowired
    private FinanceService financeService;

    @Test
    void getExpensesTest(){
        List<ExpenseVO> list = financeService.getExpenses();
        log.info(list);
    }

    @Test
    void getExpensesByWhIdTest(){
        Long whId = 1L;
        List<ExpenseVO> list = financeService.getExpensesByWhId(whId);
        log.info(list);
    }

    @Test
    void getExpensesByCategoryTest(){
        String category = "management";
        List<ExpenseVO> list = financeService.getExpensesByCategory(category);
        log.info(list);
    }

    @Test
    void getExpensesByUserIdTest(){
        String userId = "coffeebiz02";
        List<ExpenseVO> list = financeService.getExpensesByUserId(userId);
        log.info(list);
    }

    @Test
    void registerExpenseTest() {
        ExpenseInputDTO expenseInputDTO = ExpenseInputDTO.builder()
                .totalAmt(new BigDecimal("500000.00"))
                .whId(1L).build();
        long getKey = financeService.registerExpense(expenseInputDTO);
        log.info(getKey);
    }

    @Test
    void modifyExpenseStatusTest() {
        Long expenseId = 7L;
        int raw = financeService.modifyExpenseStatus(expenseId);
        log.info(raw);
    }

    @Test
    void removeExpenseTest() {
        int raw = financeService.removeExpense(7L);
        log.info(raw);
    }

    @Test
    void getInvoicesTest() {
        List<InvoiceVO> list = financeService.getInvoices();
        log.info(list);
    }

    @Test
    void getInvoicesByUserIdTest() {
        String userId = "coffeebiz02";
        List<InvoiceVO> list = financeService.getInvoicesByUserId(userId);
        log.info(list);
    }

    @Test
    void getInvoiceByStatusTest() {
        String status = "paid";
        List<InvoiceVO> list = financeService.getInvoicesByStatus(status);
        log.info(list);
    }

    @Test
    void modifyInvoiceStatusTest() {
        InvoiceUpdateDTO invoiceUpdateDTO = InvoiceUpdateDTO.builder()
                .invoiceId(2L)
                .invoiceStatus("canceled")
                .build();
        int raw = financeService.modifyInvoiceStatus(invoiceUpdateDTO);
        log.info(raw);
    }

    @Test
    void getRevenuesTest() {
        List<RevenueVO> list = financeService.getRevenues();
        log.info(list);
    }
}
