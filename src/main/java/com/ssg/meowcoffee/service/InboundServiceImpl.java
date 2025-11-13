package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.domain.InboundRequestVO;
import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.mapper.InboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@Service
@Log4j2
@RequiredArgsConstructor
public class InboundServiceImpl implements InboundService {

  private final InboundMapper inboundMapper;

  @Override
  public long registerInboundRequest(InboundReqInputDTO input) {

    try {
      inboundMapper.callCreateInReq(input);
    } catch (Exception e) {
      throw new DatabaseTransactionException("입고 요청 DB 처리 중 실패했습니다.", e);
    }

    Long generatedId = input.getGeneratedInReqId();

    if (generatedId == null || generatedId == 0) {
      throw new DatabaseTransactionException("입고 요청 ID 생성에 실패했습니다. (프로시저 로직 오류 추정)");
    }

    return generatedId;
  }

  @Override
  public void modifyInboundRequest(InboundReqInputDTO input) {
    try {
      inboundMapper.callUpdateInReq(input);
    } catch (DataAccessException e) {
      // 프로시저에서 SIGNAL로 발생시킨 예외가 여기에 포함될 수 있음
      if (e.getCause() instanceof SQLException && ((SQLException) e.getCause()).getMessage().contains("permission denied")) {
        throw new RuntimeException("수정 권한이 없습니다.");
      }
      throw new RuntimeException("입고 요청 수정 중 오류가 발생했습니다.", e);
    }
  }

  @Override
  public InboundDetailDTO getInboundDetail(long inReqItemsId) {
    return inboundMapper.selectInboundDetailById(inReqItemsId);
  }


  public boolean cancelInboundRequest(long inReqId, String userId, UserRole userRole) {
    int affectedRows = inboundMapper.deleteInReq(inReqId, userId, userRole);

    // affectedRows가 1이라는 것은 업데이트가 성공했음을 의미
    if (affectedRows == 0) {
      // 업데이트가 실패한 경우 (요청이 존재하지 않거나, 권한이 없는 경우)
      throw new RuntimeException("요청을 취소할 수 없거나 권한이 없습니다.");
    }
    return true;
  }

  @Override
  public List<InboundDetailDTO> getInboundListByCriteria(InboundCriteria criteria, String userId, UserRole userRole) {
    log.info("입고 목록 조회 서비스 실행. Criteria: {}, UserID: {}", criteria, userId);

    try {
      return inboundMapper.selectInboundDetailsByCriteria(criteria, userId, userRole);
    } catch (DataAccessException e) {
      log.error("입고 목록 조회 중 데이터베이스 오류 발생", e);
      throw new RuntimeException("입고 목록을 조회하는 중 문제가 발생했습니다.", e);
    }
  }

  @Override
  public int getTotalCount(InboundCriteria criteria, String userId, UserRole userRole) {
    log.info("입고 목록 전체 건수 조회 서비스 실행. Criteria: {}, UserID: {}", criteria, userId);
    return inboundMapper.getTotalCountByCriteria(criteria, userId, userRole);
  }

  @Override
  public List<CoffeeVO> getCoffeeList() {
    return inboundMapper.selectCoffeeList();
  }

  @Override
  public List<InboundItemDetailDTO> getInboundRequestWithItems(long inReqId) {
    InboundRequestVO request = inboundMapper.selectInReqById(inReqId);
    if (request == null) {
      return null;
    }

    return inboundMapper.selectInboundItemDetailsByReqId(inReqId);
  }

  @Override
  public InboundItemDetailDTO getInboundItemDetail(long inReqItemsId) {
    return inboundMapper.selectInboundItemDetailByItemId(inReqItemsId);
  }

  @Override
  public List<WarehouseCapacityDTO> selectWarehouseCapacitiesByDate(LocalDate date) {
    return inboundMapper.selectWarehouseCapacitiesByDate(date);
  }

  @Override
  public DailyLoadDTO selectDailyLoadByDate(LocalDate date) {
    return inboundMapper.selectDailyLoadByDate(date);
  }

  // InboundServiceImpl.java
  @Override
  public List<DailyCapacityEventDTO> getDailyCapacitiesForPeriod(String startDate, String endDate) {
    return inboundMapper.selectDailyCapacitiesForPeriod(startDate, endDate);
  }

  @Override
  public List<DailyCapacityEventDTO> getAggregatedDailyCapacitiesForPeriod(String startDate, String endDate) {
    return inboundMapper.selectAggregatedDailyCapacitiesForPeriod(startDate, endDate);
  }

  @Override
  public List<DailyWarehouseCapacityDTO> getDailyWarehouseCapacitiesByDate(LocalDate selectedDate) {
    return inboundMapper.selectDailyWarehouseCapacitiesByDate(selectedDate);
  }

  // InboundServiceImpl.java
  @Override
  public List<AvailableLocationDTO> findAvailableLocations(LocalDate selectedDate, int requiredQty) {
    return inboundMapper.findAvailableLocations(selectedDate, requiredQty);
  }

  @Override
  public void finalizeInboundItem(InboundProcessDTO processDTO) {
// MyBatis의 TypeHandler가 Enum을 String으로 자동 변환해줌
    inboundMapper.finalizeInboundItem(processDTO);
  }

  @Override
  public void startInspection(long inReqItemsId) {
    int updatedRows = inboundMapper.updateInspectionTime(inReqItemsId);
    if (updatedRows == 0) {
      // 이미 검수 시간이 기록되었거나, ID가 존재하지 않는 경우
      // 필요하다면 예외를 발생시켜 컨트롤러에서 다른 응답을 주게 할 수 있음
      log.warn("{} 항목의 검수 시작 시각 업데이트에 실패했습니다. (이미 처리되었거나 존재하지 않는 항목)", inReqItemsId);
    }
  }

  // ★★★ [추가] 실물 입고 완료 처리 메소드 구현 ★★★
  @Override
  @Transactional // 여러 작업이 있다면 트랜잭션 처리
  public void completePhysicalInbound(long inReqItemsId) {
    int updatedRows = inboundMapper.completePhysicalInbound(inReqItemsId);
    if (updatedRows == 0) {
      // 업데이트가 실패한 경우 (이미 처리되었거나 조건이 맞지 않음)
      // 예외를 발생시켜 컨트롤러에서 오류 응답을 하도록 할 수 있습니다.
      throw new IllegalStateException("이미 입고 완료되었거나 처리할 수 없는 상태입니다.");
    }
    // 참고: 이 작업은 이전에 만든 'trg_add_stock_on_inbound_complete' 트리거를 자동으로 발동시켜
    // 'stock' 테이블의 재고를 업데이트하게 됩니다.
  }



}
