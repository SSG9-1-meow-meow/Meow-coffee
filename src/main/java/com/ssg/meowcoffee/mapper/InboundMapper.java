package com.ssg.meowcoffee.mapper;


import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.domain.InboundItemVO;
import com.ssg.meowcoffee.domain.InboundRequestVO;
import com.ssg.meowcoffee.domain.UserRole;

import java.time.LocalDate;
import java.util.List;

import com.ssg.meowcoffee.dto.*;
import org.apache.ibatis.annotations.Param;

public interface InboundMapper {


  void callCreateInReq(InboundReqInputDTO input);
  void callUpdateInReq(InboundReqInputDTO input);
  int deleteInReq(@Param("inReqId") Long inReqId,
                  @Param("userId") String userId,
                  @Param("userRole") UserRole userRole);

  // 입고 관리 목록 전체 필터링, 권한별 조회를 위함.
  List<InboundReqItemDTO> selectInReqItemList(
      @Param("criteria") InboundCriteria criteria,
      @Param("userId") String userId,
      @Param("userRole") UserRole userRole
  );

  List<CoffeeVO> selectCoffeeList();
  InboundRequestVO selectInReqById(@Param("inReqId") long inReqId);
  List<InboundItemVO> selectInItemsByReqId(@Param("inReqId") long inReqId);
  InboundItemVO selectInItemById(@Param("inReqItemsId") long inReqItemsId);

  /*
  관리자의 입/출고 대시보드를 위한 매퍼
   */
  // 미승인 요청 건수 조회 : 입고 상태가 승인대기인 경우
  int countUnapprovedInItems();

  // 승인 완료 건수 조회 : 입고 상태가 승인 완료인 경우
  int countApprovedInItems();

  // 입고 완료 처리 필요 건수 조회 : 검수 시작 시각이 NULL이 아닌 경우
  int countPendingReceivedInItems();

  // 특정 아이템의 입고 일시를 NULL로 변경
  void updateReceiveTimeToNullForTest(@Param("inReqItemsId") long inReqItemsId);

  // 출고인 경우 똑같음
  int countUnapprovedOutItems();
  int countApprovedOutItems();
  int countPendingReceivedOutItems();
  void updateOutReceiveTimeToNullForTest(@Param("outReqItemsId") long outReqItemsId);

  // 입출고 차트 - 최근 한달, 최근 1년
  List<InOutChartDTO> selectInDailyRecvStatsForLastMonth();
  List<InOutChartDTO> selectOutDailyShipStatsForLastMonth();

  List<InOutChartDTO> selectInMonthlyRecvStatsForLastYear();
  List<InOutChartDTO> selectOutMonthlyShipStatsForLastYear();

  // 테스트용: 입고 완료 상태의 아이템을 특정 날짜로 직접 삽입
  void insertCompletedItemForTest(InboundItemVO item);

  // [대시보드] 최근 한 달(30일)간 입/출고 완료된 수량 기준 상위 3개 커피를 조회합니다.
  List<TopInOutCoffeeDTO> selectTopCoffeeByReceivedInboundForLastMonth();
  List<TopInOutCoffeeDTO> selectTopCoffeeByShippedOutboundForLastMonth();

  // 테스트용: 특정 요청일시로 inboundRequests 데이터 삽입
  void insertRequestForTest(InboundRequestVO request);

  /**
   * [대시보드] 최근 한 달(30일)간 완료된 입고 건들의 '평균' 리드타임(시간)을 조회합니다.
   * @return 평균 리드타임 (결과가 없으면 null)
   */
  Double selectAvgInLeadTimeForLastMonth();
  Double selectAvgOutLeadTimeForLastMonth();

  /**
   * [차트] 최근 일 년간 월별 평균 입고 리드타임(시간)을 조회합니다. (이전과 동일)
   * @return 월별 평균 리드타임 리스트
   */
  List<InOutChartDTO> selectMonthlyAvgInLeadTimeForLastYear();
  List<InOutChartDTO> selectMonthlyAvgOutLeadTimeForLastYear();

