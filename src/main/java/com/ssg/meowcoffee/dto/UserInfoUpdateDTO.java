package com.ssg.meowcoffee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 회원관리 기능에서 회원정보 수정(+soft delete) 시 사용되는 DTO입니다.
 */
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserInfoUpdateDTO {

    private String userId;
    private String userPwd;
    private String userPhone;
    private String userEmail;

    private String userRoadAddr;
    private String userDetailAddr;
    private String userImgPath;
}
