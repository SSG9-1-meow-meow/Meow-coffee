package com.ssg.meowcoffee.domain;

import com.ssg.meowcoffee.util.UserEnum;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserStatus implements UserEnum {

    APPROVAL("APPROVAL", "승인완료"),
    WAITING_APPROVAL("WAITING_APPROVAL", "승인대기"),
    DEACTIVATED("DEACTIVATED", "휴면상태"),
    WAITING_DEACTIVATED("WAITING_DEACTIVATE", "휴면대기");

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
