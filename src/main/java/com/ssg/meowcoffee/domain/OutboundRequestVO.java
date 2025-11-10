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
public class OutboundRequestVO {
    private Long outReqId;                  //출고 요청ID
    private String comId;                   //거래처ID
    private String managerId;               //관리자ID
    private LocalDateTime outDttmReq;       //출고 요청 시각
    private LocalDate outDateWish;          //출고 희망 날짜
    private LocalDateTime outDttmAppr;      //출고 승인 시각
    private Boolean isDelete;               //삭제 여부
    private Boolean isTempo;                //임시 저장 여부
}
