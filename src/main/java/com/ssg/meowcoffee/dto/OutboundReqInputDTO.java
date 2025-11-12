package com.ssg.meowcoffee.dto;

import lombok.*;
import org.apache.logging.log4j.core.config.plugins.validation.constraints.NotBlank;

import java.time.LocalDate;
import java.time.LocalDateTime;

// 회원 출고 요청 시 활용 DTO (ERD + API 명세서 기반)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundReqInputDTO {

    private Long outReqId; // 출고 요청 ID (OUT 파라미터용)

    @NotBlank(message = "거래처 ID(comId)는 필수 입력 항목입니다.")
    private String comId; // 거래처 ID

    @NotBlank(message = "담당 관리자 ID(managerId)는 필수 입력 항목입니다.")
    private String managerId; // 담당 관리자 ID

    @NotBlank(message = "출고 희망 날짜(outDateWish)는 필수 입력 항목입니다.")
    private LocalDate outDateWish; // 출고 희망일

    private int isTempo; // 임시 저장 여부 (TINYINT)

    // 출고 상세 항목 JSON (ex: [{"stkId":"STK001","outQtyReq":10,"vehicleId":"VEH001"}, ...])
    @NotBlank(message = "출고 요청 상세 항목(outItemsJson)은 필수 입력 항목입니다.")
    private String outItemsJson;

    // 프로시저 실행 후 생성된 출고 요청 ID
    private Long generatedOutReqId;

    private LocalDateTime outDttmReq;


}