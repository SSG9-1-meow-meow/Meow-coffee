package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.OutboundReqInputDTO;
import com.ssg.meowcoffee.dto.OutboundReqItemDTO;

import java.util.List;

public interface OutboundService {

    // 회원 출고 요청 생성
    void createOutReq(OutboundReqInputDTO dto);

    // 회원 출고 요청 수정
    void modifyOutReq(OutboundReqInputDTO dto);

    // 회원 출고 요청 soft delete
    void softDeleteOutReq(Long outReqId, String comId);

    // 관리자 출고 승인
    void approveOutReq(Long outReqId, String managerId);

    // 관리자 배차 등록/수정
    void registerDispatch(Long outReqId, String vehicleId);

    // 관리자 배차 취소
    void cancelDispatch(Long outReqId);

    // 관리자 출고지시서 생성
    void createOrder(Long outReqId);

    // 관리자 운송장 생성
    void createWaybill(Long outReqId);

    // 관리자 실물 출고완료 처리
    void markReceived(Long outReqId);

    // 단일 출고 조회
    OutboundReqItemDTO getOutboundReqById(Long outReqId);

    // 출고 목록 조회
    List<OutboundReqItemDTO> getOutboundList(String status);
}