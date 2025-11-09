package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 특정 날짜의 전체 처리, 인력, 장비 부하 정보를 담는 DTO
 */
@Data
@NoArgsConstructor
public class DailyLoadDTO {
    // 하루 처리 부하
    private Integer maxCapa;
    private Integer usedCapa;

    // 하루 인력 부하
    private Integer staffAvailable;
    private Integer staffAssign;

    // 하루 장비 부하
    private Integer equipAvailable;
    private Integer equipAssign;
}

