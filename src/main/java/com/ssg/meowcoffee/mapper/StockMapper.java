package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.dto.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StockMapper {
    List<StockReadDTO> selectStockList(@Param("criteria") Criteria criteria, @Param("searchDTO") StockSearchDTO stockSearchDTO);
    CoffeeVO selectCoffee(String cfName);
    List<StockReadDTO> selectWarehouses(Criteria criteria);
    List<CompanyReadDTO> selectCompany(Criteria criteria);

    List<DueDiligenceReadDTO> selectDueDiligenceList(Criteria criteria);
    DueDiligenceReadDTO selectDueDiligence(Long ddId);

    Integer insertDueDiligence(@Param("insertDTO") DueDiligenceDTO dueDiligenceDTO);
    Integer updateDueDiligence(@Param("updateDTO") DueDiligenceDTO dueDiligenceDTO);
    Integer deleteDueDiligence(Long ddId);
    DueDiligenceDTO selectDueDiligenceInfo(@Param("stkId") String stkId, @Param("whCode") String whCode);
    Integer updateApprovalStatus(@Param("ddApproval") String ddApproval, @Param("ddId") Long ddId);
    Integer selectDueDiligenceAuthority(@Param("whCode") String whCode, @Param("maId") String maId);

}
