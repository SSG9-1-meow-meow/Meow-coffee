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

/**
 * 회원정보에서 회원상태 변경 시 사용되는 DTO입니다.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatUpdateDTO {

    private String userId;

    private UserRole userRole;

    private UserStatus oldStatus;

    private UserStatus newStatus;

    private LocalDate userJoinDate;
}
