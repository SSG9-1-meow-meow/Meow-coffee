package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import java.time.LocalDate;
import javax.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatusDTO {

    @NotNull
    private String userId;

    @NotNull
    private UserRole userRole;

    private UserStatus oldStatus;

    @NotNull
    private UserStatus newStatus;

    private LocalDate userJoinDate;
}
