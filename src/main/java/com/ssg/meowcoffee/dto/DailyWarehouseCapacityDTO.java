package com.ssg.meowcoffee.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class DailyWarehouseCapacityDTO {
    private LocalDate dateId;
    private Long whId;
    private String warehouseName; // JOIN을 통해 가져올 창고 이름

    // 보관 용량
    private Integer usedStorageCapacity;
    private Integer availableStorageCapacity;
    private Integer totalStorageCapacity; // warehouse 테이블에서 JOIN

    // 처리 부하
    private Integer maxProcessingCapacity;
    private Integer usedProcessingCapacity;

    // 인력 부하
    private Integer staffAvailable;
    private Integer staffAssigned;

    // 장비 부하
    private Integer equipAvailable;
    private Integer equipAssigned;
}