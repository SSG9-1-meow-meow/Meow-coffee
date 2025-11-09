package com.ssg.meowcoffee.domain;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Setter // 테스트용 동적 데이터 생성을 위해 임시로 삽입
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
