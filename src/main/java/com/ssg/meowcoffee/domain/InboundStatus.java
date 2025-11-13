package com.ssg.meowcoffee.domain;

import com.ssg.meowcoffee.util.UserEnum;

public enum InboundStatus implements UserEnum {

  PENDING("승인대기", "승인대기"),
  APPROVED("승인완료", "승인완료"),
  RECEIVED("입고완료", "입고완료"),
  REJECTED("반려", "반려");

  private final String name;  // DB에 저장될 값 (getName()과 매핑)
  private final String value; // 프론트에서 사용할 값 (getValue()와 매핑)

  InboundStatus(String name, String value) {
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

  /**
   * DB에서 읽어온 문자열(name)을 기반으로 해당하는 Enum 상수를 찾아 반환하는 메서드.
   * TypeHandler가 이 메서드를 사용합니다.
   */
  public static InboundStatus fromName(String name) {
    if (name == null) {
      return null;
    }
    for (InboundStatus status : InboundStatus.values()) {
      if (status.getName().equals(name)) {
        return status;
      }
    }
    // 일치하는 상수가 없으면 예외 발생
    throw new IllegalArgumentException("No enum constant com.ssg.meowcoffee.domain.InboundStatus." + name);
  }

}
