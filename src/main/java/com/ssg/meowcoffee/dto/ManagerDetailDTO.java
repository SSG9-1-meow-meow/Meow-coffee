package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
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
