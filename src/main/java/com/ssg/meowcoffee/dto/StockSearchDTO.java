package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockSearchDTO {
    private String cfCategory;
    private String cfType;
    private String cfGrade;
    private String cfName;
}
