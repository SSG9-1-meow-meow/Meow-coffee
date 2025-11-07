package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.StockReadDTO;
import com.ssg.meowcoffee.dto.StockSearchDTO;
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
    public void selectStockListTest(){
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        StockSearchDTO stockSearchDTO = new StockSearchDTO();

        //전체 조회
        List<StockReadDTO> totalList = stockMapper.selectStockList(criteria,stockSearchDTO);

        totalList.forEach(i -> log.info(i));
    }

    @Test
    public void selectStockListTest2(){
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        StockSearchDTO stockSearchDTO = new StockSearchDTO();
        stockSearchDTO.setCfCategory("B01");

        //대분류, 중분류, 소분류별 , 창고명별 조회
        List<StockReadDTO> categoryList = stockMapper.selectStockList(criteria,stockSearchDTO);

        categoryList.forEach(i -> log.info(i));
    }

    @Test
    public void selectStockTest(){
        //커피 상세 정보 조회 테스트
        String cfName = "에티오피아 예가체프";

        CoffeeVO coffeeVO = stockMapper.selectCoffee(cfName);
        log.info(coffeeVO.getCfId() + " " + coffeeVO.getCfGrade());
    }

    @Test
    public void selectWarehousesTest(){
        //창고별 재고 조회
        Criteria criteria = new Criteria();
        criteria.setAmount(10);

        List<StockReadDTO> list = stockMapper.selectWarehouses(criteria);
        list.forEach(i -> log.info(i));
    }

    //거래처 현황 조회는 거래처 테이블 생성 후 test 가능. sql문은 작성해놨음.
}
