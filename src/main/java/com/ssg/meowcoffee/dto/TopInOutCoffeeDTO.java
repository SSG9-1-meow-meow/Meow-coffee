package com.ssg.meowcoffee.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 입/출고 상위 커피 순위 조회를 위한 DTO
 */
@Data
@NoArgsConstructor
public class TopInOutCoffeeDTO {

    private String coffeeName;
    private double totalQuantity;
}
