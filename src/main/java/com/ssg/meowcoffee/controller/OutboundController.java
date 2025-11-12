package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.OutboundReqInputDTO;
import com.ssg.meowcoffee.dto.OutboundReqItemDTO;
import com.ssg.meowcoffee.service.OutboundService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/outbounds")
@Log4j2
@RequiredArgsConstructor
public class OutboundController {

    private final OutboundService outboundService;

    /** 출고 관리 홈 - 목록 조회 */
    @GetMapping
    public ResponseEntity<List<OutboundReqItemDTO>> getOutboundList(
            @RequestParam(required = false) String status) {
        List<OutboundReqItemDTO> list = outboundService.getOutboundList(status);
        return ResponseEntity.ok(list);
    }

    /** 회원 출고 폼 조회 */
    @GetMapping("/req")
    public ResponseEntity<String> getOutboundRequestForm() {
        // 실제 폼 데이터 또는 옵션 반환 가능
        return ResponseEntity.ok("회원 출고 요청 폼 데이터");
    }

    /** 회원 출고 요청 제출 */
    @PostMapping("/req")
    public ResponseEntity<String> createOutboundRequest(@RequestBody OutboundReqInputDTO dto) {
        outboundService.createOutReq(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body("출고 요청 생성 완료, ID=" + dto.getGeneratedOutReqId());
    }

    /** 회원 출고 요청 상세 조회 / 수정 폼 */
    @GetMapping("/{outReqId}")
    public ResponseEntity<OutboundReqItemDTO> getOutboundRequest(@PathVariable Long outReqId) {
        OutboundReqItemDTO dto = outboundService.getOutboundReqById(outReqId);
        return ResponseEntity.ok(dto);
    }

    /** 회원 출고 요청 수정 */
    @PutMapping("/{outReqId}")
    public ResponseEntity<String> modifyOutboundRequest(@PathVariable Long outReqId,
                                                        @RequestBody OutboundReqInputDTO dto) {
        dto.setOutReqId(outReqId);
        outboundService.modifyOutReq(dto);
        return ResponseEntity.ok("출고 요청 수정 완료");
    }

    /** 회원 출고 요청 soft delete */
    @PostMapping("/{outReqId}:delete")
    public ResponseEntity<String> softDeleteOutboundRequest(@PathVariable Long outReqId,
                                                            @RequestParam String comId) {
        outboundService.softDeleteOutReq(outReqId, comId);
        return ResponseEntity.ok("출고 요청 삭제 완료");
    }

    /** 관리자 출고 승인 */
    @PostMapping("/{outReqId}:approve")
    public ResponseEntity<String> approveOutboundRequest(@PathVariable Long outReqId,
                                                         @RequestParam String managerId) {
        outboundService.approveOutReq(outReqId, managerId);
        return ResponseEntity.ok("출고 요청 승인 완료");
    }

    /** 관리자 배차 등록/수정 */
    @PostMapping("/{outReqId}/dispatch")
    public ResponseEntity<String> registerDispatch(@PathVariable Long outReqId,
                                                   @RequestParam String vehicleId) {
        outboundService.registerDispatch(outReqId, vehicleId);
        return ResponseEntity.ok("출고 배차 등록/수정 완료");
    }

    /** 관리자 배차 취소 */
    @DeleteMapping("/{outReqId}/dispatch")
    public ResponseEntity<String> cancelDispatch(@PathVariable Long outReqId) {
        outboundService.cancelDispatch(outReqId);
        return ResponseEntity.ok("출고 배차 취소 완료");
    }

    /** 관리자 출고지시서 생성 */
    @PostMapping("/{outReqId}/order")
    public ResponseEntity<String> createOrder(@PathVariable Long outReqId) {
        outboundService.createOrder(outReqId);
        return ResponseEntity.ok("출고지시서 생성 완료");
    }

    /** 관리자 출고지시서 조회 */
    @GetMapping("/{outReqId}/order")
    public ResponseEntity<String> getOrder(@PathVariable Long outReqId) {
        // 실제 URL 또는 파일 반환 로직 필요
        return ResponseEntity.ok("출고지시서 URL 또는 데이터 조회");
    }

    /** 관리자 운송장 생성 */
    @PostMapping("/{outReqId}/waybill")
    public ResponseEntity<String> createWaybill(@PathVariable Long outReqId) {
        outboundService.createWaybill(outReqId);
        return ResponseEntity.ok("운송장 생성 완료");
    }

    /** 관리자 운송장 조회 */
    @GetMapping("/{outReqId}/waybill")
    public ResponseEntity<String> getWaybill(@PathVariable Long outReqId) {
        return ResponseEntity.ok("운송장 URL 또는 데이터 조회");
    }

    /** 관리자 실물 출고 완료 처리 */
    @PostMapping("/{outReqId}:received")
    public ResponseEntity<String> markReceived(@PathVariable Long outReqId) {
        outboundService.markReceived(outReqId);
        return ResponseEntity.ok("출고 완료 처리 완료");
    }
}
