package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.InboundStatus;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// 회원 및 관리자 입고 관리 UI 에 필요한 데이터 모음
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundReqItemDTO {
  private Long inReqId;
  private String comName; // 거래처명
  private String cfName;
  private String cfCategory;
  private Integer inQtyReq;
  private Integer inQty; // 입고 수량
  private InboundStatus status;
  private LocalDateTime inDttmReq;
  private LocalDateTime inDttmAppr;
  private Integer isTempo;
}
