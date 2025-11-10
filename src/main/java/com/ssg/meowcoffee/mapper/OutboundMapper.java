package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.dto.OutboundReqInputDTO;
import com.ssg.meowcoffee.dto.OutboundReqItemDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OutboundMapper {

    /** 출고 요청 생성 프로시저 호출 */
    void callCreateOutReq(OutboundReqInputDTO dto);

    /** 출고 요청 수정 프로시저 호출 */
    void callModifyOutReq(OutboundReqInputDTO dto);

    /** 출고 요청 soft delete (UPDATE 영향행 수 반환) */
    int softDeleteOutReq(@Param("outReqId") Long outReqId, @Param("comId") String comId);

    /** 출고 승인 프로시저 */
    void approveOutReq(@Param("outReqId") Long outReqId, @Param("managerId") String managerId);

    /** 출고 배차 등록/수정 프로시저 */
    void registerDispatch(@Param("outReqId") Long outReqId, @Param("vehicleId") String vehicleId);

    /** 출고 배차 취소 프로시저 */
    void cancelDispatch(@Param("outReqId") Long outReqId);

    /** 출고 지시서 생성 프로시저 */
    void createOrder(@Param("outReqId") Long outReqId);

    /** 운송장 생성 프로시저 */
    void createWaybill(@Param("outReqId") Long outReqId);

    /** 실물 출고완료 처리 프로시저 */
    void markReceived(@Param("outReqId") Long outReqId);

    /** 단일 출고 요청 조회 */
    List<OutboundReqItemDTO> selectOutboundReqById(@Param("outReqId") Long outReqId);

    /** 출고 목록 조회 (status 필터 가능) */
    List<OutboundReqItemDTO> selectOutboundList(@Param("status") String status);
}