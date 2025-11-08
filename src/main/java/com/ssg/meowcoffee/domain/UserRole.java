package com.ssg.meowcoffee.domain;

import com.ssg.meowcoffee.util.UserEnum;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserRole implements UserEnum {

    COMPANY("COMPANY", "거래처"),
    MANAGER("MANAGER", "창고관리자"),
    ADMIN("ADMIN", "총관리자"),
    DELIVERY("DELIVERYMAN", "배송기사");

    private final String roleName;  // DB에 저장될 문자열
    private final String roleValue; // 프론트 작업 시 사용할 값


    @Override
    public String getName() {
        return roleName;
    }

    @Override
    public String getValue() {
        return roleValue;
    }
}
