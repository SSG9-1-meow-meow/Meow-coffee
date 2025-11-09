package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.*;

import java.util.List;

public interface StockService {
    List<StockReadDTO> getStockList(Criteria criteria, StockSearchDTO stockSearchDTO);
    CoffeeDTO getCoffee(String cfName);
    List<StockReadDTO> getWarehouses(Criteria criteria);
    List<CompanyReadDTO> getCompanyList(Criteria criteria);

    List<DueDiligenceReadDTO> getDueDiligenceList(Criteria criteria);
    DueDiligenceReadDTO getDueDiligence(Long ddId);
    Integer registerDueDiligence(DueDiligenceDTO dueDiligenceDTO);
    Integer modifyDueDiligence(DueDiligenceDTO dueDiligenceDTO);
    Integer removeDueDiligence(DueDiligenceDTO dueDiligenceDTO);
    DueDiligenceDTO getDueDiligenceInfo(String stkId, String whCode);
    Integer modifyApprovalStatus(String ddApproval, Long ddId);

    List<String> getWarehouseCodeList();
    Integer getListCount(StockSearchDTO stockSearchDTO, String menu);
}
