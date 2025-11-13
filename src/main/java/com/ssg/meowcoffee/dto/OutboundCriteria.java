package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class OutboundCriteria {
    @Builder.Default private int page = 1;   // 1-based
    @Builder.Default private int size = 10;  // rows per page

    public int getOffset(){ return (Math.max(page,1)-1) * Math.max(size,1); }
}
