package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.dto.*;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class StockMapperTests {
    @Autowired(required = false)
    private StockMapper stockMapper;

    @Test
    public void selectStockListTest() {
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        StockSearchDTO stockSearchDTO = new StockSearchDTO();

        //전체 조회
        List<StockReadDTO> totalList = stockMapper.selectStockList(criteria, stockSearchDTO);

        totalList.forEach(i -> log.info(i));
    }

    @Test
    public void selectStockListTest2() {
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        StockSearchDTO stockSearchDTO = new StockSearchDTO();
        stockSearchDTO.setCfCategory("B01");

        //대분류, 중분류, 소분류별 , 창고명별 조회
        List<StockReadDTO> categoryList = stockMapper.selectStockList(criteria, stockSearchDTO);

        categoryList.forEach(i -> log.info(i));
    }

    @Test
    public void selectStockTest() {
        //커피 상세 정보 조회 테스트
        String cfName = "에티오피아 예가체프";

        CoffeeVO coffeeVO = stockMapper.selectCoffee(cfName);
        log.info(coffeeVO.getCfId() + " " + coffeeVO.getCfGrade());
    }

    @Test
    public void selectWarehousesTest() {
        //창고별 재고 조회
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        List<StockReadDTO> list = stockMapper.selectWarehouses(criteria);
        list.forEach(i -> log.info(i));
    }

    //거래처 현황 조회는 거래처 테이블 생성 후 test 가능.
    //거래처 현황 조회 test 가능
    @Test
    public void selectCompanyListTest() {
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        List<CompanyReadDTO> list = stockMapper.selectCompanyList(criteria);

        list.forEach( i -> log.info(i.getComEmail()));
    }

    //재고 실사 test
    @Test
    public void selectDueDiligenceListTest(){
        //재고실사 현황 리스트 테스트
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        List<DueDiligenceReadDTO> list = stockMapper.selectDueDiligenceList(criteria);
        list.forEach(i -> log.info(i));
    }

    @Test
    public void selectDueDiligenceTest(){
        //재고 실사 개별 상세 조회 테스트
        DueDiligenceReadDTO dto = stockMapper.selectDueDiligence(4L);

        log.info(dto);
    }

    @Test
    public void insertDueDiligenceTest(){
        DueDiligenceDTO dueDiligenceDTO = DueDiligenceDTO.builder()
                .stkId("STK005")
                .realStkQuantity(59)
                .ddLog("1개가 불량품임")
                .maId("manager05")
                .build();

        Integer result = stockMapper.insertDueDiligence(dueDiligenceDTO);
        log.info("결과: "+ result);
    }

    @Test
    public void updateDueDiligenceTest(){
        DueDiligenceDTO dueDiligenceDTO = DueDiligenceDTO.builder()
                .ddId(6L)
                .stkQuantity(60)
                .realStkQuantity(58)
                .ddLog("불량품 1개 더 발견해서 총 2개임")
                .build();

        Integer result = stockMapper.updateDueDiligence(dueDiligenceDTO);
        log.info("결과: "+ result);
    }

    @Test
    public void deleteDueDiligenceTest(){
        Integer result = stockMapper.deleteDueDiligence(5L);

        log.info("결과: "+ result);
    }

    @Test
    public void selectDueDiligenceInfoTest(){
        //프론트로 정보 가져오기 위해 실행하는 메소드임
        DueDiligenceDTO dueDiligenceDTO = stockMapper.selectDueDiligenceInfo("STK005", "WH003");
        log.info("시스템 재고 가져오기: "+ dueDiligenceDTO.getStkQuantity());
    }

    @Test
    public void updateApprovalStatusTest() {
//        총관리자가 승인 또는 거절 버튼을 누를때 실행되는 프로시저 테스트
        Integer result = stockMapper.updateApprovalStatus("APPROVED" , 6L);
        log.info("결과: " + result);

//        거절하는 경우
        Integer result2 = stockMapper.updateApprovalStatus("REJECTED" , 2L);
        log.info("결과: " + result2);
    }

    //일반관리자 id와 실사로그에 기록된 id를 비교하는 권한 확인 작업은 관리자 테이블에 데이터가 들어간 경우만 가능
    //테스트 실행
    @Test
    public void dueDiligenceAuthoriyTest() {
        Integer result = stockMapper.selectDueDiligenceAuthority("WH001", "manager_choi");
        //일치하는 경우 -> 1

        result = stockMapper.selectDueDiligenceAuthority("WH001", "manager_lee");
        //일치하지 않는 경우 -> 0

        log.info("결과 행의 수: "+ result);
    }

}
