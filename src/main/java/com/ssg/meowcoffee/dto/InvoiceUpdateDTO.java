package com.ssg.meowcoffee.dto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvoiceUpdateDTO {
    private Long invoiceId;
    private String invoiceStatus;
}
