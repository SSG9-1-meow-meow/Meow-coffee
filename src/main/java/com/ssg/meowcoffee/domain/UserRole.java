package com.ssg.meowcoffee.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserRole {

    COMPANY("COMPANY"),
    MANAGER("MANAGER"),
    ADMIN("ADMIN"),
    DELIVERY("DELIVERY");

    private final String type;  // DB에 저장될 문자열
}
