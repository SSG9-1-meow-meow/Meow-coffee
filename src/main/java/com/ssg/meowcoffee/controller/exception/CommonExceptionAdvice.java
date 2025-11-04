package com.ssg.meowcoffee.controller.exception;

import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
@Log4j2
public class CommonExceptionAdvice {

//    @ExceptionHandler(value = NoHandlerFoundException.class)
//    @ResponseStatus(HttpStatus.NOT_FOUND)     // 예외 발생 시 전달할 상태코드를 지정
//    public String notFound() {
//        return "";
//    }
}
