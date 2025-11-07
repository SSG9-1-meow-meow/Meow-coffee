package com.ssg.meowcoffee.dto;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter // OUT 파라미터를 MyBatis가 설정해야 하므로 Setter는 필수입니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyReadDTO {
    private String comId;
    private String comName;
    private String comCode;
    private String comEmail;
    private String comPhone;
    private LocalDate comStartDate;
    private LocalDate comEndDate;
}
