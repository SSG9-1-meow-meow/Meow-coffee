package com.ssg.meowcoffee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FindIDDTO {

    private String targetRole;
    private String userCode;
    private String userName;
    private String userEmail;
}
