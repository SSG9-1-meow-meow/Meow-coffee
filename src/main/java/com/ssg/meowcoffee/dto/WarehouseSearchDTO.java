package com.ssg.meowcoffee.dto;

import lombok.*;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WarehouseSearchDTO {
    private String whAddress;  // 소재지
    private String whName;     // 창고명
    private String whGrade;    // 등급
}
