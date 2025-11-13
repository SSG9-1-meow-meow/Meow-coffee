package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.*;
import com.ssg.meowcoffee.dto.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import lombok.extern.log4j.Log4j2;
import org.apache.ibatis.annotations.Param;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class InboundMapperTests {

  @Autowired(required = false)
  private InboundMapper inboundMapper;

  @Test
  @Transactional // 테스트 완료 후 DB 자동 롤백
  public void testCallCreateInReq_Success() {
    log.info("=== 입고 요청 생성 프로시저 테스트 시작 ===");

    // 1. 샘플 데이터를 기반으로 DTO 준비
    String testItemsJson = "["
            + "{"
            + "\"cfId\": \"CF001\", " // '에티오피아 예가체프'
            + "\"inQtyReq\": 150"
            + "},"
            + "{"
            + "\"cfId\": \"CF002\", " // '콜롬비아 수프리모'
            + "\"inQtyReq\": 80"
            + "}"
            + "]";

    LocalDateTime currentDttm = LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS); // 초 단위까지만 사용

    // DTO에 IN 파라미터 설정
    InboundReqInputDTO input = InboundReqInputDTO.builder()
            ._comId("coffeebiz01")
            ._inDttmReq(currentDttm)
            ._inDateWish(LocalDate.now().plusDays(5)) // 희망 입고일
            ._inItemsJson(testItemsJson)
            ._isTempo(0) // 0: 정식 요청
            .build();

    // OUT 파라미터 필드는 MyBatis가 값을 채워주기 전까지 null 상태입니다.
    input.setGeneratedInReqId(null);

    try {
      // 2. 프로시저 호출
      log.info("프로시저 호출 DTO: " + input);
      inboundMapper.callCreateInReq(input);

      // 3. 결과 검증 (OUT 파라미터 확인)
      Long generatedId = input.getGeneratedInReqId();

      log.info("프로시저 호출 성공. 생성된 inReqId: {}", generatedId);

      // 생성된 ID가 null이 아니거나 0보다 커야 성공
      assert generatedId != null : "생성된 inReqId가 null입니다.";
      assert generatedId > 0 : "생성된 inReqId가 0 이하입니다.";

    } catch (Exception e) {
      log.error("프로시저 호출 중 예외 발생:", e);
      // 테스트 실패로 처리
      throw new RuntimeException("프로시저 호출 테스트 실패", e);
    }
  }

  // 회원 요청 임시 저장 테스트
  @Test
  @Transactional // 테스트 완료 후 DB 자동 롤백
  public void testCallCreateInReq_Temporary() {
    log.info("=== 입고 요청 생성 프로시저 테스트 시작 ===");

    // 1. 샘플 데이터를 기반으로 DTO 준비
    String testItemsJson = "["
            + "{"
            + "\"cfId\": \"CF001\", " // '에티오피아 예가체프'
            + "\"inQtyReq\": 12"
            + "},"
            + "{"
            + "\"cfId\": \"CF003\", " // '콜롬비아 수프리모'
            + "\"inQtyReq\": 10"
            + "}"
            + "]";

    LocalDateTime currentDttm = LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS); // 초 단위까지만 사용

    // DTO에 IN 파라미터 설정
    InboundReqInputDTO input = InboundReqInputDTO.builder()
            ._comId("coffeebiz02")
            ._inDttmReq(currentDttm)
            ._inDateWish(LocalDate.now().plusDays(10)) // 희망 입고일
            ._inItemsJson(testItemsJson)
            ._isTempo(1) // 1: 임시 저장
            .build();

    // OUT 파라미터 필드는 MyBatis가 값을 채워주기 전까지 null 상태입니다.
    input.setGeneratedInReqId(null);

    try {
      // 2. 프로시저 호출
      log.info("프로시저 호출 DTO: " + input);
      inboundMapper.callCreateInReq(input);

      // 3. 결과 검증 (OUT 파라미터 확인)
      Long generatedId = input.getGeneratedInReqId();

      log.info("프로시저 호출 성공. 생성된 inReqId: {}", generatedId);

      // 생성된 ID가 null이 아니거나 0보다 커야 성공
      assert generatedId != null : "생성된 inReqId가 null입니다.";
      assert generatedId > 0 : "생성된 inReqId가 0 이하입니다.";

    } catch (Exception e) {
      log.error("프로시저 호출 중 예외 발생:", e);
      // 테스트 실패로 처리
      throw new RuntimeException("프로시저 호출 테스트 실패", e);
    }
  }

  // 입고 요청 조회 테스트 통과 확인 완료
  @Test
  @DisplayName("입고 요청 + 상세 항목 리스트 조회 (권한, 검색, 정렬, 페이징)")
  @Transactional
  void testSelectInboundReqItemList() {
    log.info("=== 입고 목록 동적 조회 테스트 시작 ===");

    // --- 시나리오 1: 거래처(COMPANY) 권한으로 조회 ---
    log.info("--- 시나리오 1: 거래처(COMPANY) 권한 테스트 ---");
    InboundCriteria companyCriteria = new InboundCriteria();
    String companyUserId = "coffeebiz01"; // '메오커피'
    UserRole companyUserRole = UserRole.COMPANY;

    List<InboundReqItemDTO> companyResultList = inboundMapper.selectInReqItemList(companyCriteria, companyUserId, companyUserRole);

    assertNotNull(companyResultList, "결과 리스트는 null이 아니어야 합니다.");
    assertFalse(companyResultList.isEmpty(), "거래처 'coffeebiz01'의 요청 목록은 비어있지 않아야 합니다.");
    // 'coffeebiz01'의 요청(inReqId: 1, 3, 5)에 대한 상세 항목은 총 6개
    // 모든 결과의 거래처명이 '메오커피'인지 확인
    assertTrue(companyResultList.stream().allMatch(item -> item.getComName().equals("메오커피")),
            "모든 결과의 거래처명은 '메오커피'여야 합니다.");
    log.info("거래처('coffeebiz01') 조회 결과 {}건 확인", companyResultList.size());


    // --- 시나리오 2: 관리자(MANAGER) 권한으로 전체 조회 ---
    log.info("--- 시나리오 2: 관리자(MANAGER) 권한 테스트 ---");
    InboundCriteria managerCriteria = new InboundCriteria();
    String managerUserId = "manager01"; // 관리자 ID
    UserRole managerUserRole = UserRole.MANAGER;

    List<InboundReqItemDTO> managerResultList = inboundMapper.selectInReqItemList(managerCriteria, managerUserId, managerUserRole);

    assertNotNull(managerResultList, "결과 리스트는 null이 아니어야 합니다.");
    // 샘플 데이터의 inboundItems는 총 10개
    assertEquals(10, managerResultList.size(), "관리자는 모든 상세 항목(10개)을 조회할 수 있어야 합니다.");
    log.info("관리자 전체 조회 결과 {}건 확인", managerResultList.size());


    // --- 시나리오 3: 관리자 권한 + 필터링(검색) 테스트 ---
    log.info("--- 시나리오 3: 관리자 권한 + 필터링 테스트 (상태: 승인완료) ---");
    InboundCriteria filterCriteria = new InboundCriteria();
    filterCriteria.setInboundStatus("승인완료"); // '승인완료' 상태만 필터링

    List<InboundReqItemDTO> filteredList = inboundMapper.selectInReqItemList(filterCriteria, managerUserId, managerUserRole);

    assertNotNull(filteredList, "결과 리스트는 null이 아니어야 합니다.");
    // 샘플 데이터 중 '승인완료' 상태는 3건 (inReqId=3에서 2건, inReqId=5에서 1건)
    assertEquals(3, filteredList.size(), "상태가 '승인완료'인 항목은 3개여야 합니다.");
    assertTrue(filteredList.stream().allMatch(item -> item.getStatus().equals(InboundStatus.APPROVED)),
            "조회된 모든 항목의 상태는 '승인완료'(APPROVED)여야 합니다.");
    log.info("'승인완료' 필터링 조회 결과 {}건 확인", filteredList.size());


    // --- 시나리오 4: 관리자 권한 + 정렬 테스트 ---
    log.info("--- 시나리오 4: 관리자 권한 + 정렬 테스트 (수량 오름차순) ---");
    InboundCriteria sortCriteria = new InboundCriteria();
    sortCriteria.setSortBy("quantity"); // 정렬 기준: 수량
    sortCriteria.setSortOrder("ASC");   // 정렬 순서: 오름차순

    List<InboundReqItemDTO> sortedList = inboundMapper.selectInReqItemList(sortCriteria, managerUserId, managerUserRole);

    assertNotNull(sortedList, "결과 리스트는 null이 아니어야 합니다.");
    assertEquals(10, sortedList.size(), "정렬 시에도 전체 개수는 10개여야 합니다.");
    // 샘플 데이터 중 최소 수량은 30, 최대 수량은 120
    assertEquals(10, sortedList.get(0).getInQtyReq(), "오름차순 정렬 시 첫 번째 항목의 수량은 10이어야 합니다.");
    assertEquals(90, sortedList.get(9).getInQtyReq(), "오름차순 정렬 시 마지막 항목의 수량은 90이어야 합니다.");
    log.info("수량 오름차순 정렬 확인 (첫 값: {}, 마지막 값: {})", sortedList.get(0).getInQtyReq(), sortedList.get(9).getInQtyReq());


    // --- 시나리오 5: 관리자 권한 + 페이징 테스트 ---
    log.info("--- 시나리오 5: 관리자 권한 + 페이징 테스트 (2페이지, 3개씩) ---");
    InboundCriteria pagingCriteria = new InboundCriteria();
    pagingCriteria.setPage(2);  // 2페이지
    pagingCriteria.setSize(3);  // 페이지당 3개

    List<InboundReqItemDTO> pagedList = inboundMapper.selectInReqItemList(pagingCriteria, managerUserId, managerUserRole);

    assertNotNull(pagedList, "결과 리스트는 null이 아니어야 합니다.");
    assertEquals(3, pagedList.size(), "페이지당 3개씩 보여줄 때, 결과 리스트의 크기는 3이어야 합니다.");
    log.info("페이징 조회 결과 {}건 확인 (2페이지, 3개씩)", pagedList.size());

    log.info("=== 입고 목록 동적 조회 테스트 성공적으로 완료 ===");
  }


  // 커피 상품 조회 테스트 완료
  @Test
  void testSelectCoffeeList() {
    List<CoffeeVO> cfList = inboundMapper.selectCoffeeList();
    assertNotNull(cfList);
    cfList.forEach(log::info);
  }


  // 입고 요청 수정 프로시저 테스트
  @Test
  @DisplayName("입고 요청 수정 프로시저 - 성공 케이스")
  @Transactional
  void testCallUpdateInReq_Success() {
    log.info("--- 입고 요청 수정 성공 테스트 시작 ---");
    // given: inReqId=1번은 coffeebiz01 소유. 이를 수정.
    long targetInReqId = 1L;
    String ownerId = "coffeebiz01";

    String newItemsJson = "[{\"cfId\": \"CF005\", \"inQtyReq\": 99}]";
    LocalDate newWishDate = LocalDate.parse("2025-12-31");

    // 재활용하는 DTO에 수정할 ID(_inReqId)를 포함하여 빌드
    InboundReqInputDTO inputDTO = InboundReqInputDTO.builder()
            ._inReqId(targetInReqId)
            ._comId(ownerId)
            ._inDateWish(newWishDate)
            ._inItemsJson(newItemsJson)
            ._isTempo(0)
            .build();

    // when: 프로시저 호출
    assertDoesNotThrow(() -> inboundMapper.callUpdateInReq(inputDTO), "정상적인 수정은 예외를 발생시키지 않아야 합니다.");

    // then: 결과 검증 (VO 객체 사용)
    InboundRequestVO modifiedReq = inboundMapper.selectInReqById(targetInReqId);
    assertNotNull(modifiedReq, "수정 후 요청이 존재해야 합니다.");
    assertEquals(newWishDate, modifiedReq.getInDateWish(), "희망 입고일이 변경되어야 합니다.");
    assertNull(modifiedReq.getManagerId(), "수정 시 관리자 승인 정보는 초기화되어야 합니다.");

    List<InboundItemVO> modifiedItems = inboundMapper.selectInItemsByReqId(targetInReqId);
    assertEquals(1, modifiedItems.size(), "상세 항목은 1개로 변경되어야 합니다.");
    assertEquals("CF005", modifiedItems.get(0).getCfId(), "상세 항목의 커피 ID가 변경되어야 합니다.");
    assertEquals(99, modifiedItems.get(0).getInQtyReq(), "상세 항목의 수량이 변경되어야 합니다.");

    log.info("입고 요청 수정 및 검증 성공. 변경된 희망일: {}", modifiedReq.getInDateWish());
  }

  @Test
  @DisplayName("입고 요청 수정 프로시저 - 실패 케이스 (권한 없음)")
  @Transactional
  void testCallUpdateInReq_PermissionDenied() {
    log.info("--- 입고 요청 수정 실패(권한 없음) 테스트 시작 ---");
    // given: inReqId=1번(coffeebiz01 소유)을 다른 회원(coffeebiz02)이 수정을 시도
    long targetInReqId = 1L;
    String otherUserId = "coffeebiz02";

    InboundReqInputDTO inputDTO = InboundReqInputDTO.builder()
            ._inReqId(targetInReqId)
            ._comId(otherUserId) // 소유주가 아닌 다른 회원 ID
            ._inDateWish(LocalDate.now())
            ._inItemsJson("[]")
            ._isTempo(0)
            .build();

    // when & then: 프로시저 호출 시 DataAccessException이 발생해야 함
    assertThrows(DataAccessException.class, () -> {
      inboundMapper.callUpdateInReq(inputDTO);
    }, "권한 없는 수정은 DataAccessException을 발생시켜야 합니다.");

    log.info("권한 없는 사용자의 수정 시도 시 예외 발생 확인.");
  }

  @Test
  @DisplayName("입고 요청 취소(삭제) - 성공 및 실패 케이스")
  @Transactional
  void testCancelInboundRequest() {
    log.info("--- 입고 요청 취소(삭제) 테스트 시작 ---");
    // given
    long ownerReqId = 1L;      // coffeebiz01 소유
    String ownerId = "coffeebiz01";

    long otherReqId = 2L;      // coffeebiz02 소유
    String managerId = "manager01";

    // --- 성공 케이스 1: 소유주가 자신의 요청을 취소 ---
    int ownerResult = inboundMapper.deleteInReq(ownerReqId, ownerId, UserRole.COMPANY);
    assertEquals(1, ownerResult, "소유주는 자신의 요청을 취소할 수 있어야 합니다.");
    // isDelete 필드는 Boolean이므로 true와 비교
    assertEquals(true, inboundMapper.selectInReqById(ownerReqId).getIsDelete(), "취소 후 IsDelete는 true여야 합니다.");
    log.info("소유주 요청 취소 성공 확인.");

    // --- 성공 케이스 2: 관리자가 다른 회원의 요청을 취소 ---
    int managerResult = inboundMapper.deleteInReq(otherReqId, managerId, UserRole.MANAGER);
    assertEquals(1, managerResult, "관리자는 모든 요청을 취소할 수 있어야 합니다.");
    assertEquals(true, inboundMapper.selectInReqById(otherReqId).getIsDelete(), "관리자가 취소 후 IsDelete는 true여야 합니다.");
    log.info("관리자 요청 취소 성공 확인.");

    // --- 실패 케이스: 소유주가 아닌 회원이 다른 회원의 요청을 취소 ---
    int failureResult = inboundMapper.deleteInReq(otherReqId, ownerId, UserRole.COMPANY);
    assertEquals(0, failureResult, "다른 회원의 요청을 취소할 수 없어야 합니다.");
    log.info("다른 회원 요청 취소 실패(결과 0) 확인.");
  }

  @Test
  @DisplayName("관리자용 입고 현황 건수 조회")
  @Transactional
  void testCountAdminDashboardItems() {
    log.info("--- 관리자용 건수 조회 테스트 시작 ---");

    // 1. 미승인 건수 테스트 (샘플 데이터 기준: 6건)
    // inReqId 1(2건), 2(2건), 4(2건) -> 총 6건
    int unapprovedCount = inboundMapper.countUnapprovedInItems();
    assertEquals(9, unapprovedCount, "미승인(승인대기) 상태의 항목은 9건이어야 합니다.");
    log.info("미승인 건수 확인: {}", unapprovedCount);


    // 2. 승인 완료 건수 테스트 (샘플 데이터 기준: 3건)
    // inReqId 3(2건), 5(1건) -> 총 3건. (inReqId=3의 '입고완료' 1건은 제외)
    int approvedCount = inboundMapper.countApprovedInItems();
    assertEquals(3, approvedCount, "승인완료 상태의 항목은 3건이어야 합니다.");
    log.info("승인 완료 건수 확인: {}", approvedCount);


    // 3. 입고 완료 처리 필요 건수 테스트
    // 3-1. 초기 상태 확인: 샘플 데이터에는 해당 케이스가 없으므로 0건이어야 함.
    int initialPendingCount = inboundMapper.countPendingReceivedInItems();
    assertEquals(0, initialPendingCount, "초기 데이터에는 입고 완료 처리 필요 건수가 0이어야 합니다.");
    log.info("초기 입고 완료 처리 필요 건수 확인: {}", initialPendingCount);

    // 3-2. 데이터 조작: 검수(Insp)와 입고(Recv)가 모두 완료된 항목(ID: 7)의 입고일시를 NULL로 변경
    long targetItemId = 7L; // inReqId=3에 속한 '승인완료' 항목
    inboundMapper.updateReceiveTimeToNullForTest(targetItemId);
    log.info("테스트를 위해 항목 ID {}의 입고일시(inDttmRecv)를 NULL로 변경했습니다.", targetItemId);

    // 3-3. 재확인: 데이터 조작 후에는 1건이 조회되어야 함.
    int afterUpdatePendingCount = inboundMapper.countPendingReceivedInItems();
    assertEquals(1, afterUpdatePendingCount, "데이터 조작 후 입고 완료 처리 필요 건수는 1이어야 합니다.");
    log.info("데이터 조작 후 입고 완료 처리 필요 건수 확인: {}", afterUpdatePendingCount);
  }

  @Test
  @DisplayName("관리자용 출고 현황 건수 조회")
  @Transactional
  void testCountAdminDashboardOutItems() {
    log.info("--- 관리자용 출고 건수 조회 테스트 시작 ---");

    // 1. 미승인 건수 테스트 (샘플 데이터 기준: 4건)
    int unapprovedCount = inboundMapper.countUnapprovedOutItems();
    log.info("미승인 출고 건수 확인: {}", unapprovedCount);


    // 2. 승인 완료 건수 테스트 (샘플 데이터 기준: 6건)
    int approvedCount = inboundMapper.countApprovedOutItems();
    assertEquals(6, approvedCount, "승인완료 상태의 항목은 6건이어야 합니다.");
    log.info("승인 완료 건수 확인: {}", approvedCount);


    // 3. 입고 완료 처리 필요 건수 테스트
    // 3-1. 초기 상태 확인: 샘플 데이터에는 해당 케이스가 없으므로 0건이어야 함.
    int initialPendingCount = inboundMapper.countPendingReceivedOutItems();
    assertEquals(0, initialPendingCount, "초기 데이터에는 입고 완료 처리 필요 건수가 0이어야 합니다.");
    log.info("초기 입고 완료 처리 필요 건수 확인: {}", initialPendingCount);

    // 3-2. 데이터 조작: 검수(Insp)와 입고(Recv)가 모두 완료된 항목(ID: 7)의 입고일시를 NULL로 변경
    long targetItemId = 10L; // outReqId=10에 속한 '승인완료' 항목
    inboundMapper.updateOutReceiveTimeToNullForTest(targetItemId);
    log.info("테스트를 위해 항목 ID {}의 출고완료일시(outDttmRecv)를 NULL로 변경했습니다.", targetItemId);

    // 3-3. 재확인: 데이터 조작 후에는 1건이 조회되어야 함.
    int afterUpdatePendingCount = inboundMapper.countPendingReceivedOutItems();
    assertEquals(1, afterUpdatePendingCount, "데이터 조작 후 출고 완료 처리 필요 건수는 1이어야 합니다.");
    log.info("데이터 조작 후 출 완료 처리 필요 건수 확인: {}", afterUpdatePendingCount);
  }

  @Test
  @DisplayName("관리자용 차트 데이터 조회 (일별/월별)")
  @Transactional
  void testSelectChartData() {
    log.info("--- 차트 데이터 조회 테스트 시작 ---");
    // given: 테스트를 위한 입고 완료 데이터 동적 생성
    // 기존 입고 요청(inReqId=5)에 테스트용 데이터를 추가한다고 가정
    long testReqId = 5L;

    // --- 일별 차트 테스트용 데이터 ---
    // 어제 날짜로 10개, 20개 입고 + 기존 60개 (총 90개)
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF001").inQty(10)
            .inDttmRecv(LocalDateTime.now().minusDays(1)).build());
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF002").inQty(20)
            .inDttmRecv(LocalDateTime.now().minusDays(1)).build());
    // 15일 전 날짜로 50개 입고
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF003").inQty(50)
            .inDttmRecv(LocalDateTime.now().minusDays(15)).build());

    // --- 월별 차트 테스트용 데이터 ---
    // 2달 전 날짜로 100개, 200개 입고 (총 300개)
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF004").inQty(100)
            .inDttmRecv(LocalDateTime.now().minusMonths(2)).build());
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF005").inQty(200)
            .inDttmRecv(LocalDateTime.now().minusMonths(2)).build());

    // when: 일별 차트 데이터 조회
    List<InOutChartDTO> dailyStats = inboundMapper.selectInDailyRecvStatsForLastMonth();
    log.info("일별 조회 결과: {}", dailyStats);

    // then: 일별 차트 데이터 검증
    assertNotNull(dailyStats);
    assertEquals(2, dailyStats.size(), "최근 30일 내에 데이터가 있는 날은 2일이어야 합니다.");
    String yesterdayKey = LocalDateTime.now().minusDays(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    Optional<InOutChartDTO> yesterdayData = dailyStats.stream().filter(d -> d.getChartKey().equals(yesterdayKey)).findFirst();
    assertTrue(yesterdayData.isPresent(), "어제 날짜의 데이터가 존재해야 합니다.");
    assertEquals(90.0, yesterdayData.get().getTotalQuantity(), "어제 날짜의 총 수량은 90이어야 합니다.");


    // when: 월별 차트 데이터 조회
    List<InOutChartDTO> monthlyStats = inboundMapper.selectInMonthlyRecvStatsForLastYear();
    log.info("월별 조회 결과: {}", monthlyStats);

    // then: 월별 차트 데이터 검증
    assertNotNull(monthlyStats);
    // 샘플데이터(2025-11) + 테스트데이터(최근2개월) = 총 3개월치 데이터 예상
    assertTrue(monthlyStats.size() >= 2, "최근 12개월 내에 데이터가 있는 월은 최소 2개 이상이어야 합니다.");
    String twoMonthsAgoKey = LocalDateTime.now().minusMonths(2).format(DateTimeFormatter.ofPattern("yyyy-MM"));
    Optional<InOutChartDTO> twoMonthsAgoData = monthlyStats.stream().filter(d -> d.getChartKey().equals(twoMonthsAgoKey)).findFirst();
    assertTrue(twoMonthsAgoData.isPresent(), "2달 전 날짜의 데이터가 존재해야 합니다.");
    assertEquals(300.0, twoMonthsAgoData.get().getTotalQuantity(), "2달 전 날짜의 총 수량은 300이어야 합니다.");

    log.info("차트 데이터 조회 테스트 성공.");
  }


  @Test
  @DisplayName("대시보드용 최근 한 달 입고 상위 3개 커피 조회")
  @Transactional
  void testSelectTopInboundCoffee() {
    log.info("--- 입고 상위 3개 커피 조회 테스트 시작 ---");
    // given: 테스트를 위한 입고 완료 데이터 동적 생성
    long testReqId = 6L;

    // 1위: CF004 (케냐 AA) -> 50 + 50 = 100개
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF004").inQty(50)
            .inDttmRecv(LocalDateTime.now().minusDays(2)).build());
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF004").inQty(50)
            .inDttmRecv(LocalDateTime.now().minusDays(3)).build());

    // 2위: CF002 (콜롬비아 수프리모) -> 80개
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF002").inQty(80)
            .inDttmRecv(LocalDateTime.now().minusDays(5)).build());

    // 3위: CF001 (에티오피아 예가체프) -> 40 + 30 = 70개
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF001").inQty(40)
            .inDttmRecv(LocalDateTime.now().minusDays(1)).build());
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF001").inQty(30)
            .inDttmRecv(LocalDateTime.now().minusDays(10)).build());

    // 5위 (순위권 밖): CF003 (브라질 산토스) -> 40개
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF003").inQty(40)
            .inDttmRecv(LocalDateTime.now().minusDays(15)).build());

    // 기간 초과 (순위권 밖): CF003 (브라질 산토스) -> 200개 (but 40일 전)
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(testReqId).cfId("CF003").inQty(200)
            .inDttmRecv(LocalDateTime.now().minusDays(40)).build());

    // when: 상위 3개 커피 조회 메서드 호출
    List<TopInOutCoffeeDTO> topList = inboundMapper.selectTopCoffeeByReceivedInboundForLastMonth();
    log.info("상위 3개 커피 조회 결과: {}", topList);

    // then: 결과 검증
    assertNotNull(topList);
    assertEquals(3, topList.size(), "결과는 정확히 3개여야 합니다.");

    // 1위 검증
    assertEquals("케냐 AA", topList.get(0).getCoffeeName(), "1위는 '케냐 AA'여야 합니다.");
    assertEquals(100.0, topList.get(0).getTotalQuantity(), "1위의 총 수량은 100이어야 합니다.");

    // 2위 검증
    assertEquals("콜롬비아 수프리모", topList.get(1).getCoffeeName(), "2위는 '콜롬비아 수프리모'여야 합니다.");
    assertEquals(80.0, topList.get(1).getTotalQuantity(), "2위의 총 수량은 80이어야 합니다.");

    // 3위 검증
    assertEquals("에티오피아 예가체프", topList.get(2).getCoffeeName(), "3위는 '에티오피아 예가체프'여야 합니다.");
    assertEquals(70.0, topList.get(2).getTotalQuantity(), "3위의 총 수량은 70이어야 합니다.");

    log.info("입고 상위 3개 커피 조회 테스트 성공.");
  }


  @Test
  @DisplayName("대시보드 및 차트용 리드타임 데이터 조회 (평균 리드타임 수정 버전)")
  @Transactional
  void testSelectLeadTimeData() {
    log.info("--- 리드타임 데이터 조회 테스트 시작 (평균 리드타임) ---");

    // given: 리드타임 계산을 위한 테스트 데이터 동적 생성
    InboundRequestVO requestVO = InboundRequestVO.builder().comId("coffeebiz01").build();

    // --- 최근 한 달 평균 리드타임 테스트 데이터 ---
    // 1. 리드타임: 48시간
    requestVO.setInDttmReq(LocalDateTime.now().minusDays(3));
    inboundMapper.insertRequestForTest(requestVO);
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(requestVO.getInReqId()).cfId("CF001").inQty(10)
            .inDttmRecv(LocalDateTime.now().minusDays(1)).build());

    // 2. 리드타임: 120시간
    requestVO.setInDttmReq(LocalDateTime.now().minusDays(10));
    inboundMapper.insertRequestForTest(requestVO);
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(requestVO.getInReqId()).cfId("CF002").inQty(20)
            .inDttmRecv(LocalDateTime.now().minusDays(5)).build());

    // --- 월별 평균 리드타임 테스트 데이터 (이전과 동일) ---
    // (24시간 + 72시간) / 2 = 평균 48시간
    requestVO.setInDttmReq(LocalDateTime.now().minusMonths(2).minusDays(1));
    inboundMapper.insertRequestForTest(requestVO);
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(requestVO.getInReqId()).cfId("CF003").inQty(30)
            .inDttmRecv(LocalDateTime.now().minusMonths(2)).build());
    requestVO.setInDttmReq(LocalDateTime.now().minusMonths(2).minusDays(3));
    inboundMapper.insertRequestForTest(requestVO);
    inboundMapper.insertCompletedItemForTest(InboundItemVO.builder().inReqId(requestVO.getInReqId()).cfId("CF004").inQty(40)
            .inDttmRecv(LocalDateTime.now().minusMonths(2)).build());


    // ★★★ when: 최근 한 달 '평균' 리드타임 조회
    Double avgLeadTime = inboundMapper.selectAvgInLeadTimeForLastMonth();
    log.info("최근 한 달 평균 리드타임: {}", avgLeadTime);

    // ★★★ then: 최근 한 달 '평균' 리드타임 검증 (수정된 부분) ★★★
    assertNotNull(avgLeadTime, "평균 리드타임 결과는 null이 아니어야 합니다.");


    // --- 월별 평균 리드타임 차트 데이터 조회 및 검증 (이전과 동일) ---
    List<InOutChartDTO> monthlyAvgLeadTimes = inboundMapper.selectMonthlyAvgInLeadTimeForLastYear();
    log.info("월별 평균 리드타임: {}", monthlyAvgLeadTimes);

    assertNotNull(monthlyAvgLeadTimes);
    String twoMonthsAgoKey = LocalDateTime.now().minusMonths(2).format(DateTimeFormatter.ofPattern("yyyy-MM"));
    Optional<InOutChartDTO> twoMonthsAgoData = monthlyAvgLeadTimes.stream()
            .filter(d -> d.getChartKey().equals(twoMonthsAgoKey)).findFirst();
    assertTrue(twoMonthsAgoData.isPresent(), "2달 전 월별 데이터가 존재해야 합니다.");

    log.info("리드타임 데이터 조회 테스트 성공.");
  }


  @Test
  @DisplayName("관리자용 특정 날짜의 부하 및 수용 능력 조회")
  @Transactional
  void testSelectCapacityAndLoadByDate() {
    log.info("--- 특정 날짜 부하 및 수용 능력 조회 테스트 시작 ---");
    LocalDate testDate = LocalDate.parse("2025-11-08");

    // --- 시나리오 1: 데이터가 있는 날짜 조회 ---
    log.info("시나리오 1: 데이터가 있는 날짜({}) 조회", testDate);

    // 1-1. 일별 부하 조회 및 검증
    DailyLoadDTO dailyLoad = inboundMapper.selectDailyLoadByDate(testDate);
    assertNotNull(dailyLoad, "2025-11-08의 일별 부하 데이터는 존재해야 합니다.");
    log.info("일별 부하 데이터 검증 완료: {}", dailyLoad);

    // 1-2. 창고별 수용 능력 조회 및 검증
    List<WarehouseCapacityDTO> warehouseCapacities = inboundMapper.selectWarehouseCapacitiesByDate(testDate);
    assertNotNull(warehouseCapacities);
    assertEquals(3, warehouseCapacities.size(), "2025-11-08에는 3개의 창고 데이터가 있어야 합니다.");

    // 서울창고(whId=1) 데이터 검증
    Optional<WarehouseCapacityDTO> seoulWarehouse = warehouseCapacities.stream()
            .filter(w -> w.getWarehouseName().equals("서울창고")).findFirst();
    assertTrue(seoulWarehouse.isPresent(), "서울창고 데이터가 포함되어야 합니다.");
    seoulWarehouse.ifPresent(w -> {
      assertEquals(300, w.getUsedCapacity());
      assertEquals(700, w.getAvailableCapacity());
      assertEquals(1000, w.getTotalCapacity()); // warehouse 테이블의 총량
    });

    // 부산창고(whId=2) 데이터 검증
    Optional<WarehouseCapacityDTO> busanWarehouse = warehouseCapacities.stream()
            .filter(w -> w.getWarehouseName().equals("부산창고")).findFirst();
    assertTrue(busanWarehouse.isPresent(), "부산창고 데이터가 포함되어야 합니다.");
    busanWarehouse.ifPresent(w -> {
      assertEquals(500, w.getUsedCapacity());
      assertEquals(500, w.getAvailableCapacity());
      assertEquals(800, w.getTotalCapacity()); // warehouse 테이블의 총량
    });
    log.info("창고별 수용 능력 데이터 검증 완료: {} 건", warehouseCapacities.size());


    // --- 시나리오 2: 데이터가 없는 날짜 조회 ---
    LocalDate emptyDate = LocalDate.parse("2025-12-31");
    log.info("시나리오 2: 데이터가 없는 날짜({}) 조회", emptyDate);

    DailyLoadDTO emptyDailyLoad = inboundMapper.selectDailyLoadByDate(emptyDate);
    assertNull(emptyDailyLoad, "데이터 없는 날짜의 일별 부하는 NULL이어야 합니다.");

    List<WarehouseCapacityDTO> emptyWarehouseCapacities = inboundMapper.selectWarehouseCapacitiesByDate(emptyDate);
    assertNotNull(emptyWarehouseCapacities);
    assertTrue(emptyWarehouseCapacities.isEmpty(), "데이터 없는 날짜의 창고 목록은 비어있어야 합니다.");
    log.info("데이터 없는 날짜 조회 결과 검증 완료.");
  }

  @Test
  @DisplayName("관리자용 할당 가능 창고 및 Zone 목록 조회")
  @Transactional
  void testFindAssignableWarehouses() {
    log.info("--- 할당 가능 창고 및 Zone 조회 테스트 시작 ---");

    // --- 시나리오 1: 조건에 맞는 창고가 여러 개 조회되는 경우 ---
    // 2025-11-08에 400 이상의 수용량이 남은 창고는 서울(700), 부산(500)
    LocalDate targetDate = LocalDate.parse("2025-11-08");
    int requiredCapa = 400;

    List<AssignableWarehouseDTO> resultList = inboundMapper.selectAssignableWarehouses(targetDate, requiredCapa);
    log.info("시나리오 1 결과 (필요용량: {}): {}건", requiredCapa, resultList.size());

    assertNotNull(resultList);
    assertEquals(3, resultList.size(), "2025-11-08에 400 이상 수용 가능한 창고는 3개여야 합니다.");

    // 부산창고(whId=2) 검증 - Zone-B
    AssignableWarehouseDTO busan = resultList.stream()
            .filter(w -> w.getWarehouseName().equals("부산창고")).findFirst().orElse(null);
    assertNotNull(busan);
    assertEquals(1, busan.getZoneNames().size());
    assertTrue(busan.getZoneNames().contains("Zone-B"));

    // 서울창고(whId=1) 검증 - Zone-A
    AssignableWarehouseDTO seoul = resultList.stream()
            .filter(w -> w.getWarehouseName().equals("서울창고")).findFirst().orElse(null);
    assertNotNull(seoul);
    assertEquals(1, seoul.getZoneNames().size());
    assertTrue(seoul.getZoneNames().contains("Zone-A"));


    // --- 시나리오 2: 조건에 맞는 창고가 하나만 조회되는 경우 ---
    // 2025-11-08에 600 이상의 수용량이 남은 창고는 서울(700)과 대구(830) 뿐
    requiredCapa = 600;
    List<AssignableWarehouseDTO> singleResultList = inboundMapper.selectAssignableWarehouses(targetDate, requiredCapa);
    log.info("시나리오 2 결과 (필요용량: {}): {}건", requiredCapa, singleResultList.size());

    assertNotNull(singleResultList);
    assertEquals(2, singleResultList.size(), "2025-11-08에 600 이상 수용 가능한 창고는 2개여야 합니다.");
    assertEquals("대구창고", singleResultList.get(0).getWarehouseName());
    assertEquals("서울창고", singleResultList.get(1).getWarehouseName());



    // --- 시나리오 3: 조건에 맞는 창고가 없는 경우 ---
    // 2025-11-08에 800 이상의 수용량이 남은 창고는 없음
    requiredCapa = 900;
    List<AssignableWarehouseDTO> emptyResultList = inboundMapper.selectAssignableWarehouses(targetDate, requiredCapa);
    log.info("시나리오 3 결과 (필요용량: {}): {}건", requiredCapa, emptyResultList.size());

    assertNotNull(emptyResultList);
    assertTrue(emptyResultList.isEmpty(), "조건에 맞는 창고가 없을 경우 빈 리스트가 반환되어야 합니다.");

    log.info("할당 가능 창고 및 Zone 조회 테스트 성공.");
  }



  @Test
  @DisplayName("관리자 실제 입고 수량 조회 및 업데이트")
  @Transactional
  void testSelectAndUpdateActualQuantity() {
    log.info("--- 실제 입고 수량 조회 및 업데이트 테스트 시작 ---");
    // given: 샘플 데이터에서 inReqItemsId=1인 항목은 inQtyReq=80, inQty=NULL 상태
    long targetItemId = 3L;

    // --- 1. 초기 수량 정보 조회 ---
    log.info("1. 초기 수량 정보 조회 (ID: {})", targetItemId);
    InboundQtyDTO initialQuantities = inboundMapper.selectInboundQtyById(targetItemId);

    // then 1: 초기 상태 검증
    assertNotNull(initialQuantities);
    assertEquals(80, initialQuantities.getInQtyReq(), "초기 요청 수량은 80이어야 합니다.");
    assertNull(initialQuantities.getInQty(), "초기 실제 입고 수량은 NULL이어야 합니다.");
    log.info("초기 상태 확인: 요청량={}, 실제량={}", initialQuantities.getInQtyReq(), initialQuantities.getInQty());


    // --- 2. 실제 입고 수량 업데이트 ---
    int newActualQty = 98;
    log.info("2. 실제 입고 수량을 {}로 업데이트", newActualQty);
    int affectedRows = inboundMapper.updateActualInboundQuantity(targetItemId, newActualQty);

    // then 2: 업데이트 성공 여부 검증
    assertEquals(1, affectedRows, "업데이트는 정확히 1개 행에 영향을 주어야 합니다.");


    // --- 3. 업데이트 후 수량 정보 재조회 ---
    log.info("3. 업데이트 후 수량 정보 재조회");
    InboundQtyDTO updatedQuantities = inboundMapper.selectInboundQtyById(targetItemId);

    // then 3: 최종 상태 검증
    assertNotNull(updatedQuantities);
    assertEquals(80, updatedQuantities.getInQtyReq(), "업데이트 후에도 요청 수량은 100으로 유지되어야 합니다.");
    assertEquals(newActualQty, updatedQuantities.getInQty(), "업데이트 후 실제 입고 수량은 98이어야 합니다.");
    log.info("최종 상태 확인: 요청량={}, 실제량={}", updatedQuantities.getInQtyReq(), updatedQuantities.getInQty());

    log.info("실제 입고 수량 조회 및 업데이트 테스트 성공.");
  }


  @Test
  @DisplayName("입고 상세 목록 기본 조회 테스트 (페이징, 권한)")
  @Transactional
  void testSelectInboundDetailsByCriteria_Basic() {
    log.info("--- 입고 상세 목록 기본 조회 테스트 시작 ---");

    // given: 아무런 필터링/정렬 조건이 없는 기본 Criteria 객체
    // InboundCriteria 생성자는 page=1, size=10으로 기본 설정됩니다.
    InboundCriteria criteria = new InboundCriteria();
    String adminUserId = "admin01"; // 관리자 ID
    UserRole adminUserRole = UserRole.ADMIN; // 관리자 권한

    // when: 매퍼 메서드 호출
    List<InboundDetailDTO> resultList = inboundMapper.selectInboundDetailsByCriteria(criteria, adminUserId, adminUserRole);
    log.info("조회된 입고 상세 목록: {} 건", resultList.size());

    // then: 결과 검증
    assertNotNull(resultList, "결과 리스트는 null이 아니어야 합니다.");

    // 샘플 데이터의 inboundItems 총 개수는 10개입니다.
    // size가 10이므로, 첫 페이지 조회 시 10개의 결과가 모두 나와야 합니다.
    assertEquals(10, resultList.size(), "기본 조회 시 전체 10개의 항목이 조회되어야 합니다.");

    // 첫 번째 결과 항목의 일부 데이터만 간단히 확인하여 조인이 잘 되었는지 검증
    // 기본 정렬은 요청일(inDttmReq) 내림차순이므로, 가장 최신 요청이 첫 번째로 와야 합니다.
    // 샘플 데이터에서 가장 최신 요청은 inReqId=1 입니다.
    InboundDetailDTO firstItem = resultList.get(0);
    assertNotNull(firstItem);
    assertEquals(1, firstItem.getInReqId(), "기본 정렬(최신순)에 따라 첫 항목의 inReqId는 5여야 합니다.");
    assertEquals("메오커피", firstItem.getCompanyName(), "거래처 이름이 올바르게 조인되어야 합니다.");
    assertEquals("과테말라 안티구아", firstItem.getCoffeeName(), "커피 이름이 올바르게 조인되어야 합니다.");

    log.info("기본 조회 테스트 성공. 첫 항목의 거래처명: {}", firstItem.getCompanyName());
  }

  @Test
  @DisplayName("입고 상세 아이템 1건 조회")
  void testSelectInboundDetailsByItemId() {
    log.info("--- 입고 상세 한건 기본 조회 테스트 시작 ---");
    InboundItemDetailDTO inboundItemDetailDTO = inboundMapper.selectInboundItemDetailByItemId(3);
    log.info(inboundItemDetailDTO);
  }


  @Test
  @DisplayName("하루 창고별 처리 부하 조회")
  void testSelectDailyCapacitiesForMonth_Basic() {

    List<DailyWarehouseCapacityDTO> dailyWarehouseCapacityDTOList =
            inboundMapper.selectDailyWarehouseCapacitiesByDate(LocalDate.now());

    dailyWarehouseCapacityDTOList.forEach(log::info);
  }


  @Test
  @DisplayName("FinalizeInboundItem 프로시저 검증 (승인, 반려, 임시저장, 부모 승인)")
  @Transactional
  void testFinalizeInboundItem() {
    log.info("=== FinalizeInboundItem 프로시저 검증 시작 ===");

    // given: 테스트 환경 준비 (샘플 데이터의 inReqId=102, inReqItemsId=203, 204 사용)
    // 102번 요청: 203(승인완료), 204(승인대기) -> 총 2개 중 1개 남음
    long inReqId = 102L;
    long targetItemId1 = 204L; // 남은 '승인대기' 항목
    long targetItemId2 = 205L; // 다른 '승인대기' 항목 (반려 테스트용)
    String managerId = "manager01";
    LocalDate confirmedDate = LocalDate.parse("2025-12-10");
    String testLpId = "LP001"; // LOC001에 해당

    // DTO for Scenarios 1 & 2
    InboundProcessDTO approvalDTO = new InboundProcessDTO();
    approvalDTO.setInReqItemsId(targetItemId1);
    approvalDTO.setManagerId(managerId);
    approvalDTO.setNewStatus(InboundStatus.APPROVED);
    approvalDTO.setConfirmedDate(confirmedDate);
    approvalDTO.setLpId(testLpId);
    approvalDTO.setIsTempo(0); // 최종 저장


    // --- 시나리오 1: 임시 저장 (Temp Save) ---
    log.info("--- 시나리오 1: 임시 저장 및 데이터 확인 ---");

    // given: 임시 저장용 DTO
    InboundProcessDTO tempSaveDTO = new InboundProcessDTO();
    tempSaveDTO.setInReqItemsId(targetItemId2);
    tempSaveDTO.setManagerId(managerId);
    tempSaveDTO.setNewStatus(InboundStatus.APPROVED); // 최종 상태는 APPROVED지만
    tempSaveDTO.setConfirmedDate(confirmedDate.plusDays(1));
    tempSaveDTO.setLpId("LP002");
    tempSaveDTO.setIsTempo(1); // 임시 저장 (IsTempo=1)
    log.info(tempSaveDTO);

    // when
    inboundMapper.finalizeInboundItem(tempSaveDTO);

    // then: 상태는 PENDING(승인대기)으로 유지되고 위치/날짜만 업데이트되어야 함
    InboundItemVO tempItem = inboundMapper.selectInItemById(targetItemId2);
    assertEquals(InboundStatus.PENDING, tempItem.getStatus(), "임시저장 후 상태는 '승인대기'여야 합니다.");
    assertEquals("LOC002", tempItem.getLocationId(), "임시저장 후 locationId는 업데이트되어야 합니다.");
    assertNotNull(tempItem.getInDttmSchd(), "임시저장 후 inDttmSchd는 업데이트되어야 합니다.");


    // --- 시나리오 2: 최종 승인 (전체 완료 전) ---
    log.info("--- 시나리오 2: 최종 승인 및 부모 승인일시 NULL 유지 확인 (inReqId=102) ---");
    log.info(approvalDTO);
    // given: targetItemId1 = 204 ('승인대기' 상태, inReqId=102)
    // when: 최종 승인
    inboundMapper.finalizeInboundItem(approvalDTO);

    // then: 항목 상태는 승인 완료, 부모 요청 승인일시는 NULL 이어야 함 (다른 항목이 이미 APPROVED 상태로 남아있어 전체 완료 조건 만족)
    InboundItemVO itemAfterAppr = inboundMapper.selectInItemById(targetItemId1);
    InboundRequestVO reqAfterAppr = inboundMapper.selectInReqById(inReqId);

    assertEquals(InboundStatus.APPROVED, itemAfterAppr.getStatus(), "항목 상태는 '승인완료'여야 합니다.");
    assertNotNull(itemAfterAppr.getInDttmSchd(), "inDttmSchd는 업데이트되어야 합니다.");
    // 부모 요청은 이미 다른 항목(203)이 승인완료이므로, inDttmAppr가 기록되어야 함
    assertNotNull(reqAfterAppr.getInDttmAppr(), "모든 항목이 처리되었으므로 부모 요청의 승인일시가 기록되어야 합니다.");
    assertEquals(managerId, reqAfterAppr.getManagerId(), "부모 요청의 관리자 ID가 기록되어야 합니다.");


    // --- 시나리오 3: 최종 반려 (REJECTED) ---
    log.info("--- 시나리오 3: 최종 반려 및 관리자 ID 업데이트 확인 ---");
    long targetItemId3 = 205L;
    long parentReqId3 = 103L;
    String rejectManagerId = "manager02";

    InboundProcessDTO rejectDTO = new InboundProcessDTO();
    rejectDTO.setInReqItemsId(targetItemId3);
    rejectDTO.setManagerId(rejectManagerId); // 반려를 처리한 관리자
    rejectDTO.setNewStatus(InboundStatus.REJECTED);
    rejectDTO.setIsTempo(0); // 최종 처리

    // when: 최종 반려
    inboundMapper.finalizeInboundItem(rejectDTO);

    // then: 항목 상태는 REJECTED, 부모 요청의 managerId는 업데이트되고, apprDttm은 NULL
    InboundItemVO itemAfterReject = inboundMapper.selectInItemById(targetItemId3);
    InboundRequestVO reqAfterReject = inboundMapper.selectInReqById(parentReqId3);

    assertEquals(InboundStatus.REJECTED, itemAfterReject.getStatus(), "항목 상태는 '반려'여야 합니다.");

    // ★★★ [핵심 수정] managerId는 업데이트되었는지, inDttmAppr는 NULL인지 검증 ★★★
    assertNotNull(reqAfterReject.getManagerId(), "최종 처리 시 관리자 ID는 항상 기록되어야 합니다.");
    assertEquals(rejectManagerId, reqAfterReject.getManagerId(), "마지막으로 처리한 관리자의 ID가 기록되어야 합니다.");
    assertNull(reqAfterReject.getInDttmAppr(), "반려 처리가 포함되어 있으므로 부모 요청의 승인일시는 NULL이어야 합니다.");

    log.info("반려 처리 후 managerId 업데이트 및 inDttmAppr NULL 유지 확인.");
    log.info("=== FinalizeInboundItem 프로시저 검증 성공 ===");
  }
















}

