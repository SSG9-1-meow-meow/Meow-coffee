package com.ssg.meowcoffee.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum VehicleModel {

    WING_BODY("5톤 윙바디", 5000);

    private static final int PLT = 500;

    private final String model;
    private final int totalCapa;     // 저장 가능한 파레트수

    public int getPLTCount() {
        return totalCapa / PLT;
    }
}
