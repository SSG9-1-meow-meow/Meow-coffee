package com.ssg.meowcoffee.domain;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseVO {
    private Long whId;
    private String whCode;
    private String whName;
    private String whAddress;
    private String whGrade;
    private String whTelephone;
    private Integer whField;
    private Integer whTotalCapa;
    private Integer whUseCapa;
}
