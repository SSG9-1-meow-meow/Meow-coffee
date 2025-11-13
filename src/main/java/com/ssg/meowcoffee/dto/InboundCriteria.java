package com.ssg.meowcoffee.dto;

import lombok.Data;

@Data
public class InboundCriteria {
    // 1. 페이징 관련 속성
    private int page;     // 현재 페이지 번호
    private int size;     // 페이지당 보여줄 데이터 개수

    // 2. 정렬 관련 속성
    private String sortBy;    // 정렬 기준 필드 (예: "company", "coffeeName", "reqDate")
    private String sortOrder; // 정렬 순서 ("ASC" 또는 "DESC")

    // 3. 검색(필터링) 관련 속성
    private String companyName;      // 검색할 거래처 이름
    private String coffeeCategory;   // 필터링할 커피 카테고리 ("생두", "원두", "DCF")
    private String inboundStatus;    // 필터링할 입고 상태 ("승인대기", "승인완료", "입고완료")
    private Integer isTempo;         // 필터링할 임시저장 여부 (0 또는 1)

    /**
     * 기본 생성자.
     * 객체 생성 시 기본값을 설정하여 NullPointerException 등을 방지합니다.
     */
    public InboundCriteria() {
        // 기본값 설정
        this.page = 1;
        this.size = 10; // 한 페이지에 10개씩 표시
        this.sortBy = "reqDate"; // 기본 정렬은 입고 요청일 기준
        this.sortOrder = "DESC"; // 최신순으로 정렬
    }

    public int getSkip() {
        return (this.page - 1) * this.size;
    }


}
