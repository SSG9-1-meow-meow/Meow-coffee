package com.ssg.meowcoffee.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.domain.InboundMemoCode;
import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.InboundService;
import javax.validation.Valid;

import com.ssg.meowcoffee.service.QrCodeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Date;
import java.time.ZoneId; // ZoneId import 추가
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Controller
@RequiredArgsConstructor
@RequestMapping("/inbounds")
@Log4j2
public class InboundController {

  private final InboundService inboundService;
  private final QrCodeService qrCodeService;

  // --- [회원/관리자] 입고 관리 페이지 렌더링 메서드 ---
  @GetMapping
  public String inboundListPage() {
    log.info("GET /inbounds - 입고 목록 페이지 렌더링 요청");
    return "inbounds/list"; // /WEB-INF/views/inbounds/list.jsp 렌더링
  }

  // --- [회원/관리자] 입고 관리 페이지 데이터 메소드
  @GetMapping("/api")
  @ResponseBody
  public ResponseEntity<Map<String, Object>> getInboundListData(InboundCriteria criteria) {
    log.info("GET /inbounds/api - 입고 목록 데이터 API 요청. Criteria: {}", criteria);

    // --- 임시 사용자 정보 ---
    String currentUserId = "manager01";
    UserRole currentUserRole = UserRole.MANAGER;

    // 관리자로 테스트
    // String currentUserId = "manager01";
    // UserRole currentUserRole = UserRole.MANAGER;

    try {
      List<InboundDetailDTO> inboundList = inboundService.getInboundListByCriteria(criteria, currentUserId, currentUserRole);
      int totalCount = inboundService.getTotalCount(criteria, currentUserId, currentUserRole);
      InboundPageDTO pageDTO = new InboundPageDTO(criteria, totalCount);

      Map<String, Object> response = new HashMap<>();
      response.put("list", inboundList);
      response.put("pageMaker", pageDTO);

      return ResponseEntity.ok(response);

    } catch (Exception e) {
      log.error("입고 목록 데이터 API 조회 중 오류 발생", e);
      // 오류 발생 시 500 Internal Server Error 응답 반환
      return ResponseEntity.internalServerError().build();
    }
  }

  // --- [회원] 입고 요청 폼 페이지 렌더링
  @GetMapping("/req")
  public String getInboundRequestForm(Model model) throws JsonProcessingException {
    log.info("GET /inbounds/req - 입고 요청 폼 페이지 요청");

    // 1. 서비스 호출하여 전체 커피 목록 조회
    List<CoffeeVO> coffeeList = inboundService.getCoffeeList();

    // 2. JavaScript에서 사용하기 쉽도록 커피 목록을 JSON 문자열로 변환
    ObjectMapper objectMapper = new ObjectMapper();
    String coffeeListAsJson = objectMapper.writeValueAsString(coffeeList);
    model.addAttribute("coffeeListAsJson", coffeeListAsJson);

    // 3. JSP의 <c:forEach>에서도 사용할 수 있도록 List 객체도 전달
    model.addAttribute("coffeeList", coffeeList);

    return "inbounds/request-form"; // /WEB-INF/views/inbounds/request-form.jsp
  }


  // --- [회원] 입고 요청 처리 API
  @PostMapping("/req")
  public String createInboundRequest(@Valid @RequestBody InboundReqInputDTO inputDTO,
                                       RedirectAttributes redirectAttributes) {

    log.info("POST /inbounds/req - 신규 입고 요청 처리 시작: {}", inputDTO);

    // 서버에서 요청 시각을 설정
    inputDTO.set_inDttmReq(LocalDateTime.now());

    long newInReqId = inboundService.registerInboundRequest(inputDTO);
    log.info("입고 요청이 성공적으로 등록되었습니다. (새 ID: {})", newInReqId);

    // 리다이렉트된 페이지에 일회성 성공 메시지 전달
    String message = (inputDTO.get_isTempo() == 1) ? "요청이 임시저장되었습니다." : "입고 요청이 정상적으로 신청되었습니다.";
    redirectAttributes.addFlashAttribute("successMessage", message);

    // PRG 패턴: 성공 시 목록 페이지로 리다이렉트
    return "redirect:/inbounds";
  }

