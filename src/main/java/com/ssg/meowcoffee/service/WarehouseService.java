package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.WarehouseDTO;
import com.ssg.meowcoffee.dto.WarehouseSearchDTO;
import com.ssg.meowcoffee.dto.WarehouseUpdateDTO;

import java.util.List;

public interface WarehouseService {

    List<WarehouseDTO> getWarehouseList(WarehouseSearchDTO searchDTO, Criteria criteria);

    WarehouseDTO getWarehouse(String whName);

    Integer registerWarehouse(WarehouseDTO warehouse);

    Integer modifyWarehouse(WarehouseUpdateDTO warehouse);

    List<WarehouseDTO> getWarehouseSearchList (WarehouseSearchDTO searchDTO);

    Integer countListTotal(WarehouseSearchDTO searchDTO);

}

