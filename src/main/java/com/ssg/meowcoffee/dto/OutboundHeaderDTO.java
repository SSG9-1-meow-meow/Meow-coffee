package com.ssg.meowcoffee.dto;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OutboundHeaderDTO {
    private Long outReqId;
    private String comId;
    private String comName;
    private String status;       // REQUESTED/APPROVED/INSPECTING/SHIPPED/CANCELLED (영문 코드)
    private String statusValue;  // '승인대기' 등 한글 상태

    private Integer isTempo;
    private Boolean isDelete;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate outDateWish;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime outDttmReq;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime outDttmAppr;
}
