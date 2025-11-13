package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Arrays;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FindIDResultDTO {

    private String userId;
    private UserRole userRole;

    public void setUserRole(String userRole) {
        this.userRole = Arrays.stream(UserRole.values())
                .filter(role -> role.getRoleName().equals(userRole))
                .findAny()
                .get();
    }
}
