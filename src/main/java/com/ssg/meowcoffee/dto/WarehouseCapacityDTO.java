package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 특정 날짜의 개별 창고 수용 능력 정보를 담는 DTO
 */
@Data
@NoArgsConstructor
public class WarehouseCapacityDTO {
    private String warehouseName; // 창고 이름
    private int usedCapacity;     // 현재 사용량
    private int availableCapacity;// 남은 사용량
    private int totalCapacity;    // 총 사용량
}
