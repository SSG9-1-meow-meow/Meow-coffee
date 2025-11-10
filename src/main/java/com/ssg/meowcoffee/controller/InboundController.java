package com.ssg.meowcoffee.controller;

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




  @PostMapping("/req")
  public ResponseEntity<Long> createRequest(@Valid @RequestBody InboundReqInputDTO requestDto) {

// 1. 유효성 검사 실패 시, 이 코드는 실행되지 않고 GlobalExceptionHandler로 바로 넘어갑니다.
    long inReqId = inboundService.registerInboundRequest(requestDto);

    return ResponseEntity.status(HttpStatus.CREATED).body(inReqId);
  }

  // 하나의 입고 상세 건에 대한 처리 페이지
  @GetMapping("/{inReqItemsId}")
  public String getInboundDetailPage(@PathVariable long inReqItemsId, Model model) {
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
