package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import java.time.LocalDate;
import java.util.Arrays;
import javax.validation.constraints.Future;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Positive;
import lombok.Builder;
import lombok.Data;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

@Data
@Builder
public class UserCriteria {

    @Builder.Default
    @Min(value = 1)
    @Positive
    private int pageNum = 1;

    @Setter
    @Builder.Default
    @Min(value = 10)
    @Max(value = 30)
    @Positive
    private int amount = 10;

    // 회원유형별 필터링 옵션
    private UserRole roleType;
    // 회원상태별 필터링 옵션
    private UserStatus statusType;

    // 키워드 검색 시 필터링 옵션 - null, 이름(N), 아이디(I), 이름+아이디(NI)
    private String[] types;
    private String typeString;

    // 특정 기간 내 미선택/가입(reg)/로그인(login) 여부 필터링 옵션
    private String periodFilter;

    // 설정한 기간
    @DateTimeFormat(iso = ISO.DATE)
    private LocalDate from;

    @Future
    @DateTimeFormat(iso = ISO.DATE)
    private LocalDate to;

    private String keyword;

    // 페이지네이션 관련
    public void setPageNum(int pageNum) {
        this.pageNum = Math.max(pageNum, 1);
    }

    public int getSkip() {
        return (this.pageNum - 1) * this.amount;
    }

    // 회원권한, 회원상태별 필터링
    public void setRoleType(String searchOption) {
        this.roleType = Arrays.stream(UserRole.values())
                .filter(userRole -> searchOption.equals(userRole.getRoleName()))
                .findAny()
                .orElse(UserRole.ALL);
    }

    public void setStatusType(String searchOption) {
        this.statusType = Arrays.stream(UserStatus.values())
                .filter(userStatus -> searchOption.equals(userStatus.getName()))
                .findAny()
                .orElse(UserStatus.ALL);
    }

    public void setTypes(String[] types) {
        this.types = types;
        if (this.types.length > 0) {
            this.typeString = String.join("", this.types);
        }
    }
}
