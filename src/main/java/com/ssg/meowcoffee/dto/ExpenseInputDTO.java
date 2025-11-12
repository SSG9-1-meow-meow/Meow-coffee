package com.ssg.meowcoffee.dto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ExpenseInputDTO {
    private Long expenseId;
    private BigDecimal totalAmt;
    private Long whId;
}
