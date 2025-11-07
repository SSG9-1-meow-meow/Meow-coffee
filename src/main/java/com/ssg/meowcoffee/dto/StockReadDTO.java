package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class StockReadDTO {
    private String stkId;
    private Integer stkQuantity;
    private String cfName;
    private String cfCategory;
    private String cfGrade;
    private String cfType;
    private String zoneName;
    private String rackName;
    private String cellName;
    private String whCode;
    private String whName;
    private String whAddress;
    private String whGrade;
}
