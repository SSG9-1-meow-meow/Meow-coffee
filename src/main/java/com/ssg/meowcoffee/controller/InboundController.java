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
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

  // --- 1. 페이지 렌더링 메서드 ---
  /**
   * 입고 관리 목록 '페이지'를 반환합니다. (데이터 없음)
   * 이 메서드는 빈 껍데기 JSP 페이지만 렌더링합니다.
   */
  @GetMapping
  public String inboundListPage() {
    log.info("GET /inbounds - 입고 목록 페이지 렌더링 요청");
    return "inbounds/list"; // /WEB-INF/views/inbounds/list.jsp 렌더링
  }

  @GetMapping("/api")
  @ResponseBody // 이 어노테이션이 메서드의 반환값을 JSON으로 변환해줍니다.
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


  @PostMapping("/req")
  public String createInboundRequest(@Valid @RequestBody InboundReqInputDTO inputDTO,
                                       RedirectAttributes redirectAttributes) {

    log.info("POST /inbounds/req - 신규 입고 요청 처리 시작: {}", inputDTO);

    // 서버에서 요청 시각을 설정
    inputDTO.set_inDttmReq(LocalDateTime.now());

    // 서비스 계층 호출
    long newInReqId = inboundService.registerInboundRequest(inputDTO);

    // --- 성공 로직 (예외가 발생하지 않은 경우) ---
    log.info("입고 요청이 성공적으로 등록되었습니다. (새 ID: {})", newInReqId);

    // 리다이렉트된 페이지에 일회성 성공 메시지 전달
    String message = (inputDTO.get_isTempo() == 1) ? "요청이 임시저장되었습니다." : "입고 요청이 정상적으로 신청되었습니다.";
    redirectAttributes.addFlashAttribute("successMessage", message);

    // PRG 패턴: 성공 시 목록 페이지로 리다이렉트
    return "redirect:/inbounds";
  }

  // --- 상세 '페이지' 렌더링 메서드 ---
  @GetMapping("/{inReqId}")
  public String inboundRequestDetailPage(@PathVariable long inReqId, Model model) {
    log.info("GET /inbounds/{} - 입고 요청 상세 페이지 렌더링 요청", inReqId);

    // 페이지 자체는 inReqId가 필요할 수 있으므로 모델에 담아 전달
    model.addAttribute("inReqId", inReqId);

    return "inbounds/request-detail";
  }

  // --- 2. 상세 '데이터' 제공 API 메서드 ---
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


  // 입고 요청 수정
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

  /**
   * 입고 요청을 취소(논리적 삭제)합니다. (DELETE)
   *
   * @param inReqId URL 경로에서 받은 취소할 입고 요청 ID
   * @return 성공 시 200 OK와 함께 성공 메시지를 담은 ResponseEntity
   */
  @DeleteMapping("/{inReqId}")
  @ResponseBody
  public ResponseEntity<Map<String, String>> cancelInboundRequest(@PathVariable long inReqId) {
    log.info("DELETE /inbounds/{} - 입고 요청 취소 처리 시작", inReqId);

    // --- 임시 사용자 정보 (향후 Spring Security 등 로그인 정보로 대체) ---
    // TODO: 실제 로그인한 사용자 정보 사용
    String currentUserId = "coffeebiz01";
    UserRole currentUserRole = UserRole.COMPANY;
    // -----------------------------------------------------------------

    // 예외(권한 없음 등)는 GlobalExceptionHandler가 처리
    inboundService.cancelInboundRequest(inReqId, currentUserId, currentUserRole);

    return ResponseEntity.ok(Map.of("message", "요청이 성공적으로 취소되었습니다."));
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



}
