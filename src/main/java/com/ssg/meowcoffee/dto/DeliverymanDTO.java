package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserStatus;
import com.ssg.meowcoffee.domain.VehicleModel;
import java.time.LocalDate;

public class DeliverymanDTO {

    private String delivId;
    private String delivName;
    private String delivPwd;
    private String delivPhone;
    private String delivCode;
    private String delivImgPath;
    private String delivVhcId;

    private VehicleModel delivVhcModel; // ENUM 사용
    private UserStatus delivStatus;     // 배송기사 회원상태 확인 가능
    private LocalDate delivLastLogin;
}
