package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CoffeeDTO {
    private String cfId;
    private String cfName;
    private String cfOrigin;
    private String cfCategory;
    private String cfGrade;
    private String cfType;
}
