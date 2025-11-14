package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.*;

import java.time.LocalDate;
import java.util.List;

public interface InboundService {

  long registerInboundRequest(InboundReqInputDTO input);
  boolean cancelInboundRequest(long inReqId, String userId, UserRole userRole);
  void modifyInboundRequest(InboundReqInputDTO input);
  InboundDetailDTO getInboundDetail(long inReqItemsId);

  List<InboundDetailDTO> getInboundListByCriteria(InboundCriteria criteria, String userId, UserRole userRole);
  int getTotalCount(InboundCriteria criteria, String userId, UserRole userRole);

  List<CoffeeVO> getCoffeeList();
  List<InboundItemDetailDTO> getInboundRequestWithItems(long inReqId);
  InboundItemDetailDTO getInboundItemDetail(long inReqItemsId);

  List<WarehouseCapacityDTO> selectWarehouseCapacitiesByDate(LocalDate date);
  DailyLoadDTO selectDailyLoadByDate(LocalDate date);

  List<DailyCapacityEventDTO> getDailyCapacitiesForPeriod(String startDate, String endDate);

  List<DailyCapacityEventDTO> getAggregatedDailyCapacitiesForPeriod(String startDate, String endDate);
  List<DailyWarehouseCapacityDTO> getDailyWarehouseCapacitiesByDate(LocalDate selectedDate);

  // InboundService.java
  List<AvailableLocationDTO> findAvailableLocations(LocalDate selectedDate, int requiredQty);

  void finalizeInboundItem(InboundProcessDTO processDTO);
  void startInspection(long inReqItemsId);
  void completePhysicalInbound(long inReqItemsId);






}
