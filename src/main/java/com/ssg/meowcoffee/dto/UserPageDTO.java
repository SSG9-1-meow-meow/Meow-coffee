package com.ssg.meowcoffee.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

// 회원관리 기능용 페이지 DTO입니다.
@Getter
@ToString
public class UserPageDTO<E> {

    private final UserCriteria cri;
    private final List<E> dtoList;
    private final int total;

    private final boolean prev;
    private final boolean next;

    private final int startPage;  //시작
    private int endPage;    //화면상 마지막 번호

    @Builder
    public UserPageDTO(UserCriteria cri, List<E> dtoList, int total) {
        this.cri = cri;
        this.total = total;
        this.dtoList = dtoList;

        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
        this.startPage = this.endPage - 9;

        int realEnd = (int)(Math.ceil((double) total / cri.getAmount()));
        this.endPage = Math.min(realEnd, this.endPage);

        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;
    }
}