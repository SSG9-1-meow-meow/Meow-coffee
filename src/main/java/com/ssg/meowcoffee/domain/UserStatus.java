package com.ssg.meowcoffee.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserStatus {

    APPROVAL("APPROVAL"),
    WAITING_APPROVAL("WAITING_APPROVAL"),
    DEACTIVATED("DEACTIVATED"),
    WAITING_DEACTIVATED("WAITING_DEACTIVATED");

    private final String type;
}
