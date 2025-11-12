package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.*;
import java.time.LocalDate;
import java.util.List;

public interface OutboundService {

    // ===== 생성/변경/처리 =====
    void createOutReq(OutboundReqInputDTO dto);
    void modifyOutReq(OutboundReqInputDTO dto);
    void softDeleteOutReq(Long outReqId, String comId);
    void approveOutReq(Long outReqId, String managerId);
    void registerDispatch(Long outReqId, String vehicleId);
    void cancelDispatch(Long outReqId);
    void createOrder(Long outReqId);
    void createWaybill(Long outReqId);
    void markReceived(Long outReqId);

    // ===== 조회 =====
    OutboundReqItemDTO getOutboundReqById(Long outReqId);

    /** 목록 조회 (거래처명/상태/기간 필터) */
    List<OutboundReqListDTO> getOutboundList(String comName, String status, LocalDate startDate, LocalDate endDate);

    // ===== 참고(폼) =====
    List<StockReadDTO> getAvailableStocksForUser(String role, String userId);
    List<VehicleDTO> getVehiclesForUser(String role, String userId);
    List<ManagerDetailDTO> getManagers();

    OutboundPageResponse<OutboundReqListDTO> getOutboundListPaged(
            String comName, String status, LocalDate from, LocalDate to,
            String sortCol, String sortDir, OutboundCriteria criteria);
}
