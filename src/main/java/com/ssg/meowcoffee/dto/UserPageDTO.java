package com.ssg.meowcoffee.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

// 회원관리 기능용 페이지 DTO입니다.
@Getter
@ToString
public class UserPageDTO<E> extends PageDTO {

    private int page;
    private int amount;
    private int startPage;  //시작
    private int endPage;    //화면상 마지막 번호
    private boolean prev, next;

    private int total;
    private List<E> dtoList;

    @Builder
    public UserPageDTO(UserCriteria cri, List<E> dtoList, int total) {
        super(cri, total);
        this.page = cri.getPageNum();
        this.amount = cri.getAmount();
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