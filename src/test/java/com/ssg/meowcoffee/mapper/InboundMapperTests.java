package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.dto.InboundRequestInputDTO;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class InboundMapperTests {

  @Autowired(required = false)
  private InboundMapper inboundMapper;

  @Test
  @Transactional
  public void testCallCreateInReq_Success() {
    log.info("=== 입고 요청 생성 프로시저 테스트 시작 ===");

    // 1. 테스트 데이터 및 DTO 준비
    // 테스트용 JSON 데이터 (inboundItems 테이블에 맞게 cfId와 inQtyReq 필드가 있어야 함)
    // **Java 8 호환 문자열 정의**
    String testItemsJson = "["
        + "{"
        + "\"cfId\": \"CF01\", "
        + "\"inQtyReq\": 10"
        + "},"
        + "{"
        + "\"cfId\": \"CF02\", "
        + "\"inQtyReq\": 5"
        + "}"
        + "]";

    LocalDateTime currentDttm = LocalDateTime.now().truncatedTo(ChronoUnit.MILLIS);

    // DTO에 IN 파라미터 설정
    InboundRequestInputDTO input = InboundRequestInputDTO.builder()
        ._comId("TEST_COM01") // 유효한 comId
        ._inDttmReq(currentDttm)
        ._inDateWish(LocalDate.now().plusDays(60))
        ._inItemsJson(testItemsJson)
        ._isTempo(0) // 0: 정식 요청
        .build();

    // OUT 파라미터 필드는 null로 시작
    input.setGeneratedInReqId(null);

    try {
      // 2. 프로시저 호출
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

  @Test
  @Transactional
  public void testCallCreateInReq_TemporarySave() {
    log.info("=== 임시 저장 프로시저 테스트 시작 ===");

    String testItemsJson = "[{\"cfId\": \"CF0000000003\", \"inQtyReq\": 200}]";

    // DTO에 IN 파라미터 설정
    InboundRequestInputDTO input = InboundRequestInputDTO.builder()
        ._comId("TEST_COM02")
        ._inDttmReq(LocalDateTime.now())
        ._inDateWish(LocalDate.now().plusDays(10))
        ._inItemsJson(testItemsJson)
        ._isTempo(1) // 1: 임시 저장
        .build();

    try {
      // 2. 프로시저 호출
      inboundMapper.callCreateInReq(input);

      // 3. 결과 검증
      Long generatedId = input.getGeneratedInReqId();

      log.info("임시 저장 프로시저 호출 성공. 생성된 inReqId: {}", generatedId);

      assert generatedId != null;
      assert generatedId > 0;

      // *선택적: DB에서 IsTempo 컬럼 값을 직접 조회하여 1인지 확인할 수도 있습니다.*

    } catch (Exception e) {
      log.error("임시 저장 프로시저 호출 중 예외 발생:", e);
      throw new RuntimeException("임시 저장 테스트 실패", e);
    }
  }


}
