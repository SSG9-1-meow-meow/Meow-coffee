package com.ssg.meowcoffee.dto;

import lombok.Data;

@Data
public class AvailableLocationDTO {
    private String lpId;
    private String warehouseName;
    private String zoneName;

    private int currentStock;      // 현재 물리 재고
    private int scheduledInbound;  // 예정된 입고량
    private int scheduledOutbound; // 예정된 출고량
}
