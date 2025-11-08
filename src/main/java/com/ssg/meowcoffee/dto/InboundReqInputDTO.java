package com.ssg.meowcoffee.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.logging.log4j.core.config.plugins.validation.constraints.NotBlank;

// 회원 입고 요청시 활용 DTO (VO의 필드를 확장)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundReqInputDTO {

  private Long _inReqId;

  @NotBlank(message = "거래처 ID(comId)는 필수 입력 항목입니다.")
  private String _comId;           // comId

  private LocalDateTime _inDttmReq; // inDttmReq

  @NotBlank(message = "희망 입고 날짜(inDateWish)는 필수 입력 항목입니다.")
  private LocalDate _inDateWish;    // inDateWish
  private int _isTempo;            // isTempo (TINYINT -> int 또는 boolean)

  // IN 파라미터 (아이템 목록 JSON)
  @NotBlank(message = "입고 요청 상세 항목(inItemsJson)은 필수 입력 항목입니다.")
  private String _inItemsJson;

  // OUT 파라미터 (프로시저 실행 후 반환 받을 ID)
  private Long generatedInReqId;

}
