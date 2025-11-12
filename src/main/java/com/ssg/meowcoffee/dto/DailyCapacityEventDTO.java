package com.ssg.meowcoffee.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;

@Data
public class DailyCapacityEventDTO {
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate date; // 날짜 (FullCalendar의 'start' 속성으로 사용됨)

    private int totalUsedCapacity; // 기존 usedCapa 역할 (이름 변경)

    // ★★★ [추가] 가용 처리 능력의 총합을 담을 필드 ★★★
    private int totalAvailableCapacity;
}