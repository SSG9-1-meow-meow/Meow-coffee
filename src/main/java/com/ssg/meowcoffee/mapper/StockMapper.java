package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.dto.CompanyReadDTO;
import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.StockReadDTO;
import com.ssg.meowcoffee.dto.StockSearchDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StockMapper {
    List<StockReadDTO> selectStockList(@Param("criteria") Criteria criteria, @Param("searchDTO") StockSearchDTO stockSearchDTO);
    CoffeeVO selectCoffee(String cfName);
    List<StockReadDTO> selectWarehouses(Criteria criteria);
    List<CompanyReadDTO> selectCompany(Criteria criteria);
}