  /**[관리자] 특정 날짜의 창고별 잔여 수용 능력을 조회합니다.*/
  List<WarehouseCapacityDTO> selectWarehouseCapacitiesByDate(@Param("selectedDate") LocalDate selectedDate);

  /**[관리자] 특정 날짜의 일별 처리/인력/장비 부하를 조회합니다.*/
  DailyLoadDTO selectDailyLoadByDate(@Param("selectedDate") LocalDate selectedDate);

  /**
   * [관리자] 특정 날짜에 특정 수용량을 감당할 수 있는 모든 창고와,
   * 각 창고에 속한 모든 Zone 목록을 조회합니다.
   * @param targetDate   조회할 미래 날짜
   * @param requiredCapa 필요한 잔여 수용량
   * @return 할당 가능한 창고 및 Zone 정보 리스트
   */
  List<AssignableWarehouseDTO> selectAssignableWarehouses(
          @Param("targetDate") LocalDate targetDate,
          @Param("requiredCapa") int requiredCapa
  );


  // [관리자] 입고 상세 항목 처리 프로시저 콜 
  void finalizeInboundItem(InboundProcessDTO processDTO);

  int updateInspectionTime(Long inReqItemsId);
  int completePhysicalInbound(Long inReqItemsId);


  // [관리자] 특정 입고 상세 항목의 요청 수량과 실제 수량 조회
  InboundQtyDTO selectInboundQtyById(@Param("inReqItemsId") long inReqItemsId);

  /**
   * [관리자] 특정 입고 상세 항목의 실제 입고 수량(inQty)을 업데이트합니다.
   * @param inReqItemsId 업데이트할 입고 상세 항목 ID
   * @param actualQty    새로 입력된 실제 입고 수량
   * @return 영향을 받은 행의 수 (성공 시 1)
   */
  int updateActualInboundQuantity(
          @Param("inReqItemsId") long inReqItemsId,
          @Param("actualQty") int actualQty
  );

  // 상세 페이지 조회를 위한 메서드
  InboundDetailDTO selectInboundDetailById(@Param("inReqItemsId") long inReqItemsId);

  // 전체 입고 페이지 조회를 위한 메서드
  List<InboundDetailDTO> selectInboundDetailsByCriteria(
          @Param("criteria") InboundCriteria criteria,
          @Param("userId") String userId,
          @Param("userRole") UserRole userRole
  );

  // 지정된 조건에 맞는 입고 상세 항목의 전체 개수를 조회
  int getTotalCountByCriteria(
          @Param("criteria") InboundCriteria criteria,
          @Param("userId") String userId,
          @Param("userRole") UserRole userRole
  );

  // 기존 selectInItemsByReqId 대신 이 메서드를 사용
  List<InboundItemDetailDTO> selectInboundItemDetailsByReqId(@Param("inReqId") long inReqId);

  InboundItemDetailDTO selectInboundItemDetailByItemId(@Param("inReqItemsId") long inReqItemsId);


  List<DailyCapacityEventDTO> selectDailyCapacitiesForPeriod(
          @Param("startDate") String startDate,
          @Param("endDate") String endDate
  );

  // [달력 아이콘용] 특정 기간의 '전체' 일별 처리 사용량을 합산하여 조회
  List<DailyCapacityEventDTO> selectAggregatedDailyCapacitiesForPeriod(
          @Param("startDate") String startDate,
          @Param("endDate") String endDate
  );

  // [하단 정보용] 특정 날짜의 '창고별' 상세 부하 정보를 모두 조회
  List<DailyWarehouseCapacityDTO> selectDailyWarehouseCapacitiesByDate(
          @Param("selectedDate") LocalDate selectedDate
  );


      /**
     * 특정 날짜와 요청 수량을 기준으로 할당 가능한 Zone 목록을 조회합니다.
     * @param selectedDate 조회할 날짜
     * @param requiredQty  요청된 입고 수량
     * @return 할당 가능한 Zone DTO 리스트
     */
    List<AvailableLocationDTO> findAvailableLocations(
            @Param("selectedDate") LocalDate selectedDate,
            @Param("requiredQty") int requiredQty
    );










}
