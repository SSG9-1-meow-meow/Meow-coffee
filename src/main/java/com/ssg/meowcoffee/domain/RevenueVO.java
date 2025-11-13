package com.ssg.meowcoffee.domain;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RevenueVO {
    private Long revenueId;
    private BigDecimal totalAmt;
    private LocalDate revenueDt;
}
