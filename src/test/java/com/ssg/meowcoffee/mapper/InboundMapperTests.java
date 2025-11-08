package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.*;
import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.CriteriaInbound;
import com.ssg.meowcoffee.dto.InboundReqItemDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.time.temporal.ChronoUnit;
import lombok.extern.log4j.Log4j2;
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
    CriteriaInbound companyCriteria = new CriteriaInbound();
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
    CriteriaInbound managerCriteria = new CriteriaInbound();
    String managerUserId = "manager01"; // 관리자 ID
    UserRole managerUserRole = UserRole.MANAGER;

    List<InboundReqItemDTO> managerResultList = inboundMapper.selectInReqItemList(managerCriteria, managerUserId, managerUserRole);

    assertNotNull(managerResultList, "결과 리스트는 null이 아니어야 합니다.");
    // 샘플 데이터의 inboundItems는 총 10개
    assertEquals(10, managerResultList.size(), "관리자는 모든 상세 항목(10개)을 조회할 수 있어야 합니다.");
    log.info("관리자 전체 조회 결과 {}건 확인", managerResultList.size());


    // --- 시나리오 3: 관리자 권한 + 필터링(검색) 테스트 ---
    log.info("--- 시나리오 3: 관리자 권한 + 필터링 테스트 (상태: 승인완료) ---");
    CriteriaInbound filterCriteria = new CriteriaInbound();
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
    CriteriaInbound sortCriteria = new CriteriaInbound();
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
    CriteriaInbound pagingCriteria = new CriteriaInbound();
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






}

