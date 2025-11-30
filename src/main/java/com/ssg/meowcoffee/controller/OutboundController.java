package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.AuthService;
import com.ssg.meowcoffee.service.OutboundService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.ssg.meowcoffee.dto.CustomUserDetails;

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
    private final AuthService authService;

    /* =========================
     *          PAGE (JSP)
     * ========================= */
    /** 목록 페이지 */
    @GetMapping
    public String listPage(Model model) {

        CustomUserDetails user = null;
        try {
            user = authService.getCurrentUser();   // 로그인 정보
        } catch (Exception e) {
            // 비로그인인 경우 그냥 null
        }

        if (user != null) {
            String roleName = user.getUserRole().getRoleName(); // "COMPANY", "MANAGER", "ADMIN" ...
            String userId   = user.getUserId();

            model.addAttribute("sessionRole", roleName);
            model.addAttribute("sessionUserId", userId);
        }

        return "outbounds/list";
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

        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        String roleName = user.getUserRole().getRoleName();
        String userId   = user.getUserId();

        // ★ COMPANY만 출고 요청 가능
        if (!"COMPANY".equals(roleName)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("거래처만 출고 요청을 생성할 수 있습니다.");
        }

        // 서버 기준 생성 시각 강제 세팅
        dto.setOutDttmReq(java.time.LocalDateTime.now());
        // ★ comId를 로그인 유저 아이디로 강제
        dto.setComId(userId);

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


    /** 관리자 배차 등록/수정 */
    @PostMapping("/api/{outReqId:\\d+}/dispatch")
    @ResponseBody
    public ResponseEntity<String> registerDispatch(@PathVariable Long outReqId,
                                                   @RequestParam String vehicleId) {

        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        String roleName = user.getUserRole().getRoleName();

        // ★ MANAGER, ADMIN만 배차 가능
        if (!"MANAGER".equals(roleName) && !"ADMIN".equals(roleName)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("배차 등록 권한이 없습니다.");
        }

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

    // 차량 목록 조회 (세션 role/userId 기준)
    @GetMapping("/api/vehicles")
    @ResponseBody
    public List<VehicleDTO> getVehicles(@SessionAttribute(value="role", required=false) String role,
                                        @SessionAttribute(value="userId", required=false) String userId) {
        return outboundService.getVehiclesForUser(role, userId);
    }

    /** 신규요청 페이지 (out_request-form.jsp) */
    @GetMapping("/req")
    public String outRequestForm(Model model) {

        // ★ 시큐리티에서 현재 로그인 유저 정보 가져오기
        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return "redirect:/auth/login";
        }
        String roleName = user.getUserRole().getRoleName(); // "COMPANY", "MANAGER", ...
        String userId   = user.getUserId();

        // ★ COMPANY가 아니면 접근 금지
        if (!"COMPANY".equals(roleName)) {
            return "redirect:/outbounds";   // 혹은 "/"로 보내도 됨
        }

        // 기존 로직 그대로, 세션 대신 시큐리티 값 사용
        model.addAttribute("stockList",   outboundService.getAvailableStocksForUser(roleName, userId));
        model.addAttribute("vehicleList", outboundService.getVehiclesForUser(roleName, userId));
        model.addAttribute("managerList", outboundService.getManagers());

        model.addAttribute("sessionUserId", userId);
        model.addAttribute("sessionRole",   roleName);
        model.addAttribute("presetComId",  userId);          // COMPANY면 comId = userId
        model.addAttribute("presetMgrId",  "");              // 회사는 매니저 X

        return "outbounds/out_request-form";
    }

    /** 상세 페이지(숫자 id만 허용) */
    @GetMapping("/{outReqId:\\d+}")
    public String detailPage(@PathVariable Long outReqId,
                             Model model) {

        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return "redirect:/auth/login";
        }
        String roleName = user.getUserRole().getRoleName();
        String userId   = user.getUserId();

        // ★ COMPANY인 경우: 자기 회사(outboundrequest.comId == userId) 것만 조회 허용
        if ("COMPANY".equals(roleName)) {
            OutboundReqItemDTO header = outboundService.getOutboundReqById(outReqId);
            if (header == null || header.getComId() == null || !userId.equals(header.getComId())) {
                // 남의 출고요청이면 접근 차단
                return "redirect:/outbounds";
            }
        }

        model.addAttribute("outReqId", outReqId);
        model.addAttribute("sessionUserId", userId);
        model.addAttribute("sessionRole",   roleName);

        // 차량 목록은 MANAGER/ADMIN에서만 의미 있지만, 기존 코드 유지
        model.addAttribute("vehicleList", outboundService.getVehiclesForUser(roleName, userId));

        return "outbounds/out_request-detail";
    }


    /** 관리자 출고 승인 */
    @PostMapping("/api/{outReqId:\\d+}:approve")
    @ResponseBody
    public ResponseEntity<String> approveOutboundRequest(@PathVariable Long outReqId) {

        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        String roleName = user.getUserRole().getRoleName();
        String userId   = user.getUserId();

        // ★ MANAGER, ADMIN만 승인 가능
        if (!"MANAGER".equals(roleName) && !"ADMIN".equals(roleName)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("출고 승인 권한이 없습니다.");
        }

        // ★ 여기서 managerId로 로그인 아이디 사용
        outboundService.approveOutReq(outReqId, userId);

        return ResponseEntity.ok("출고 요청 승인 완료");
    }


    /** 관리자 실물 출고 완료 처리 */
    @PostMapping("/api/{outReqId:\\d+}:received")
    @ResponseBody
    public ResponseEntity<String> markReceived(@PathVariable Long outReqId) {

        CustomUserDetails user = authService.getCurrentUser();
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        String roleName = user.getUserRole().getRoleName();

        // ★ MANAGER, ADMIN만 출고 완료 처리
        if (!"MANAGER".equals(roleName) && !"ADMIN".equals(roleName)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("출고 완료 처리 권한이 없습니다.");
        }

        outboundService.markReceived(outReqId);
        return ResponseEntity.ok("출고 완료 처리 완료");
    }

}
