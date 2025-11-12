package com.ssg.meowcoffee.domain;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvoiceVO {
    private Long invoiceId;
    private LocalDate invoiceDt;
    private BigDecimal totalAmt;
    private String invoiceStatus;
    private LocalDate depositDt;
    private String userId;
}
