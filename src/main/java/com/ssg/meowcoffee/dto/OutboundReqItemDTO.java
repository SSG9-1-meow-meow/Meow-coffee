package com.ssg.meowcoffee.dto;// OutboundReqItemDTO
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.meowcoffee.domain.OutboundStatus;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundReqItemDTO {
    private Long outReqId;
    private String comId;
    private String comName;
    private String stkId;
    private String vehicleId;
    private Integer outQtyReq;
    private Integer outQty;
    private OutboundStatus status;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime outDttmReq;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime outDttmAppr;

    private Integer isTempo;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate outDateWish;

    private Boolean isDelete;
}
