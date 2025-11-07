package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

// 거래처 뷰 데이터 조회용 VO
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CompanyVO {

    private String comId;
    private String comName;
    private String comCeoName;
    private String comPwd;
    private String comPhone;
    private String comEmail;
    private String comCode;

    private String comRoadAddr;
    private String comDetailAddr;
    private String comImgPath;

    private LocalDate comStartDate;
    private LocalDate comExpiredDate;
    private LocalDate comLastLogin;

    private UserStatus comStatus;
}
