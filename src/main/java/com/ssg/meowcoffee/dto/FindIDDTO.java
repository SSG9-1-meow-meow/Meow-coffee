package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FindIDDTO {

    private String targetRole;
    private String userCode;
    private String userName;
    private String userEmail;
}
