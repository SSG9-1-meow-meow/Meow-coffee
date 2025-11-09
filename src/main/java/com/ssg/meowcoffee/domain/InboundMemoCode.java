package com.ssg.meowcoffee.domain;

import lombok.Getter;

@Getter
public enum InboundMemoCode {
    APPROVED("입고 요청을 검토한 결과, 일정과 수용량 모두 적정하여 승인되었습니다."),
    DATE_ADJUSTED("요청된 입고 날짜가 창고 처리 가능 일정을 초과하여, 일정 조정이 필요합니다."),
    STORAGE_LIMIT_EXCEEDED("해당 날짜에 창고 수용 가능 용량을 초과하여 입고가 불가능합니다."),
    RESOURCE_CONFLICT("입고 요청일에 인력 또는 장비 자원이 과부하 상태로 입고 처리에 어려움이 있습니다."),
    DOCUMENT_MISSING("입고 요청에 필수 서류가 누락되어 검토가 불가능합니다. 서류 보완 후 재요청 바랍니다."),
    ITEM_DISCREPANCY("요청 품목 정보와 실제 입고 품목 간 불일치가 확인되어 반려되었습니다."),
    DUPLICATE_DETECTED("동일한 입고 요청이 이미 등록되어 중복 처리 방지를 위해 반려되었습니다."),
    OTHER("기타 사유로 입고 요청이 조정 또는 반려되었습니다. 상세 내용은 별도 메모를 참고하세요.");

    private final String description;

    InboundMemoCode(String description) {
        this.description = description;
    }

}
