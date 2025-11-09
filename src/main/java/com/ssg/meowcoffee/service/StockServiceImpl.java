package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.mapper.StockMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class StockServiceImpl implements StockService{

    private final StockMapper stockMapper;
    private final ModelMapper modelMapper;

    @Override
    public List<StockReadDTO> getStockList(Criteria criteria, StockSearchDTO stockSearchDTO) {
        try {
            List<StockReadDTO> list = stockMapper.selectStockList(criteria, stockSearchDTO);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 조회 리스트를 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    public CoffeeDTO getCoffee(String cfName) {
        try {
            CoffeeVO cfVO = stockMapper.selectCoffee(cfName);

            return modelMapper.map(cfVO, CoffeeDTO.class);
        } catch (Exception e) {
            throw new DatabaseTransactionException("커피 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    public List<StockReadDTO> getWarehouses(Criteria criteria) {
        try {
            List<StockReadDTO> list = stockMapper.selectWarehouses(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 현황 목록을 DB에서 불러오는 중 오류 발생");
        }

    }

    @Override
    public List<CompanyReadDTO> getCompanyList(Criteria criteria) {
        try {
            List<CompanyReadDTO> list = stockMapper.selectCompanyList(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("거래처 현황 목록을 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    public List<DueDiligenceReadDTO> getDueDiligenceList(Criteria criteria) {
        try {
            List<DueDiligenceReadDTO> list = stockMapper.selectDueDiligenceList(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 목록을 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    public DueDiligenceReadDTO getDueDiligence(Long ddId) {
        try {
            DueDiligenceReadDTO dto = stockMapper.selectDueDiligence(ddId);

            return dto;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }

    @Override
    @Transactional
    public Integer registerDueDiligence(DueDiligenceDTO dueDiligenceDTO) {
        try {//권한 확인
            Integer checked = stockMapper.selectDueDiligenceAuthority(dueDiligenceDTO.getWhCode(), dueDiligenceDTO.getMaId());

            if(checked <= 0) return -1; //로그인한 사람이 해당 창고의 관리자가 아닌경우
        } catch (Exception e) {
            throw new DatabaseTransactionException("관리자 권한 확인 중 DB에서 오류 발생");
        }

        try {
            Integer result = stockMapper.insertDueDiligence(dueDiligenceDTO);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 등록 중 DB에서 오류 발생");
        }
    }

    @Override
    @Transactional
    public Integer modifyDueDiligence(DueDiligenceDTO dueDiligenceDTO) {
        try {//권한 확인
            Integer checked = stockMapper.selectDueDiligenceAuthority(dueDiligenceDTO.getWhCode(), dueDiligenceDTO.getMaId());

            if(checked <= 0) return -1; //로그인한 사람이 해당 창고의 관리자가 아닌경우
        } catch (Exception e) {
            throw new DatabaseTransactionException("관리자 권한 확인 중 DB에서 오류 발생");
        }

        try {
            Integer result = stockMapper.updateDueDiligence(dueDiligenceDTO);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 수정 중 DB에서 오류 발생");
        }
    }

    @Override
    @Transactional
    public Integer removeDueDiligence(DueDiligenceDTO dueDiligenceDTO) {
        try {//권한 확인
            Integer checked = stockMapper.selectDueDiligenceAuthority(dueDiligenceDTO.getWhCode(), dueDiligenceDTO.getMaId());

            if(checked <= 0) return -1; //로그인한 사람이 해당 창고의 관리자가 아닌경우
        } catch (Exception e) {
            throw new DatabaseTransactionException("관리자 권한 확인 중 DB에서 오류 발생");
        }

        try {
            Integer result = stockMapper.deleteDueDiligence(dueDiligenceDTO.getDdId());

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 삭제 중 DB에서 오류 발생");
        }
    }

    @Override
    public DueDiligenceDTO getDueDiligenceInfo(String stkId, String whCode) {
        try {
            DueDiligenceDTO dto = stockMapper.selectDueDiligenceInfo(stkId, whCode);

            return dto;
        } catch (Exception e) {
            throw new DatabaseTransactionException("시스템 재고 조회 중 DB에서 오류 발생");
        }
    }

    @Override
    @Transactional
    public Integer modifyApprovalStatus(String ddApproval, Long ddId) {
        try {
            Integer result = stockMapper.updateApprovalStatus(ddApproval, ddId);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 승인/거부 중 DB에서 오류 발생");
        }
    }

    @Override
    public List<String> getWarehouseCodeList() {
        try {
            List<String> list = stockMapper.selectWarehouseCodeList();

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 코드 리스트 조회 중 DB에서 오류 발생");
        }
    }

    @Override
    public Integer getListCount(StockSearchDTO stockSearchDTO, String menu) {
        Integer result = 0;
        try {
            switch(menu.trim()){
                case "stock" -> result = stockMapper.countStockTotal(stockSearchDTO);
                case "dueDiligence" -> result = stockMapper.countDueDiligenceTotal();
                case "warehouse" -> result = stockMapper.countWarehouseTotal();
                case "company" -> result = stockMapper.countCompanyTotal();
            }

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("리스트 total 개수 구하는 중 DB에서 오류 발생");
        }
    }
}
