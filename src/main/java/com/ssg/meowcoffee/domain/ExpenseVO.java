package com.ssg.meowcoffee.domain;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ExpenseVO {
    private Long expenseId;
    private LocalDate expenseDt;
    private String expenseCategory;
    private BigDecimal totalAmt;
    private String expenseStatus;
    private LocalDate confirmDt;
    private boolean isDelete;
    private Long whId;
    private String userId;

    public boolean getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean b) {
    }


    // 생성은 totalAmt, whId 값만 필요
}

