package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

// 관리자(창고관리자, 총관리자) 뷰 데이터 조회용 VO
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ManagerVO {

    private String managerId;
    private String managerName;
    private String managerPwd;
    private String managerCode;
    private String managerPhone;
    private String managerEmail;
    private String managerImgPath;

    private LocalDate managerHireDate;
    private LocalDate managerLastLogin;

    private UserRole managerRole;
    private UserStatus managerStatus;
}
