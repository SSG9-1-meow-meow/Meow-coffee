package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.dto.*;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

public interface OutboundMapper {

    void callCreateOutReq(OutboundReqInputDTO dto);
    void callModifyOutReq(OutboundReqInputDTO dto);
    int  softDeleteOutReq(@Param("outReqId") Long outReqId, @Param("comId") String comId);
    void approveOutReq(@Param("outReqId") Long outReqId, @Param("managerId") String managerId);
    void registerDispatch(@Param("outReqId") Long outReqId, @Param("vehicleId") String vehicleId);
    void cancelDispatch(@Param("outReqId") Long outReqId);
    void createOrder(@Param("outReqId") Long outReqId);
    void createWaybill(@Param("outReqId") Long outReqId);
    void markReceived(@Param("outReqId") Long outReqId);

    List<OutboundReqItemDTO> selectOutboundReqById(@Param("outReqId") Long outReqId);

    /** 목록 조회: 거래처명/상태/기간 */
    List<OutboundReqListDTO> selectOutboundList(
            @Param("comName") String comName,
            @Param("status") String status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    // 폼 참고
    List<StockReadDTO> selectAvailableStocksForUser(@Param("role") String role, @Param("userId") String userId);
    List<VehicleDTO>   selectVehiclesForUser(@Param("role") String role, @Param("userId") String userId);
    List<ManagerDetailDTO> selectManagers();

    List<OutboundReqListDTO> selectOutboundListPaged(
            @Param("comName") String comName,
            @Param("status") String status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            @Param("sortCol") String sortCol,
            @Param("sortDir") String sortDir,
            @Param("size") int size,
            @Param("offset") int offset
    );
    int countOutboundList(
            @Param("comName") String comName,
            @Param("status") String status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    List<OutboundItemDTO> selectOutboundItemsByReqId(@Param("outReqId") Long outReqId);
}