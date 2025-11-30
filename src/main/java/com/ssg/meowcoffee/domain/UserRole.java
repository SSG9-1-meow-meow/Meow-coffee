package com.ssg.meowcoffee.domain;

import com.fasterxml.jackson.annotation.JsonValue;
import com.ssg.meowcoffee.util.UserEnum;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UserRole implements UserEnum {

    COMPANY("COMPANY", "거래처"),
    MANAGER("MANAGER", "창고관리자"),
    ADMIN("ADMIN", "총관리자"),
    DELIVERYMAN("DELIVERYMAN", "배송기사"),
    ALL("ALL", "전체");       // 검색결과 필터링 미적용 시 기본옵션

    private final String roleName;  // DB에 저장될 문자열
    private final String roleValue; // 프론트 작업 시 사용할 값


    @Override
    @JsonValue
    public String getName() {
        return roleName;
    }

    @Override
    public String getValue() {
        return roleValue;
    }
}
