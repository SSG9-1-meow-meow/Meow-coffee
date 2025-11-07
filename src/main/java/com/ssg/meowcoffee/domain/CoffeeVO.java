package com.ssg.meowcoffee.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CoffeeVO {
    private String cfId;
    private String cfName;
    private String cfOrigin;
    private String cfCategory;
    private String cfGrade;
    private String cfType;
}
