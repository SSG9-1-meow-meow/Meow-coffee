package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.WarehouseVO;
import com.ssg.meowcoffee.dto.Criteria;

import com.ssg.meowcoffee.dto.WarehouseSearchDTO;
import com.ssg.meowcoffee.dto.WarehouseUpdateDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
@Mapper
@Repository
public interface WarehouseMapper {

    List<WarehouseVO> selectWarehouseList(@Param("searchDTO") WarehouseSearchDTO searchDTO,
                                          @Param("criteria") Criteria criteria);

    WarehouseVO selectWarehouse(@Param("whName") String whName);

    Integer insertWarehouse(WarehouseVO warehouse);

    Integer updateWarehouse(WarehouseUpdateDTO warehouse);

    List<WarehouseVO> selectSearchList(@Param("searchDTO") WarehouseSearchDTO searchDTO);

    Integer countWarehouseTotal(@Param("searchDTO") WarehouseSearchDTO searchDTO);
}
