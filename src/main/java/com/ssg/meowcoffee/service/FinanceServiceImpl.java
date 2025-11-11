package com.ssg.meowcoffee.service;
import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.InvoiceUpdateDTO;
import com.ssg.meowcoffee.mapper.FinanceMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Objects;
@Service
@Log4j2
@RequiredArgsConstructor
public class FinanceServiceImpl implements FinanceService {

    private final FinanceMapper financeMapper;

    // ===== Expense 조회 =====
    @Override // 전체 조회
    public List<ExpenseVO> getExpenses() {
        log.info("getExpenses() 호출");
        return financeMapper.selectExpenses();
    }

    @Override // 창고별 조회
    public List<ExpenseVO> getExpensesByWhId(Long whId) {
        log.info("getExpensesByWhid() 호출");
        Objects.requireNonNull(whId, "whId : 값이 존재하지 않습니다.");
        return financeMapper.selectExpensesByWhId(whId);
    }

    @Override // 카테고리별 조회
    public List<ExpenseVO> getExpensesByCategory(String category) {
        log.info("getExpensesByCategory() 호출");
        Objects.requireNonNull(category, "category : 값이 존재하지 않습니다.");
        return financeMapper.selectExpensesByCategory(category);
    }

    @Override // 거래처별 조회
    public List<ExpenseVO> getExpensesByUserId(String userId) {
        log.info("getExpensesByUserId() 호출");
        Objects.requireNonNull(userId, "userId : 값이 존재하지 않습니다.");
        return financeMapper.selectExpensesByUserId(userId);
    }


    // ===== Expense 생성/수정 =====
    @Override
    public long registerExpense(ExpenseInputDTO expenseInputDTO) {
        log.info("registerExpense() 호출");
        Objects.requireNonNull(expenseInputDTO, "expenseInputDTO : 값이 존재하지 않습니다.");
        financeMapper.insertExpense(expenseInputDTO);
        return expenseInputDTO.getExpenseId();
    }

    @Override
    public int modifyExpenseStatus(Long expenseId) {
        log.info("modifyExpenseStatus() 호출");
        Objects.requireNonNull(expenseId, "expenseId : 값이 존재하지 않습니다.");
        return financeMapper.updateExpensePosted(expenseId);
    }

    @Override
    public int removeExpense(Long expenseId) {
        log.info("removeExpense() 호출");
        Objects.requireNonNull(expenseId, "expenseId : 값이 존재하지 않습니다.");
        return financeMapper.updateExpenseDeleted(expenseId);
    }


    // ===== Invoice =====
    @Override
    public List<InvoiceVO> getInvoices() {
        log.info("getInvoices() 호출");
        return financeMapper.selectInvoices();
    }

    @Override
    public List<InvoiceVO> getInvoicesByUserId(String userId) {
        log.info("getInvoicesByUserId() 호출");
        Objects.requireNonNull(userId, "userId : 값이 존재하지 않습니다.");
        return financeMapper.selectInvoicesByUserId(userId);
    }

    @Override
    public List<InvoiceVO> getInvoicesByStatus(String invoiceStatus) {
        log.info("getInvoicesByStatus() 호출");
        Objects.requireNonNull(invoiceStatus, "invoiceStatus : 값이 존재하지 않습니다.");
        return financeMapper.selectInvoicesByStatus(invoiceStatus);
    }

    @Override
    public int modifyInvoiceStatus(InvoiceUpdateDTO invoiceUpdateDTO) {
        log.info("modifyInvoicesStatus() 호출");
        Objects.requireNonNull(invoiceUpdateDTO, "invoiceUpdateDTO : 값이 존재하지 않습니다.");
        return financeMapper.updateInvoiceStatus(invoiceUpdateDTO);
    }


    // ===== Revenue =====
    @Override
    public List<RevenueVO> getRevenues() {
        log.info("getRevenues() 호출");
        return financeMapper.selectRevenues();
    }
}