  // --- [회원/관리자] 입고 요청 상세 페이지 렌더링 메서드 ---
  @GetMapping("/{inReqId}")
  public String inboundRequestDetailPage(@PathVariable long inReqId, Model model) {
    log.info("GET /inbounds/{} - 입고 요청 상세 페이지 렌더링 요청", inReqId);

    // --- TODO: 실제 로그인한 사용자 정보로 대체 ---
    UserRole currentUserRole = UserRole.MANAGER; // 또는 UserRole.COMPANY
    // ---------------------------------------------

    // 페이지 자체는 inReqId가 필요할 수 있으므로 모델에 담아 전달
    model.addAttribute("inReqId", inReqId);
    // ★★★ [추가] 현재 사용자 권한 정보를 모델에 추가 ★★★
    model.addAttribute("currentUserRole", currentUserRole.name()); // "MANAGER", "COMPANY" 등 문자열로 전달

    return "inbounds/request-detail";
  }

  // --- [회원/관리자] 입고 요청 상세 데이터 제공 API 메서드 ---
  @GetMapping("/api/{inReqId}")
  @ResponseBody
  public ResponseEntity<Map<String, Object>> getInboundRequestData(@PathVariable long inReqId) {
    log.info("GET /inbounds/api/{} - 입고 요청 상세 데이터 API 요청", inReqId);

    // '수정 모드'를 위해 전체 커피 목록도 함께 조회
    List<CoffeeVO> coffeeList = inboundService.getCoffeeList();

    // 서비스 호출
    List<InboundItemDetailDTO> requestItems = inboundService.getInboundRequestWithItems(inReqId);

    // 서비스 계층에서 null 또는 빈 리스트를 반환한 경우, 404 Not Found 응답
    if (requestItems == null || requestItems.isEmpty()) {
      return ResponseEntity.notFound().build();
    }

    // --- 성공 로직 ---
    Map<String, Object> response = new HashMap<>();
    response.put("coffeeList", coffeeList);
    response.put("requestItems", requestItems);

    return ResponseEntity.ok(response);
  }


  // --- [회원/관리자] 입고 요청 상세 입고 요청 수정(PUT) 처리 메소드
  @PutMapping("/{inReqId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> modifyInboundRequest(@PathVariable long inReqId,
                                                                  @Valid @RequestBody InboundReqInputDTO inputDTO) {
    log.info("PUT /inbounds/{} - 입고 요청 수정 처리 시작", inReqId);
    log.info("수정 데이터: {}", inputDTO);

    // URL의 inReqId와 DTO의 _inReqId가 일치하는지 확인하고, URL 경로를 우선으로 신뢰
    inputDTO.set_inReqId(inReqId);
    // TODO: inputDTO의 _comId는 현재 로그인한 사용자의 ID로 설정해야 보안상 안전합니다.

    inboundService.modifyInboundRequest(inputDTO);

    String message = (inputDTO.get_isTempo() == 1) ? "요청이 임시저장되었습니다." : "요청이 성공적으로 수정되었습니다.";

    return ResponseEntity.ok(Map.of("message", message));
  }

  // [회원/관리자] 입고 요청을 취소(논리적 삭제) 처리 메소드 (DELETE)
  @DeleteMapping("/{inReqId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> cancelInboundRequest(@PathVariable long inReqId) {
    log.info("DELETE /inbounds/{} - 입고 요청 취소 처리 시작", inReqId);

    // --- 임시 사용자 정보 (향후 Spring Security 등 로그인 정보로 대체) ---
    // TODO: 실제 로그인한 사용자 정보 사용
    String currentUserId = "coffeebiz01";
    UserRole currentUserRole = UserRole.COMPANY;

    inboundService.cancelInboundRequest(inReqId, currentUserId, currentUserRole);

    return ResponseEntity.ok(Map.of("message", "요청이 성공적으로 취소되었습니다."));
  }

