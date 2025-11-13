package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.domain.WarehouseVO;
import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
@RequiredArgsConstructor
@Log4j2
public class WarehouseController {

    private final WarehouseService warehouseService;

//    페이지 이동
    @GetMapping("/warehouses")
    public String warehouseListPage(){
        return "/warehouse/warehouseMain";
    }

    @GetMapping("/warehouses/map")
    public String warehouseMapPage(){
        return "/warehouse/warehouseMap";
    }

    @GetMapping("/api/warehouses/search")
    public ResponseEntity<Map<String, Object>> readWarehouseSearchList(@AuthenticationPrincipal CustomUserDetails customUserDetails){
        //일반관리자, 총관리자만 접근 가능
        String role = customUserDetails.getAuthorities().iterator().next().getAuthority();

        if(!role.equals("ROLE_ADMIN") && !role.equals("ROLE_MANAGER")){
            //권한 없음
            return ResponseEntity.ok(null);
        }

        WarehouseSearchDTO searchDTO = WarehouseSearchDTO.builder().whAddress("address").build();
        List<WarehouseDTO> addressList = warehouseService.getWarehouseSearchList(searchDTO); //주소 목록
        searchDTO.setWhAddress(null); searchDTO.setWhName("name");
        List<WarehouseDTO> nameList = warehouseService.getWarehouseSearchList(searchDTO); //창고명 목록
        searchDTO.setWhName(null); searchDTO.setWhGrade("grade");
        List<WarehouseDTO> gradeList = warehouseService.getWarehouseSearchList(searchDTO); //창고 등급 목록
        searchDTO.setWhGrade(null);
        //지도에 띄울 전체 주소 가져오기
        List<WarehouseDTO> fullAddressList = warehouseService.getWarehouseSearchList(searchDTO);

        Map<String, Object> response = new HashMap<>();
        response.put("addressList", addressList);
        response.put("nameList", nameList);
        response.put("gradeList", gradeList);
        response.put("fullAddressList", fullAddressList);
        return ResponseEntity.ok(response);
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
    public ResponseEntity<Integer> createWarehouse(@Valid @RequestBody WarehouseDTO warehouse, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //총관리자 인지 권한 확인 필수
        String role = customUserDetails.getAuthorities().iterator().next().getAuthority();
        if(!role.equals("ROLE_ADMIN")) return ResponseEntity.ok(-1);

        Integer result = warehouseService.registerWarehouse(warehouse);

        return ResponseEntity.ok(result);
    }

    // MODIFY2: 창고 수정(모달로 처리)
    @PutMapping("/api/warehouses/{whCode}/update")
    public ResponseEntity<Integer> updateWarehouse(@PathVariable("whCode") String whCode, @RequestBody WarehouseUpdateDTO warehouse
    , @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        String role = customUserDetails.getAuthorities().iterator().next().getAuthority();
        if(!role.equals("ROLE_ADMIN")) return ResponseEntity.ok(-1);

        warehouse.setWhCode(whCode);

        Integer result = warehouseService.modifyWarehouse(warehouse);
        return ResponseEntity.ok(result);
    }

}

