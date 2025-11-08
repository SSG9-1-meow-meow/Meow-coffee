package com.ssg.meowcoffee.controller.exception;

import com.ssg.meowcoffee.dto.ErrorResponse;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.exception.InboundProcessException;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice // 이 클래스가 모든 컨트롤러에 대한 예외 처리를 담당함을 선언
public class GlobalExceptionHandler {


  /**
   * 400 BAD_REQUEST 처리: @Valid 유효성 검사 실패
   */
  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ErrorResponse> handleValidationExceptions(MethodArgumentNotValidException ex, WebRequest request) {
    HttpStatus status = HttpStatus.BAD_REQUEST;

    // 모든 필드 오류 메시지를 취합하여 클라이언트에게 전달
    String message = ex.getBindingResult().getAllErrors().stream()
        .map(error -> {
          String fieldName = (error instanceof FieldError) ? ((FieldError) error).getField() : error.getObjectName();
          return fieldName + ": " + error.getDefaultMessage();
        })
        .collect(Collectors.joining(", ")); // 쉼표와 공백으로 연결

    ErrorResponse response = ErrorResponse.builder()
        .status(status.value())
        .error("Validation Failed")
        .message(message)
        .path(request.getDescription(false).replace("uri=", ""))
        .build();

    return new ResponseEntity<>(response, status);
  }

  /**
   * 400 BAD_REQUEST 처리: 클라이언트의 요청 데이터 오류 (e.g., 필수값 누락, 비즈니스 규칙 위반)
   * 예: Service에서 던진 InboundProcessException
   */
  @ExceptionHandler(InboundProcessException.class)
  public ResponseEntity<ErrorResponse> handleInboundProcessException(InboundProcessException ex, WebRequest request) {
    HttpStatus status = HttpStatus.BAD_REQUEST;

    ErrorResponse response = ErrorResponse.builder()
        .status(status.value())
        .error(status.getReasonPhrase())
        .message(ex.getMessage()) // 개발자가 정의한 오류 메시지
        .path(request.getDescription(false).replace("uri=", ""))
        .build();

    return new ResponseEntity<>(response, status);
  }

  /**
   * 500 INTERNAL_SERVER_ERROR 처리: 서버 내부 시스템 오류 (DB 트랜잭션 실패, 예상치 못한 오류)
   * 예: Service에서 던진 DatabaseTransactionException 또는 예상치 못한 RuntimeException
   */
  @ExceptionHandler({DatabaseTransactionException.class, RuntimeException.class})
  public ResponseEntity<ErrorResponse> handleInternalServerException(Exception ex, WebRequest request) {
    HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

    ErrorResponse response = ErrorResponse.builder()
        .status(status.value())
        .error(status.getReasonPhrase())
        .message("서버 내부 처리 중 오류가 발생했습니다.") // 사용자에게는 일반적인 메시지를 제공
        .path(request.getDescription(false).replace("uri=", ""))
        .build();

    // 실제 오류는 로그로 남김 (ex.printStackTrace() 또는 로깅 라이브러리 사용)
    System.err.println("Internal Server Error: " + ex.getMessage());

    return new ResponseEntity<>(response, status);
  }


  /**
   * 404 NOT FOUND 처리
   * 예: 요청한 URL에 매핑되는 핸들러가 없을 때
   */
  @ExceptionHandler(NoHandlerFoundException.class)
  public ResponseEntity<ErrorResponse> handleNoHandlerFoundException(NoHandlerFoundException ex, WebRequest request) {
    HttpStatus status = HttpStatus.NOT_FOUND;

    ErrorResponse response = ErrorResponse.builder()
            .status(status.value())
            .error(status.getReasonPhrase())
            .message("요청하신 리소스를 찾을 수 없습니다.")
            .path(request.getDescription(false).replace("uri=", ""))
            .build();

    return new ResponseEntity<>(response, status);
  }
}