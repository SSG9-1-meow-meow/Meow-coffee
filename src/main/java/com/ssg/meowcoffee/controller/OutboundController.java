package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.OutboundService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/outbounds")
@Log4j2
@RequiredArgsConstructor
public class OutboundController {

    private final OutboundService outboundService;

    /* =========================
     *          PAGE (JSP)
     * ========================= */
    /** 목록 페이지 */
    @GetMapping
    public String listPage() {
        return "outbounds/list";
    }

    /** 신규요청 페이지 (out_request-form.jsp) */
    @GetMapping("/req")
    public String outRequestForm(Model model,
                                 @SessionAttribute(value="userId", required=false) String userId,
                                 @SessionAttribute(value="role",   required=false) String role) {

        model.addAttribute("stockList",   outboundService.getAvailableStocksForUser(role, userId));
        model.addAttribute("vehicleList", outboundService.getVehiclesForUser(role, userId));
        model.addAttribute("managerList", outboundService.getManagers());

        model.addAttribute("sessionUserId", userId);
        model.addAttribute("sessionRole",   role);
        model.addAttribute("presetComId",  "COMPANY".equals(role) ? userId : "");
        model.addAttribute("presetMgrId", ("MANAGER".equals(role) || "ADMIN".equals(role)) ? userId : "");

        return "outbounds/out_request-form";
    }

    /** 상세 페이지(숫자 id만 허용) */
    @GetMapping("/{outReqId:\\d+}")
    public String detailPage(@PathVariable Long outReqId, Model model,
                             @SessionAttribute(value="userId", required=false) String userId,
                             @SessionAttribute(value="role",   required=false) String role) {
        model.addAttribute("outReqId", outReqId);
        model.addAttribute("sessionUserId", userId);
        model.addAttribute("sessionRole", role);

        model.addAttribute("vehicleList", outboundService.getVehiclesForUser(role, userId));

        return "outbounds/out_request-detail"; // ← 파일명과 동일
    }


    /** 빈 문자열/NULL 안전 파서 */
    private LocalDate toDate(String s) {
        if (s == null || s.isBlank()) return null;
        try { return LocalDate.parse(s); } catch (Exception e) { return null; }
    }

    /** 회원 출고 요청 폼(옵션 데이터 필요 시) */
    @GetMapping("/api/req")
    @ResponseBody
    public ResponseEntity<String> getOutboundRequestForm() {
        return ResponseEntity.ok("회원 출고 요청 폼 데이터");
    }

