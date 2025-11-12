package com.ssg.meowcoffee.service;
import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.ExpenseUpdateDTO;
import com.ssg.meowcoffee.dto.InvoiceUpdateDTO;
import java.util.List;
public interface FinanceService {

    // ===== Expense 조회 =====
    List<ExpenseVO> getExpenses();                         // 전체
    List<ExpenseVO> getExpensesByWhId(Long whId);          // 창고별
    List<ExpenseVO> getExpensesByCategory(String category);// 카테고리별
    List<ExpenseVO> getExpensesByUserId(String userId);    // 거래처별

    // ===== Expense 생성/수정 =====
    long registerExpense(ExpenseInputDTO expenseInputDTO);            // 카테고리 'management' 고정
    int modifyExpense(ExpenseUpdateDTO expenseUpdateDTO);
    int modifyExpenseStatus(Long expenseId);                          // draft|posted
    int removeExpense(Long expenseId);

    // ===== Invoice 조회/수정 =====
    List<InvoiceVO> getInvoices();                                // 전체
    List<InvoiceVO> getInvoicesByUserId(String userId);           // 거래처별
    List<InvoiceVO> getInvoicesByStatus(String invoiceStatus);    // 상태별
    int modifyInvoiceStatus(InvoiceUpdateDTO invoiceUpdateDTO);   // draft|issued|paid|canceled

    // ===== Revenue 조회 =====
    List<RevenueVO> getRevenues();                         // 전체
}
