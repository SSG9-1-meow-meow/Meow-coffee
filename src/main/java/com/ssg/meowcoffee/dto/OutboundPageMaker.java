package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder @ToString
public class OutboundPageMaker {
    private OutboundCriteria criteria;
    private int totalCount;
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;
    private int lastPage;

    public static OutboundPageMaker of(OutboundCriteria c, int totalCount){
        OutboundPageMaker m = new OutboundPageMaker();
        m.criteria = c;
        m.totalCount = totalCount;

        int size = Math.max(c.getSize(), 1);
        m.lastPage = (int)Math.ceil(totalCount / (double)size);

        int block = 10; // 하단에 보여줄 페이지 버튼 개수
        int cur = Math.max(c.getPage(), 1);
        int end = (int)(Math.ceil(cur / (double)block) * block);
        int start = end - (block - 1);
        if(end > m.lastPage) end = m.lastPage;
        if(start < 1) start = 1;

        m.startPage = start;
        m.endPage = end;
        m.prev = start > 1;
        m.next = end < m.lastPage;
        return m;
    }
}