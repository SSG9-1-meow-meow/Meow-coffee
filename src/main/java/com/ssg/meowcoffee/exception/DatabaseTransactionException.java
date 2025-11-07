package com.ssg.meowcoffee.exception;

// HTTP 500 Internal Server Error에 매핑될 수 있는 시스템/DB 예외
public class DatabaseTransactionException extends RuntimeException {
  // 1. Exception e를 받는 생성자 (DB/기술적 오류 발생 시)
  public DatabaseTransactionException(String message, Throwable cause) {
    super(message, cause);
  }

  // 2. Exception e를 받지 않는 생성자 (프로시저 로직 오류 추정 시)
  public DatabaseTransactionException(String message) {
    super(message); // RuntimeException의 message만 받는 생성자 호출
  }
}