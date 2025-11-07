package com.ssg.meowcoffee.exception;

// HTTP 400 Bad Request에 매핑될 수 있는 비즈니스 예외
public class InboundProcessException extends RuntimeException {
  public InboundProcessException(String message) {
    super(message);
  }
}