    /** 회원 출고 요청 제출 */
    @PostMapping("/api/req")
    @ResponseBody
    public ResponseEntity<String> createOutboundRequest(@RequestBody OutboundReqInputDTO dto) {
        // 서버 기준 생성 시각 강제 세팅
        dto.setOutDttmReq(java.time.LocalDateTime.now());
        outboundService.createOutReq(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body("출고 요청 생성 완료, ID=" + dto.getGeneratedOutReqId());
    }

    /** 회원 출고 요청 상세 조회 (숫자 id만 허용) */
    @GetMapping("/api/{outReqId:\\d+}")
    @ResponseBody
    public ResponseEntity<OutboundReqItemDTO> getOutboundRequest(@PathVariable Long outReqId) {
        return ResponseEntity.ok(outboundService.getOutboundReqById(outReqId));
    }

    /** 회원 출고 요청 수정 */
    @PutMapping("/api/{outReqId:\\d+}")
    @ResponseBody
    public ResponseEntity<String> modifyOutboundRequest(@PathVariable Long outReqId,
                                                        @RequestBody OutboundReqInputDTO dto) {
        dto.setOutReqId(outReqId);
        outboundService.modifyOutReq(dto);
        return ResponseEntity.ok("출고 요청 수정 완료");
    }

    /** 회원 출고 요청 soft delete */
    @PostMapping("/api/{outReqId:\\d+}:delete")
    @ResponseBody
    public ResponseEntity<String> softDeleteOutboundRequest(@PathVariable Long outReqId,
                                                            @RequestParam String comId) {
        outboundService.softDeleteOutReq(outReqId, comId);
        return ResponseEntity.ok("출고 요청 삭제 완료");
    }

    /** 관리자 출고 승인 */
    @PostMapping("/api/{outReqId:\\d+}:approve")
    @ResponseBody
    public ResponseEntity<String> approveOutboundRequest(@PathVariable Long outReqId,
                                                         @RequestParam String managerId) {
        outboundService.approveOutReq(outReqId, managerId);
        return ResponseEntity.ok("출고 요청 승인 완료");
    }

    /** 관리자 배차 등록/수정 */
    @PostMapping("/api/{outReqId:\\d+}/dispatch")
    @ResponseBody
    public ResponseEntity<String> registerDispatch(@PathVariable Long outReqId,
                                                   @RequestParam String vehicleId) {
        outboundService.registerDispatch(outReqId, vehicleId);
        return ResponseEntity.ok("출고 배차 등록/수정 완료");
    }

    /** 관리자 배차 취소 */
    @DeleteMapping("/api/{outReqId:\\d+}/dispatch")
    @ResponseBody
    public ResponseEntity<String> cancelDispatch(@PathVariable Long outReqId) {
        outboundService.cancelDispatch(outReqId);
        return ResponseEntity.ok("출고 배차 취소 완료");
    }

    /** 관리자 출고지시서 생성 */
    @PostMapping("/api/{outReqId:\\d+}/order")
    @ResponseBody
    public ResponseEntity<String> createOrder(@PathVariable Long outReqId) {
        outboundService.createOrder(outReqId);
        return ResponseEntity.ok("출고지시서 생성 완료");
    }

    /** 관리자 출고지시서 조회 */
    @GetMapping("/api/{outReqId:\\d+}/order")
    @ResponseBody
    public ResponseEntity<String> getOrder(@PathVariable Long outReqId) {
        return ResponseEntity.ok("출고지시서 URL 또는 데이터 조회");
    }

    /** 관리자 운송장 생성 */
    @PostMapping("/api/{outReqId:\\d+}/waybill")
    @ResponseBody
    public ResponseEntity<String> createWaybill(@PathVariable Long outReqId) {
        outboundService.createWaybill(outReqId);
        return ResponseEntity.ok("운송장 생성 완료");
    }

    /** 관리자 운송장 조회 */
    @GetMapping("/api/{outReqId:\\d+}/waybill")
    @ResponseBody
    public ResponseEntity<String> getWaybill(@PathVariable Long outReqId) {
        return ResponseEntity.ok("운송장 URL 또는 데이터 조회");
    }

    /** 관리자 실물 출고 완료 처리 */
    @PostMapping("/api/{outReqId:\\d+}:received")
    @ResponseBody
    public ResponseEntity<String> markReceived(@PathVariable Long outReqId) {
        outboundService.markReceived(outReqId);
        return ResponseEntity.ok("출고 완료 처리 완료");
    }

    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<OutboundPageResponse<OutboundReqListDTO>> getOutboundList(
            @RequestParam(required = false) String comName,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String dateFrom,
            @RequestParam(required = false) String dateTo,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false, defaultValue = "createdAt,DESC") String sort
    ) {
        if ((comName == null || comName.isBlank()) && keyword != null && !keyword.isBlank()) {
            comName = keyword;
        }
        LocalDate from = toDate(dateFrom);
        LocalDate to   = toDate(dateTo);

        // sort 파싱: "col,DIR"
        String sortCol = "createdAt";
        String sortDir = "DESC";
        if (sort != null && !sort.isBlank()) {
            String[] sp = sort.split(",");
            if (sp.length >= 1) sortCol = sp[0].trim();
            if (sp.length >= 2) sortDir = sp[1].trim().toUpperCase();
        }

        OutboundCriteria criteria = OutboundCriteria.builder().page(page).size(size).build();
        OutboundPageResponse<OutboundReqListDTO> body =
                outboundService.getOutboundListPaged(comName, status, from, to, sortCol, sortDir, criteria);

        return ResponseEntity.ok(body);
    }

    @GetMapping("/api/{outReqId:\\d+}/items")
    @ResponseBody
    public ResponseEntity<List<OutboundItemDTO>> getOutboundItems(@PathVariable Long outReqId) {
        return ResponseEntity.ok(outboundService.getOutboundItems(outReqId));
    }
}
