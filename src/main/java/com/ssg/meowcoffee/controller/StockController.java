package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.StockService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Log4j2
public class StockController {
    private final StockService stockService;

    //재고 관리 controller
    @GetMapping("/stocks")
    public ResponseEntity<List<StockReadDTO>> readStockList(@ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = new StockSearchDTO(); //재고 전체 조회이니 searchDTO에 아무것도 설정 안해줘도 됨
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/stocks/category/{cfCategory}") //카테고리(대분류)별 재고 조회
    public ResponseEntity<List<StockReadDTO>> readStockListByCategory(@PathVariable("cfCategory") String cfCategory,
                                                                      @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfCategory(cfCategory).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/stocks/type/{cfType}") //품종(중분류)별 재고 조회
    public ResponseEntity<List<StockReadDTO>> readStockListByType(@PathVariable("cfType") String cfType,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfType(cfType).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/stocks/grade/{cfGrade}") //등급(소분류)별 재고 조회
    public ResponseEntity<List<StockReadDTO>> readStockListByGrade(@PathVariable("cfGrade") String cfGrade,
                                                                   @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfGrade(cfGrade).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/stocks/{cfName}") //품목별 재고 조회
    public ResponseEntity<List<StockReadDTO>> readStockListByName(@PathVariable("cfName") String cfName,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfName(cfName).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/stocks/coffee/{cfName}") //커피 정보 상세 조회
    public ResponseEntity<CoffeeDTO> readCoffeeByName(@PathVariable("cfName") String cfName) {
        CoffeeDTO coffeeDTO = stockService.getCoffee(cfName);

        return ResponseEntity.ok(coffeeDTO);
    }

    //유효성 검사 필수 (총관리자 + 일반관리자만 접속 가능) -> 추가해야함
    @GetMapping("/stocks/warehouse")
    public ResponseEntity<List<StockReadDTO>> readStocksByWarehouse(@ModelAttribute Criteria criteria) {
        List<StockReadDTO> list = stockService.getWarehouses(criteria);

        return ResponseEntity.ok(list);
    }

    //유효성 검사 필수 (총관리자+ 일반관리자만 접속 가능) -> 추가해야함
    @GetMapping("/stocks/company")
    public ResponseEntity<List<CompanyReadDTO>> readCompanyList(@ModelAttribute Criteria criteria) {
        List<CompanyReadDTO> list = stockService.getCompanyList(criteria);

        return ResponseEntity.ok(list);
    }


    //재고 실사 controller -> 기본 페이지에서만 유효성 검사해도 됨
    @GetMapping("/dueDiligences")
    public ResponseEntity<List<DueDiligenceReadDTO>> readDueDiligenceList(@ModelAttribute Criteria criteria) {
        List<DueDiligenceReadDTO> list = stockService.getDueDiligenceList(criteria);

        return ResponseEntity.ok(list);
    }

    @GetMapping("/dueDiligences/{ddId}") //재고 실사 상세 페이지
    public ResponseEntity<DueDiligenceReadDTO> readDueDiligence(@PathVariable("ddId") Long ddId) {
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId);

        return ResponseEntity.ok(readDTO);
    }

    @GetMapping("/dueDiligence") //재고 실사 등록 페이지
    public ResponseEntity<List<String>> createDueDiligenceForm(){
        List<String> codeList = stockService.getWarehouseCodeList();

        return ResponseEntity.ok(codeList);
    }

    @GetMapping("/stocks/{stkId}/warehouse/{whCode}") //재고 실사 등록 시 정보 불러오기
    public ResponseEntity<DueDiligenceDTO> readDueDiligenceInfo(@PathVariable String stkId, @PathVariable String whCode) {
        DueDiligenceDTO dto = stockService.getDueDiligenceInfo(stkId, whCode);

        return ResponseEntity.ok(dto);
    }

    @PostMapping("/dueDiligence") //프론트에서 Result 받아서 -1이면 권한 없음 띄우기
    public ResponseEntity<Integer> createDueDiligence(@Valid @RequestBody DueDiligenceDTO dto) {
        Integer result = stockService.registerDueDiligence(dto);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/dueDiligences/{ddId}/update")
    public ResponseEntity<DueDiligenceReadDTO> updateDueDiligenceForm(@PathVariable("ddId") Long ddId){
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId);

        return ResponseEntity.ok(readDTO);
    }

    @PutMapping("/dueDiligences/{ddId}/update") //받은 객체가 null인 경우 권한 없음 띄우기
    public ResponseEntity<DueDiligenceReadDTO> updateDueDiligence(@PathVariable("ddId") Long ddId,
                                                                  @Valid @RequestBody DueDiligenceDTO dto) {
        dto.setDdId(ddId);

        Integer result = stockService.modifyDueDiligence(dto);
        if(result == -1) return ResponseEntity.ok(null);

        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId); //수정한 실사로그 부분 가져와서 보여주기 위해
        return ResponseEntity.ok(readDTO);
    }

    @PutMapping("/dueDiligences/{ddId}") //String id는 현재 로그인한 id를 말함
    public ResponseEntity<Integer> deleteDueDiligence(@PathVariable("ddId") Long ddId,
                                                      @RequestBody String id) {
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId); //현재 정보를 불러와야 권한 확인 가능
        DueDiligenceDTO dto = DueDiligenceDTO.builder()
                .ddId(ddId)
                .whCode(readDTO.getWhCode())
                .maId(id)
                .build();
        Integer result = stockService.removeDueDiligence(dto);
        return ResponseEntity.ok(result);
        //프론트에서 받은 값이 -1이라면 권한 없음 띄우기
    }

    @GetMapping("/dueDiligences/{ddId}/{ddApproval}")//프론트에서 버튼에 따라 ddApproval이 정해져서 유효성검사 필요없음
    public ResponseEntity<Integer> updateApprovalStatus(@PathVariable("ddApproval") String ddApproval,
                                                        @PathVariable("ddId") Long ddId) {
        Integer result = stockService.modifyApprovalStatus(ddApproval, ddId);

        return ResponseEntity.ok(result);
    }
}
