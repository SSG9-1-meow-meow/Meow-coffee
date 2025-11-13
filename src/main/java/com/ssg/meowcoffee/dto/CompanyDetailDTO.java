package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

// CompanyVO 데이터를 DTO로 변환하여 조회
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyDetailDTO {

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
