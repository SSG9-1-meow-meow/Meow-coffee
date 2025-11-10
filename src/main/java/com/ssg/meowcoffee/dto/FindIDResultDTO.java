package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import lombok.*;

import java.util.Arrays;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FindIDResultDTO {

    private UserRole userRole;
    private String userId;

    public void setUserRole(String userRole) {
        this.userRole = Arrays.stream(UserRole.values())
                .filter(role -> role.getRoleName().equals(userRole))
                .findAny()
                .get();
    }
}
