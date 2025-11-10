package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.OutboundReqInputDTO;
import com.ssg.meowcoffee.dto.OutboundReqItemDTO;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.mapper.OutboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Log4j2
@RequiredArgsConstructor
public class OutboundServiceImpl implements OutboundService {

    private final OutboundMapper mapper;

    @Override
    @Transactional
    public void createOutReq(OutboundReqInputDTO dto) {
        try {
            mapper.callCreateOutReq(dto);
        } catch (DataAccessException e) {
            log.error("출고 요청 생성 실패", e);
            throw new DatabaseTransactionException("출고 요청 생성 실패", e);
        }

        if (dto.getGeneratedOutReqId() == null || dto.getGeneratedOutReqId() == 0) {
            throw new DatabaseTransactionException("출고 요청 ID 생성 실패 (프로시저 오류)");
        }
    }

    @Override
    @Transactional
    public void modifyOutReq(OutboundReqInputDTO dto) {
        try {
            mapper.callModifyOutReq(dto);
        } catch (DataAccessException e) {
            log.error("출고 요청 수정 실패", e);
            throw new DatabaseTransactionException("출고 요청 수정 실패", e);
        }
    }

    @Override
    @Transactional
    public void softDeleteOutReq(Long outReqId, String comId) {
        try {
            int affected = mapper.softDeleteOutReq(outReqId, comId);
            if (affected == 0) {
                throw new DatabaseTransactionException("출고 요청 삭제 실패: 권한 없거나 존재하지 않음");
            }
        } catch (DataAccessException e) {
            log.error("출고 요청 삭제 실패", e);
            throw new DatabaseTransactionException("출고 요청 삭제 실패", e);
        }
    }

    @Override
    @Transactional
    public void approveOutReq(Long outReqId, String managerId) {
        try { mapper.approveOutReq(outReqId, managerId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("출고 승인 실패", e); }
    }

    @Override
    @Transactional
    public void registerDispatch(Long outReqId, String vehicleId) {
        try { mapper.registerDispatch(outReqId, vehicleId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("배차 등록 실패", e); }
    }

    @Override
    @Transactional
    public void cancelDispatch(Long outReqId) {
        try { mapper.cancelDispatch(outReqId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("배차 취소 실패", e); }
    }

    @Override
    @Transactional
    public void createOrder(Long outReqId) {
        try { mapper.createOrder(outReqId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("출고지시서 생성 실패", e); }
    }

    @Override
    @Transactional
    public void createWaybill(Long outReqId) {
        try { mapper.createWaybill(outReqId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("운송장 생성 실패", e); }
    }

    @Override
    @Transactional
    public void markReceived(Long outReqId) {
        try { mapper.markReceived(outReqId); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("실물 출고완료 실패", e); }
    }

    @Override
    public OutboundReqItemDTO getOutboundReqById(Long outReqId) {
        try {
            List<OutboundReqItemDTO> list = mapper.selectOutboundReqById(outReqId);
            return list.isEmpty() ? null : list.get(0); // 첫 번째 DTO 반환
        } catch (DataAccessException e) {
            throw new DatabaseTransactionException("단일 출고 조회 실패", e);
        }
    }

    @Override
    public List<OutboundReqItemDTO> getOutboundList(String status) {
        try { return mapper.selectOutboundList(status); }
        catch (DataAccessException e) { throw new DatabaseTransactionException("출고 목록 조회 실패", e); }
    }
}