package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
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

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserCriteria extends Criteria {

    @Builder.Default
    @Min(value = 1)
    private int pageNum = 1;

    @Builder.Default
    @Min(value = 10)
    @Max(value = 30)
    private int amount = 10;

    // 회원권한별 필터링 옵션
    private UserRole roleType;
    // 키워드 검색 시 필터링 옵션
    private String keywordFilter;
    // 특정 기간 내 가입/로그인 여부 필터링 옵션
    private String periodFilter;

    // 설정한 기간
    private LocalDate from;

    @Future
    private LocalDate to;

    private String keyword;

    public void setRoleType(String searchOption) {
        this.roleType = Arrays.stream(UserRole.values())
                    .filter(userRole -> searchOption.equals(userRole.getRoleName()))
                    .findAny()
                    .orElse(UserRole.ALL);
    }

    @Override
    public void setPageNum(int pageNum) {
        this.pageNum = Math.max(pageNum, 1);
    }

    @Override
    public void setAmount(int amount) {
        this.amount = amount;
    }

    @Override
    public int getSkip() {
        return (this.pageNum - 1) * this.amount;
    }
}
