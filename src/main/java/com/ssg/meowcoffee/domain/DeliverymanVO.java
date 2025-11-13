package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeliverymanVO {

    private String delivId;
    private String delivName;
    private String delivPwd;
    private String delivPhone;
    private String delivEmail;
    private String delivCode;
    private String delivImgPath;
    private String delivVhcId;

    private VehicleModel delivVhcModel; // ENUM 사용
    private UserStatus delivStatus;     // 배송기사 회원상태 확인 가능
    private LocalDate delivLastLogin;
}
