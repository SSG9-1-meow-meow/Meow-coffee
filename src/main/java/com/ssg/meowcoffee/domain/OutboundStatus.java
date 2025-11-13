package com.ssg.meowcoffee.domain;

import com.ssg.meowcoffee.util.UserEnum;

public enum OutboundStatus implements UserEnum {

    PENDING("승인대기", "승인대기"),
    APPROVED("승인완료", "승인완료"),
    SHIPPED("출고완료", "출고완료"),
    REJECTED("반려", "반려");

    private final String name;   // DB 저장 값
    private final String value;  // 프론트 표시 값

    OutboundStatus(String name, String value) {
        this.name = name;
        this.value = value;
    }

    @Override
    public String getName() {
        return this.name;
    }

    @Override
    public String getValue() {
        return this.value;
    }

    public static OutboundStatus fromName(String name) {
        if (name == null) {
            return null;
        }
        for (OutboundStatus status : OutboundStatus.values()) {
            if (status.getName().equals(name)){
                return status;
            }
        }
        throw new IllegalArgumentException("No enum constant: " + name);
    }
}