package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import java.io.UnsupportedEncodingException;
import java.time.LocalDate;
import java.util.Arrays;
import javax.validation.constraints.Future;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

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

    // 특정 기간 내 미선택/가입(reg)/로그인(login) 여부 필터링 옵션
    private String periodFilter;

    // 설정한 기간
    @DateTimeFormat(iso = ISO.DATE)
    private LocalDate from;

    @Future
    @DateTimeFormat(iso = ISO.DATE)
    private LocalDate to;

    private String keyword;
    private String link;

    // 페이지네이션 관련
    public void setPageNum(int pageNum) {
        this.pageNum = Math.max(pageNum, 1);
    }

    public int getSkip() {
        return (this.pageNum - 1) * this.amount;
    }

    // 회원권한, 회원상태별 필터링
    public void setRoleType(String roleType) {
        this.roleType = Arrays.stream(UserRole.values())
                .filter(userRole -> userRole.getRoleName().equals(roleType))
                .findAny()
                .orElse(UserRole.ALL);
    }

    public void setStatusType(String searchOption) {
        this.statusType = Arrays.stream(UserStatus.values())
                .filter(userStatus -> userStatus.getName().equals(searchOption))
                .findAny()
                .orElse(UserStatus.ALL);
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

        // 기간 필터링
        if (periodFilter != null && !periodFilter.trim().isEmpty() && from != null && to != null) {
            builder.append(String.format("&periodFilter=%s", periodFilter))
                    .append(String.format("&from=%s", from))
                    .append(String.format("&to=%s", to));
        }

        // 키워드 검색
        if (type != null && !type.trim().isEmpty() && keyword != null && !keyword.trim().isEmpty()) {
            builder.append(String.format("&type=%s", type))
                    .append(String.format("&keyword=%s", keyword));
        }

        return builder.toString();
    }
}
