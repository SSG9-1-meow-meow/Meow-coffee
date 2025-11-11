package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.StockService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Log4j2
public class StockController {
    private final StockService stockService;

    @GetMapping("/stocks")
    public String stockListPage(){
        return "stock/stockSearch";
    }

    //재고 관리 controller
    @GetMapping("/api/stocks")
    public ResponseEntity<Map<String, Object>> readStockList(@ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = new StockSearchDTO(); //재고 전체 조회이니 searchDTO에 아무것도 설정 안해줘도 됨
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/stocks/category/{cfCategory}") //카테고리(대분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByCategory(@PathVariable("cfCategory") String cfCategory,
                                                                      @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfCategory(cfCategory).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/stocks/type/{cfType}") //품종(중분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByType(@PathVariable("cfType") String cfType,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfType(cfType).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/stocks/grade/{cfGrade}") //등급(소분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByGrade(@PathVariable("cfGrade") String cfGrade,
                                                                   @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfGrade(cfGrade).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/stocks/{cfName}")
    public String stockCfNamePage(@PathVariable("cfName") String cfName) {
       return "/stock/stockCfName";
    }

    @GetMapping("/api/stocks/{cfName}") //품목별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByName(@PathVariable("cfName") String cfName,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfName(cfName).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/stocks/coffee/{cfName}") //커피 정보 상세 조회
    public ResponseEntity<CoffeeDTO> readCoffeeByName(@PathVariable("cfName") String cfName) {
        CoffeeDTO coffeeDTO = stockService.getCoffee(cfName);

        return ResponseEntity.ok(coffeeDTO);
    }

    @GetMapping("/stocks/warehouse")
    public String stockWarehousePage() {
        return "/stock/stockWarehouse";
    }

    //유효성 검사 필수 (총관리자 + 일반관리자만 접속 가능) -> 추가해야함
    @GetMapping("/api/stocks/warehouse")
    public ResponseEntity<Map<String, Object>> readStocksByWarehouse(@ModelAttribute Criteria criteria) {
        List<StockReadDTO> list = stockService.getWarehouses(criteria);

        Integer total = stockService.getListCount(null, "warehouse");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/stocks/company")
    public String stockCompanyPage() {
        return "/stock/stockCompany";
    }

    //유효성 검사 필수 (총관리자+ 일반관리자만 접속 가능) -> 추가해야함
    @GetMapping("/api/stocks/company")
    public ResponseEntity<Map<String, Object>> readCompanyList(@ModelAttribute Criteria criteria) {
        List<CompanyReadDTO> list = stockService.getCompanyList(criteria);

        Integer total = stockService.getListCount(null, "company");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/dueDiligences")
    public String dueDiligenceListPage() {
        return "/stock/dueDiligenceList";
    }

    //재고 실사 controller -> 기본 페이지에서만 유효성 검사해도 됨
    @GetMapping("/api/dueDiligences")
    public ResponseEntity<Map<String, Object>> readDueDiligenceList(@ModelAttribute Criteria criteria) {
        List<DueDiligenceReadDTO> list = stockService.getDueDiligenceList(criteria);

        Integer total = stockService.getListCount(null, "dueDiligence");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/dueDiligences/{ddId}")
    public String dueDiligencePage(@PathVariable("ddId") Long ddId) {
        return "/stock/dueDiligence";
    }

    @GetMapping("/api/dueDiligences/{ddId}") //재고 실사 상세 페이지
    public ResponseEntity<DueDiligenceReadDTO> readDueDiligence(@PathVariable("ddId") Long ddId) {
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId);

        return ResponseEntity.ok(readDTO);
    }

    @GetMapping("/api/dueDiligence") //재고 실사 등록 페이지
    public ResponseEntity<List<String>> createDueDiligenceForm(){
        List<String> codeList = stockService.getWarehouseCodeList();

        return ResponseEntity.ok(codeList);
    }

    @GetMapping("/api/stocks/{stkId}/warehouse/{whCode}") //재고 실사 등록 시 정보 불러오기
    public ResponseEntity<DueDiligenceDTO> readDueDiligenceInfo(@PathVariable String stkId, @PathVariable String whCode) {
        DueDiligenceDTO dto = stockService.getDueDiligenceInfo(stkId, whCode);

        if(dto == null) return ResponseEntity.notFound().build(); //입력한 stkId가 존재하지 않을 때

        return ResponseEntity.ok(dto);
    }

    @PostMapping("/api/dueDiligence") //프론트에서 Result 받아서 -1이면 권한 없음 띄우기
    public ResponseEntity<Integer> createDueDiligence(@Valid @RequestBody DueDiligenceDTO dto) {
        Integer result = stockService.registerDueDiligence(dto);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/api/dueDiligences/{ddId}/update")
    public ResponseEntity<DueDiligenceReadDTO> updateDueDiligenceForm(@PathVariable("ddId") Long ddId){
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId);

        return ResponseEntity.ok(readDTO);
    }

    @PutMapping("/api/dueDiligences/{ddId}/update") //받은 객체가 null인 경우 권한 없음 띄우기
    public ResponseEntity<DueDiligenceReadDTO> updateDueDiligence(@PathVariable("ddId") Long ddId,
                                                                  @Valid @RequestBody DueDiligenceDTO dto) {
        dto.setDdId(ddId);

        Integer result = stockService.modifyDueDiligence(dto);
        if(result == -1) return ResponseEntity.ok(null);

        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId); //수정한 실사로그 부분 가져와서 보여주기 위해
        return ResponseEntity.ok(readDTO);
    }

    @PutMapping("/api/dueDiligences/{ddId}") //String id는 현재 로그인한 id를 말함
    public ResponseEntity<Integer> deleteDueDiligence(@PathVariable("ddId") Long ddId,
                                                      @RequestBody DueDiligenceDTO dueDiligenceDTO) {
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId); //현재 정보를 불러와야 권한 확인 가능
        dueDiligenceDTO.setDdId(ddId);
        dueDiligenceDTO.setWhCode(readDTO.getWhCode());

        Integer result = stockService.removeDueDiligence(dueDiligenceDTO);
        return ResponseEntity.ok(result);
        //프론트에서 받은 값이 -1이라면 권한 없음 띄우기
    }

    @GetMapping("/api/dueDiligences/{ddId}/{ddApproval}")//프론트에서 버튼에 따라 ddApproval이 정해져서 유효성검사 필요없음
    public ResponseEntity<Integer> updateApprovalStatus(@PathVariable("ddApproval") String ddApproval,
                                                        @PathVariable("ddId") Long ddId) {
        Integer result = stockService.modifyApprovalStatus(ddApproval, ddId);
        //result값이 0이면 승인/거부 할 수 있는 상태가 아님
        return ResponseEntity.ok(result);
    }
}
