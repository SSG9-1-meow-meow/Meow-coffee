package com.ssg.meowcoffee.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import javax.validation.constraints.Future;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import java.time.LocalDate;
import java.util.Arrays;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserCriteria {

    @Builder.Default
    @Min(value = 1)
    private int pageNum = 1;

    @Builder.Default
    @Min(value = 10)
    @Max(value = 30)
    private int amount = 10;

    // 회원유형별 필터링 옵션
    private UserRole roleType;
    // 회원상태별 필터링 옵션
    private UserStatus statusType;

    // 키워드 검색 시 필터링 옵션 - 이름(N), 아이디(I)
    private String type;
    private String keyword;

    // 특정 기간 내 미선택/가입(reg)/로그인(login) 여부 필터링 옵션
    private String periodFilter;

    // 설정한 기간
    private LocalDate from;

    @Future
    private LocalDate to;

    // 페이지네이션 관련
    public void setPageNum(int pageNum) {
        this.pageNum = Math.max(pageNum, 1);
    }

    // 회원권한, 회원상태별 필터링
    public void setRoleType(String roleType) {
        this.roleType = UserRole.valueOf(roleType);
    }

    public void setStatusType(String searchOption) {
        this.statusType = UserStatus.valueOf(searchOption);
    }

    public int getSkip() {
        return (this.pageNum - 1) * this.amount;
    }

    public String getLink() {
        StringBuilder builder = new StringBuilder();
        builder.append(String.format("pageNum=%d&amount=%d", this.pageNum, this.amount));

        // 회원권한/회원상태 필터링
        if (roleType != null) {
            builder.append(String.format("&roleType=%s", roleType.getName()));
        }
        if (statusType != null) {
            builder.append(String.format("&statusType=%s", statusType.getName()));
        }

        // 키워드 검색
        if (type != null && !type.isEmpty()) {
            builder.append(String.format("&type=%s", type));
        }
        if (keyword != null) {
            builder.append(String.format("&keyword=%s", keyword));
        }

        // 기간 필터링
        if (periodFilter != null) {
            builder.append(String.format("&periodFilter=%s", periodFilter));
        }
        if (from != null) {
            builder.append(String.format("&from=%s", from));
        }
        if (to != null) {
            builder.append(String.format("&to=%s", to));
        }

        return builder.toString();
    }
}
