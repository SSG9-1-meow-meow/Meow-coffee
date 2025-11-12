package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.domain.WarehouseVO;
import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@RestController
@RequiredArgsConstructor
@Log4j2
public class WarehouseController {

    private final WarehouseService warehouseService;

//    페이지 이동
    @GetMapping("/warehouses")
    public String warehouseListPage(){
        return "warehouse/warehouseMain";
    }

    @GetMapping("/warehouses/map")
    public String warehouseMapPage(){
        return "warehouse/warehouseMap";
    }

    @GetMapping("/api/warehouses/search")
    public ResponseEntity<List<WarehouseDTO>> readWarehouseSearchList(){

    }

    // MAIN: 전체 창고 조회
    @GetMapping("/api/warehouses")
    public ResponseEntity<Map<String, Object>> readWarehouseList(@ModelAttribute Criteria criteria) {
        WarehouseSearchDTO searchDTO = new WarehouseSearchDTO(); // 전체 조회는 할당만 해서 넘기기

        List<WarehouseDTO> list = warehouseService.getWarehouseList(searchDTO, criteria);

        Integer total = warehouseService.countListTotal(searchDTO);
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

    // PRODUCT1: 창고 상세 조회 (whName 기준)
    @GetMapping("/api/warehouses/{whName}")
    public ResponseEntity<WarehouseDTO> readWarehouse(@PathVariable String whName) {
        WarehouseDTO warehouse = warehouseService.getWarehouse(whName);

        return warehouse != null ? ResponseEntity.ok(warehouse) : ResponseEntity.notFound().build();
    }

    // READ2: 주소별 조회
    @GetMapping("/api/warehouses/address/{whAddress}")
    public ResponseEntity<Map<String, Object>> readWarehouseListByAddr(@PathVariable("whAddress") String whAddress, @ModelAttribute Criteria criteria) {
        WarehouseSearchDTO searchDTO = WarehouseSearchDTO.builder().whAddress(whAddress).build();

        List<WarehouseDTO> list = warehouseService.getWarehouseList(searchDTO, criteria);

        Integer total = warehouseService.countListTotal(searchDTO);
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

    // READ3: 이름별 조회
    @GetMapping("/api/warehouses/name/{whName}")
    public ResponseEntity<Map<String, Object>> readWarehouseListByName(@PathVariable("whName") String whName, @ModelAttribute Criteria criteria) {
        WarehouseSearchDTO searchDTO = WarehouseSearchDTO.builder().whName(whName).build();

        List<WarehouseDTO> list = warehouseService.getWarehouseList(searchDTO, criteria);

        Integer total = warehouseService.countListTotal(searchDTO);
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

    // READ4: 등급별 조회
    @GetMapping("/api/warehouses/grade/{whGrade}")
    public ResponseEntity<Map<String, Object>> readWarehouseListByGrade(@PathVariable("whGrade") String whGrade, @ModelAttribute Criteria criteria) {
        WarehouseSearchDTO searchDTO = WarehouseSearchDTO.builder().whGrade(whGrade).build();

        List<WarehouseDTO> list = warehouseService.getWarehouseList(searchDTO, criteria);

        Integer total = warehouseService.countListTotal(searchDTO);
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

    // REGISTER2: 창고 등록 (모달로 처리)
    @PostMapping("/api/warehouse")
    public ResponseEntity<Integer> registerWarehouse(@Valid @RequestBody WarehouseDTO warehouse) {
        Integer result = warehouseService.registerWarehouse(warehouse);

        return ResponseEntity.ok(result);
    }

    // MODIFY2: 창고 수정(모달로 처리)
    @PutMapping("/api/warehouses/{whId}/update")
    public ResponseEntity<Integer> updateWarehouse(@PathVariable("whId") Long whId, @RequestBody WarehouseUpdateDTO warehouse) {
        warehouse.setWhId(whId);

        Integer result = warehouseService.modifyWarehouse(warehouse);
        return ResponseEntity.ok(result);
    }

}

