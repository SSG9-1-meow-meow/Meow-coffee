package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 특정 조건에 따라 할당 가능한 창고와 해당 창고의 Zone 목록을 담는 DTO
 */
@Data
@NoArgsConstructor
public class AssignableWarehouseDTO {
    /**
     * 창고 이름
     */
    private String warehouseName;

    /**
     * 해당 창고에 속한 모든 Zone 이름의 리스트
     */
    private List<String> zoneNames;
}
