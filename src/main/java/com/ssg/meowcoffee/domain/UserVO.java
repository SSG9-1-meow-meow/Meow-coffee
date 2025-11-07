package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

// 로그인/회원관리 기능 전용 VO
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserVO {

    private String userId;
    private String userPwd;
    private String userCompanyName;
    private String userName;
    private String userPhone;
    private String userEmail;
    private String userCode;

    private String userRoadAddr;
    private String userDetailAddr;
    private String userImgPath;

    private LocalDate userJoinDate;
    private LocalDate userLastLogin;

    private UserRole userRole;
    private UserStatus userStatus;

    private String vehicleId;   // 차량번호(외래키)
}
