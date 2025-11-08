package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.InboundStatus;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundReqItemDTO {
  private Long inReqId;
  private String cfName;
  private String cfCategory;
  private Integer inQtyReq;
  private Integer inQty;
  private InboundStatus status;
  private LocalDateTime inDttmReq;
  private LocalDateTime inDttmAppr;
  private Integer isTempo;
}
