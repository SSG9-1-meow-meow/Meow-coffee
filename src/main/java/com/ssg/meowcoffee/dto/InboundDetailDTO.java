package com.ssg.meowcoffee.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.meowcoffee.domain.InboundStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

// 뷰에서 필요한 모든 정보를 담을 수 있는 전용 DTO
@Getter
@Setter
public class InboundDetailDTO {

    // InboundItem 정보
    private long inReqItemsId;

    private InboundStatus status;
    private int inQtyReq;
    private Integer inQty; // 실제 입고량 (nullable)

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmSchd;

    // Coffee 정보 (JOIN)
    private String coffeeName;
    private String coffeeCategory;

    // InboundRequest 정보 (JOIN)
    private long inReqId;
    private String companyName; // 요청한 거래처명

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmReq;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmAppr;

    private Boolean isTempo; // TINYINT(1)은 Boolean 타입으로 매핑


    // Stock 정보 (JOIN)
    // '입고완료' 상태일 때만 이 값이 채워집니다.
    private String stkId; // QR 코드 생성을 위한 재고 ID

    /**
     * JSON 변환 시 'statusValue'라는 필드를 추가로 생성합니다.
     * 이 필드는 status Enum의 한글 값(value)을 가집니다.
     * @return 상태의 한글 설명 (예: "승인대기")
     */
    public String getStatusValue() {
        return this.status != null ? this.status.getValue() : null;
    }
}
