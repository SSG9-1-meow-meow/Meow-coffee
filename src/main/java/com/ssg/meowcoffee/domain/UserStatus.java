package com.ssg.meowcoffee.domain;

import com.ssg.meowcoffee.util.UserEnum;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UserStatus implements UserEnum {

    APPROVAL("APPROVAL", "승인완료"),
    WAITING_APPROVAL("WAITING_APPROVAL", "승인대기"),
    DEACTIVATED("DEACTIVATED", "휴면상태"),
    WAITING_DEACTIVATED("WAITING_DEACTIVATE", "휴면대기"),
    ALL("ALL", "전체");   // 검색 시 필터링용

    private final String statusName;
    private final String statusValue;

    @Override
    public String getName() {
        return statusName;
    }

    @Override
    public String getValue() {
        return statusValue;
    }
}
