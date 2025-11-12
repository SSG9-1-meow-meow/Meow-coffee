package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.WarehouseVO;
import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.WarehouseDTO;
import com.ssg.meowcoffee.dto.WarehouseSearchDTO;
import com.ssg.meowcoffee.dto.WarehouseUpdateDTO;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.mapper.WarehouseMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Log4j2
public class WarehouseServiceImpl implements WarehouseService {

    private final WarehouseMapper warehouseMapper;
    private final ModelMapper modelMapper;

    @Override
    @Transactional(readOnly = true)
    public List<WarehouseDTO> getWarehouseList(WarehouseSearchDTO searchDTO, Criteria criteria) {
        try {
            log.info("창고 전체 조회 요청: searchDTO={}, criteria={}", searchDTO, criteria);

            List<WarehouseDTO> list = warehouseMapper.selectWarehouseList(searchDTO,criteria).stream().
                    map(vo -> modelMapper.map(vo, WarehouseDTO.class)).collect(Collectors.toList());

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 리스트를 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public WarehouseDTO getWarehouse(String whName) {
        try {
            log.info("창고 이름 조회 요청: whName={}", whName);

            WarehouseDTO dto = modelMapper.map(warehouseMapper.selectWarehouse(whName), WarehouseDTO.class);

            return dto;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }


    @Override
    @Transactional
    public Integer registerWarehouse(WarehouseDTO warehouse) {
        try {
            log.info("창고 등록 요청: {}", warehouse);

            WarehouseVO vo = modelMapper.map(warehouse, WarehouseVO.class);

            return warehouseMapper.insertWarehouse(vo);
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고를 등록하는 중 DB에서 오류 발생");
        }
    }

    @Override
    @Transactional
    public Integer modifyWarehouse(WarehouseUpdateDTO warehouse) {
        try {
            log.info("창고 수정 요청: {}", warehouse);

            return warehouseMapper.updateWarehouse(warehouse);
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고를 수정하는 중 DB에서 오류 발생");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<WarehouseDTO> getWarehouseSearchList(WarehouseSearchDTO searchDTO) {
        try {
            log.info("창고 조건 검색 요청: searchDTO={}, criteria={}", searchDTO);

            List<WarehouseDTO> list = warehouseMapper.selectSearchList(searchDTO).stream()
                    .map(vo -> modelMapper.map(vo, WarehouseDTO.class)).collect(Collectors.toList());

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 검색 리스트 요청 중 DB에서 오류 발생");
        }
    }

    @Override
    public Integer countListTotal(WarehouseSearchDTO searchDTO) {
        try {
            Integer result = warehouseMapper.countWarehouseTotal(searchDTO);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("리스트 전체 개수 조회 중 DB에서 오류 발생");
        }
    }
}