  /**
   * [관리자] 개별 입고 항목 처리 '페이지'를 렌더링합니다.
   */
  @GetMapping("/items/{inReqItemsId}")
  public String getAdminProcessItemPage(@PathVariable long inReqItemsId, Model model) {
    log.info("GET /inbounds/items/{} - 관리자 입고 처리 페이지 요청", inReqItemsId);

    // JSP에서 API를 호출할 때 사용할 ID를 모델에 담아 전달
    model.addAttribute("inReqItemsId", inReqItemsId);

    // 메모 코드 내용 전달
    Map<String, Map<String, String>> memoCodes = Arrays.stream(InboundMemoCode.values())
            .collect(Collectors.toMap(
                    Enum::name, // "APPROVED"
                    memo -> Map.of("codeName", memo.getCodeName(), "description", memo.getDescription())
                    // "APPROVED" -> { "codeName": "승인", "description": "입고 요청을..." }
            ));

    try {
      model.addAttribute("memoCodesAsJson", new ObjectMapper().writeValueAsString(memoCodes));
    } catch (JsonProcessingException e) {
      model.addAttribute("memoCodesAsJson", "{}");
    }

    return "inbounds/admin/process-item";
  }


  /**
   * [API] 단일 입고 항목의 상세 정보를 JSON으로 반환합니다.
   */
  @GetMapping("/api/items/{inReqItemsId}")
  @ResponseBody
  public ResponseEntity<InboundItemDetailDTO> getInboundItemData(@PathVariable long inReqItemsId) {
    InboundItemDetailDTO itemDetail = inboundService.getInboundItemDetail(inReqItemsId);
    if (itemDetail == null) {
      return ResponseEntity.notFound().build();
    }
    return ResponseEntity.ok(itemDetail);
  }

  @PostMapping("/items/{inReqItemsId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> finalizeInboundItem(
          @PathVariable long inReqItemsId,
          @Valid @RequestBody InboundProcessDTO processDTO) {

    log.info("POST /inbounds/items/{} - 입고 항목 최종 처리", inReqItemsId);

    // URL 경로의 ID를 우선으로 신뢰
    processDTO.setInReqItemsId(inReqItemsId);
    // TODO: processDTO.setManagerId() -> 실제 로그인한 관리자 ID로 설정
    processDTO.setManagerId("manager01"); // 임시 관리자 ID


    inboundService.finalizeInboundItem(processDTO);

    String message = (processDTO.getIsTempo() == 1) ? "임시저장되었습니다." : "성공적으로 처리되었습니다.";
    return ResponseEntity.ok(Map.of("message", message));
  }




  // 하나의 입고 상세 건에 대한 처리 페이지 - QR 코드 작동 테스트용
  @GetMapping("/{inReqId}/{inReqItemsId}")
  public String getInboundDetailPage(@PathVariable long inReqId, @PathVariable long inReqItemsId, Model model) {
    log.info("GET /inbounds/{} - 입고 상세 처리 페이지 요청", inReqItemsId);
    try {
      // 1. 서비스 계층을 통해 입고 상세 정보 조회
      InboundDetailDTO detailDTO = inboundService.getInboundDetail(inReqItemsId);

      if (detailDTO == null) {
        // 데이터가 없는 경우 예외 처리 또는 에러 페이지로 리다이렉트
        log.warn("ID {}에 해당하는 입고 상세 정보가 없습니다.", inReqItemsId);
        // return "redirect:/error/404";
        return "error/404"; // 404 에러 페이지로 이동
      }

      // 2. 조회된 데이터를 모델에 추가하여 뷰로 전달
      model.addAttribute("inboundDetail", detailDTO);

      // 3. QR 코드 테스트를 위한 정보도 모델에 추가
      // DTO의 stkId가 '입고완료' 상태일 때만 채워져 있으므로, 뷰에서 분기 처리 가능
      log.info("조회된 입고 상세 정보: {}", detailDTO);

      // 4. 입고 상세 페이지의 뷰 이름을 반환
      return "inbound/detail"; // 예시 경로: /WEB-INF/views/inbound/detail.jsp

    } catch (Exception e) {
      log.error("입고 상세 정보 조회 중 오류 발생", e);
      // return "redirect:/error/500";
      return "error/500"; // 500 에러 페이지로 이동
    }
  }


  @GetMapping("/memo-codes")
  public ResponseEntity<List<InboundMemoCodeDTO>> getMemoCodes() {
    List<InboundMemoCodeDTO> codes = Arrays.stream(InboundMemoCode.values())
            .map(code -> new InboundMemoCodeDTO(code.name(), code.getDescription()))
            .collect(Collectors.toList());
    return ResponseEntity.ok(codes);
  }

