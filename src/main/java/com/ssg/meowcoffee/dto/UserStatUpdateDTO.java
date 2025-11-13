package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * 회원정보에서 회원상태 변경 시 사용되는 DTO입니다.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatUpdateDTO {

    private String userId;

    private UserRole userRole;

    private UserStatus userStatus;

    private LocalDate userJoinDate;
}
