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
    private String delivCode;
    private String delivImgPath;
    private String delivVhcId;

    // 추후 수정 예정
    private String delivVhcModel;
    private LocalDate delivLastLogin;
}
