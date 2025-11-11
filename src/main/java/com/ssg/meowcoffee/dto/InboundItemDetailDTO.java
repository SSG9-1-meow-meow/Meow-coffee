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
}
