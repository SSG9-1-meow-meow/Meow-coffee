package com.ssg.meowcoffee.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class InboundPageDTO {

    private final int startPage; // 화면에 표시될 시작 페이지 번호
    private int endPage;   // 화면에 표시될 마지막 페이지 번호
    private final boolean prev;
    private final boolean next; // 이전, 다음 버튼 표시 여부

    private final int total;     // 전체 데이터 건수
    private final InboundCriteria criteria; // 페이징 기준 정보 (Criteria -> InboundCriteria로 변경)

    public InboundPageDTO(InboundCriteria criteria, int total) {

        this.criteria = criteria;
        this.total = total;

        // 페이지네이션 UI에 보여줄 페이지 개수 (예: 10개씩)
        int pageCount = 10;

        // 끝 페이지 계산 (pageNum -> criteria.getPage()로 변경)
        this.endPage = (int) (Math.ceil(criteria.getPage() / (double) pageCount)) * pageCount;

        // 시작 페이지 계산
        this.startPage = this.endPage - (pageCount - 1);

        // 실제 마지막 페이지 계산 (amount -> criteria.getSize()로 변경)
        int realEnd = (int) (Math.ceil((double) total / criteria.getSize()));

        // 만약 계산된 끝 페이지가 실제 마지막 페이지보다 크면, 실제 마지막 페이지로 조정
        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        // 이전 버튼 표시 여부 (시작 페이지가 1보다 클 때)
        this.prev = this.startPage > 1;

        // 다음 버튼 표시 여부 (실제 마지막 페이지가 계산된 끝 페이지보다 클 때)
        this.next = this.endPage < realEnd;
    }
}