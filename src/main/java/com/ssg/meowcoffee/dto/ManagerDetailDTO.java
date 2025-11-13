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
public class ManagerDetailDTO {

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