  /**
   * [관리자] 입고 지시서 페이지를 렌더링합니다.
   * @param inReqItemsId 입고 상세 항목 ID
   * @param model 뷰에 데이터를 전달할 모델 객체
   * @return 렌더링할 JSP 뷰 이름
   */
  @GetMapping("/instruction/{inReqItemsId}")
  public String getInboundInstructionPage(@PathVariable long inReqItemsId, Model model) {
    log.info("GET /inbounds/instruction/{} - 입고 지시서 페이지 요청", inReqItemsId);

    // 기존에 만들어 둔 상세 정보 조회 서비스 재사용
    InboundItemDetailDTO instructionDetail = inboundService.getInboundItemDetail(inReqItemsId);

    if (instructionDetail == null) {
      // TODO: 데이터가 없을 경우 에러 페이지 처리
      return "error/404";
    }

    // ★★★ [핵심 수정] LocalDateTime을 Date로 변환하는 로직 추가 ★★★
    if (instructionDetail.getInDttmSchd() != null) {
      // LocalDateTime -> ZonedDateTime -> Instant -> Date 순서로 변환
      Date scheduledDate = Date.from(instructionDetail.getInDttmSchd()
              .atZone(ZoneId.systemDefault())
              .toInstant());
      // 모델에 변환된 Date 객체를 별도로 담아줌
      model.addAttribute("scheduledDateAsDate", scheduledDate);
    }

    // ★★★ [추가] inDttmInsp 필드를 Date 타입으로 변환 ★★★
    if (instructionDetail.getInDttmInsp() != null) {
      Date inspectionDate = Date.from(instructionDetail.getInDttmInsp()
              .atZone(ZoneId.systemDefault())
              .toInstant());
      // 모델에 변환된 Date 객체를 별도로 담아줌
      model.addAttribute("inspectionDateAsDate", inspectionDate);
    }

    // 조회된 데이터를 'instruction'이라는 이름으로 모델에 담아 뷰로 전달
    model.addAttribute("instruction", instructionDetail);

    // /WEB-INF/views/inbounds/instruction.jsp 파일을 렌더링
    return "inbounds/instruction";
  }

  /**
   * [API] 입고 항목의 검수 시작 시각을 기록합니다.
   * @param inReqItemsId 검수를 시작할 입고 상세 항목 ID
   * @return 처리 결과 메시지를 담은 ResponseEntity
   */
  @PutMapping("/items/inspect/{inReqItemsId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> startInboundInspection(@PathVariable long inReqItemsId) {
    log.info("PUT /inbounds/items/inspect/{} - 검수 시작 처리", inReqItemsId);
    try {
      inboundService.startInspection(inReqItemsId);
      return ResponseEntity.ok(Map.of("message", "검수 시작 시각이 정상적으로 기록되었습니다."));
    } catch (Exception e) {
      log.error("검수 시작 처리 중 오류 발생", e);
      // 실제 운영에서는 예외 종류에 따라 다른 응답을 줄 수 있음
      return ResponseEntity.internalServerError().body(Map.of("message", "처리 중 오류가 발생했습니다."));
    }
  }

  /**
   * [API] 입고 항목의 실물 입고를 완료 처리합니다.
   * @param inReqItemsId 입고를 완료할 상세 항목 ID
   * @return 처리 결과 메시지를 담은 ResponseEntity
   */
  @PutMapping("/items/complete/{inReqItemsId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> completePhysicalInbound(@PathVariable long inReqItemsId) {
    log.info("PUT /inbounds/items/complete/{} - 실물 입고 완료 처리", inReqItemsId);
    try {
      inboundService.completePhysicalInbound(inReqItemsId);
      return ResponseEntity.ok(Map.of("message", "실물 입고가 정상적으로 완료 처리되었습니다."));
    } catch (IllegalStateException e) {
      // 서비스에서 발생시킨 예외를 잡아 구체적인 메시지 전달
      return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
    } catch (Exception e) {
      log.error("실물 입고 완료 처리 중 오류 발생", e);
      return ResponseEntity.internalServerError().body(Map.of("message", "처리 중 서버 오류가 발생했습니다."));
    }
  }

