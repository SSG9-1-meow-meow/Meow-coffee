package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InboundRequestVO {
    private Long inReqId;
    private String comId;
    private String managerId;
    private LocalDateTime inDttmReq;
    private LocalDate inDateWish;
    private LocalDateTime inDttmAppr;
    private Boolean isDelete;
    private Boolean isTempo;

}
