package com.ssg.meowcoffee.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.meowcoffee.domain.InboundStatus;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Data
public class InboundProcessDTO {

    private Long inReqItemsId; // NotNull 로 해놀 필요 없음.

    @NotNull
    private String managerId; // 처리한 관리자 ID

    @NotNull
    private InboundStatus newStatus; // 최종 상태 ('승인완료' 또는 '반려')

    // 승인 시 필요한 정보
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate confirmedDate; // 확정된 입고 예정일
    
    private String lpId; // 확정된 보관 위치 ID

    private String adminMemo; // 관리자 메모

    // 이 처리가 임시저장인지 최종 저장인지 구분
    @NotNull
    private Integer isTempo; // 0: 최종 저장, 1: 임시 저장
}