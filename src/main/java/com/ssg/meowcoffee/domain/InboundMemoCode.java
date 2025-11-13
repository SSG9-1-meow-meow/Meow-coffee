package com.ssg.meowcoffee.domain;

import lombok.Getter;

@Getter
public enum InboundMemoCode {
    // ★★★ [수정] 한글 코드명 추가 ★★★
    APPROVED("승인", "입고 요청을 검토한 결과, 일정과 수용량 모두 적정하여 승인되었습니다."),
    REJECTED("반려", "입고 요청을 검토한 결과, 해당 날짜에 창고 처리 혹은 수용 가능 용량을 초과하여 입고가 불가능하여 반려되었습니다."),
    DATE_ADJUSTED("일정조정", "요청된 입고 날짜가 창고 처리 가능 일정을 초과하여, 일정 조정이 필요합니다."),
    STORAGE_LIMIT_EXCEEDED("수용량초과", "해당 날짜에 창고 수용 가능 용량을 초과하여 입고가 불가능합니다."),
    RESOURCE_CONFLICT("자원충돌", "입고 요청일에 인력 또는 장비 자원이 과부하 상태로 입고 처리에 어려움이 있습니다."),
    DOCUMENT_MISSING("서류미비", "입고 요청에 필수 서류가 누락되어 검토가 불가능합니다."),
    ITEM_DISCREPANCY("품목불일치", "요청 품목 정보와 실제 입고 품목 간 불일치가 확인되어 반려되었습니다."),
    DUPLICATE_DETECTED("중복요청", "동일한 입고 요청이 이미 등록되어 중복 처리 방지를 위해 반려되었습니다."),
    OTHER("기타", "기타 사유로 입고 요청이 조정 또는 반려되었습니다. 상세 내용은 별도 메모를 참고하세요.");

    private final String codeName; // 한글 코드명
    private final String description;

    InboundMemoCode(String codeName, String description) {
        this.codeName = codeName;
        this.description = description;
    }

}
