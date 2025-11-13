package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.ExpenseVO;
import com.ssg.meowcoffee.domain.InvoiceVO;
import com.ssg.meowcoffee.domain.RevenueVO;
import com.ssg.meowcoffee.dto.ExpenseInputDTO;
import com.ssg.meowcoffee.dto.ExpenseUpdateDTO;
import com.ssg.meowcoffee.dto.InvoiceUpdateDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Mapper
public interface FinanceMapper {

    // ===== Expense 조회 (삭제된 건 제외) =====
    List<ExpenseVO> selectExpenses();

    List<ExpenseVO> selectExpensesByWhId(@Param("whId") Long whId);

    List<ExpenseVO> selectExpensesByCategory(@Param("expenseCategory") String expenseCategory);

    List<ExpenseVO> selectExpensesByUserId(@Param("userId") String userId);

    // ===== Expense 생성/수정 =====
    int insertExpense(ExpenseInputDTO expenseInputDTO); // 생성 시 카테고리 ‘management’ 고정

    int updateExpense(ExpenseUpdateDTO expenseUpdateDTO);

    int updateExpensePosted(@Param("expenseId") Long expenseId);

    int updateExpenseDeleted(@Param("expenseId") Long expenseId);

    // ===== Invoice 조회 =====
    List<InvoiceVO> selectInvoices();

    List<InvoiceVO> selectInvoicesByUserId(@Param("userId") String userId);

    List<InvoiceVO> selectInvoicesByStatus(@Param("invoiceStatus") String invoiceStatus);

    // ===== Invoice 수정 =====
    int updateInvoiceStatus(InvoiceUpdateDTO invoiceUpdateDTO); // draft|issued|paid|canceled

    // ===== Revenue 조회 =====
    List<RevenueVO> selectRevenues(); // 전체

    List<Map<String, Object>> selectWarehouses();
}
