package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailDTO {

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