  /**
   * [샘플] 재고 상세 정보 페이지를 렌더링합니다.
   * @param stkId 재고 ID
   * @param model
   * @return
   */
  @GetMapping("/stock/detail/{stkId}")
  public String getStockDetailPage(@PathVariable String stkId, Model model) {
    log.info("GET /stock/detail/{} - 재고 상세 정보 페이지 요청", stkId);

    // 1. 실제로는 DB에서 stkId를 이용해 재고 정보를 조회해야 합니다.
    // InboundItemDetailDTO 재사용 (실제로는 StockDetailDTO 같은 별도 DTO 권장)
    // 여기서는 샘플이므로, inReqItemsId를 기반으로 기존 정보를 다시 조회합니다.
    // ※ stkId에서 inReqItemsId를 역으로 찾는 로직이 필요하지만, 여기서는 stkId를 inReqItemsId로 간주하여 샘플 구현
    long inReqItemsId = Long.parseLong(stkId); // ★★ 임시 코드: stkId가 숫자 형태의 inReqItemsId라고 가정
    InboundItemDetailDTO stockDetail = inboundService.getInboundItemDetail(inReqItemsId);

    // ★★★ [핵심 수정] inDttmRecv 필드를 Date 타입으로 변환하여 모델에 추가 ★★★
    if (stockDetail != null && stockDetail.getInDttmRecv() != null) {
      Date receivedDate = Date.from(stockDetail.getInDttmRecv()
              .atZone(ZoneId.systemDefault())
              .toInstant());
      model.addAttribute("receivedDateAsDate", receivedDate);
    }

    model.addAttribute("stock", stockDetail);
    model.addAttribute("stkId", "LPN-" + stkId + "-001"); // 샘플 LPN ID 생성

    // /WEB-INF/views/inbounds/stock-detail.jsp 렌더링
    return "inbounds/stock-detail";
  }




  /**
   * 입고상세 ID(inReqItemsId)에 해당하는 QR 코드 이미지를 반환하는 API
   * @param inReqItemsId
   * @return PNG 이미지
   */
  @GetMapping(value = "/qr/{inReqItemsId}", produces = MediaType.IMAGE_PNG_VALUE)
  @ResponseBody
  public ResponseEntity<byte[]> getStockQrCode(@PathVariable("inReqItemsId") String inReqItemsId) {
    try {
      // 1. QR 코드에 담을 URL 생성
      String qrUrl = "http://localhost:8080/inbounds/qr/" + inReqItemsId;

      // 2. QR 코드 서비스 호출하여 이미지 데이터 생성 (크기: 200x200)
      byte[] qrCodeImage = qrCodeService.generateQrCodeImage(qrUrl, 200, 200);

      // 3. 생성된 이미지 데이터를 ResponseEntity에 담아 반환
      return ResponseEntity.ok().body(qrCodeImage);

    } catch (Exception e) {
      // 오류 발생 시 처리 (예: 기본 이미지 반환 또는 500 에러)
      e.printStackTrace();
      return ResponseEntity.internalServerError().build();
    }
  }

  /**
   * [API for Calendar Icons]
   * 특정 기간 동안의 '전체 창고 합산' 일별 처리 사용량을 반환합니다.
   */
  @GetMapping("/api/capacity-events")
  @ResponseBody
  public ResponseEntity<List<DailyCapacityEventDTO>> getAggregatedCapacityEvents(
          @RequestParam String startDate, @RequestParam String endDate) {

    List<DailyCapacityEventDTO> events = inboundService.getAggregatedDailyCapacitiesForPeriod(startDate, endDate);
    return ResponseEntity.ok(events);
  }

  /**
   * [API for Click Details]
   * 특정 날짜의 '창고별' 상세 부하 정보를 모두 반환합니다.
   */
  @GetMapping("/api/load/{date}")
  @ResponseBody
  public ResponseEntity<List<DailyWarehouseCapacityDTO>> getDailyWarehouseLoadData(
          @PathVariable @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {

    List<DailyWarehouseCapacityDTO> dailyLoads = inboundService.getDailyWarehouseCapacitiesByDate(date);
    return ResponseEntity.ok(dailyLoads);
  }

  @GetMapping("/api/available-locations")
  @ResponseBody
  public ResponseEntity<List<AvailableLocationDTO>> getAvailableLocations(
          @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
          @RequestParam int quantity) {

    List<AvailableLocationDTO> availableLocations = inboundService.findAvailableLocations(date, quantity);
    return ResponseEntity.ok(availableLocations);
  }



}
