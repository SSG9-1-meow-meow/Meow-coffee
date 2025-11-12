package com.ssg.meowcoffee.dto;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class OutboundPageResponse<T> {
    private List<T> list;
    private OutboundPageMaker PageMaker;
}