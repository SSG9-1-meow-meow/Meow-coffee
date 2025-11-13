package com.ssg.meowcoffee.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.meowcoffee.domain.InboundStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class InboundItemDetailDTO {
    // InboundItemVO의 필드들
    private Long inReqItemsId;
    private Long inReqId;
    private String cfId;
    private String locationId;
    private InboundStatus status;
    private Integer inQtyReq;
    private String inOrderAddr;
    private Integer inQty;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmSchd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmInsp;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmRecv;

    private String comId;
    private String managerId;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmReq;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate inDateWish;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime inDttmAppr;
    private Boolean isDelete;
    private Boolean isTempo;

    private String cfName;
    private String cfCategory;
    private String cfGrade;

    private String companyName;

    // ★★★ [추가] 아래 4개 필드를 추가합니다 ★★★
    private String lpId;          // 실제 보관 위치 ID (예: LP001)
    private String warehouseName; // 창고 이름
    private String zoneName;      // 존 이름
    private String adminMemo;     // 관리자 메모

    public String getStatusValue() {
        return this.status != null ? this.status.getValue() : null;
    }

}
