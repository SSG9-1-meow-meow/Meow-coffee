package com.ssg.meowcoffee.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MemberDTO {
    
    private String mID;
    private String mPassword;
    private String mName;
    private String mRole;
}
