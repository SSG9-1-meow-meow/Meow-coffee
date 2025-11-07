package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.InboundRequestInputDTO;
import com.ssg.meowcoffee.service.InboundService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@Controller
@RequiredArgsConstructor
public class InboundController {

  private final InboundService inboundService;

  @PostMapping("/inbounds/req")
  public ResponseEntity<Long> createRequest(@Valid @RequestBody InboundRequestInputDTO requestDto) {

// 1. 유효성 검사 실패 시, 이 코드는 실행되지 않고 GlobalExceptionHandler로 바로 넘어갑니다.
    long inReqId = inboundService.registerInboundRequest(requestDto);

    return ResponseEntity.status(HttpStatus.CREATED).body(inReqId);
  }

}
