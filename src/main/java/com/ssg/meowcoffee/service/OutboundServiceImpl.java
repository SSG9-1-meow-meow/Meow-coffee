package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.mapper.OutboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class OutboundServiceImpl implements OutboundService {

    private final OutboundMapper mapper;

    // ===== 생성/변경/처리 =====
    @Override public void createOutReq(OutboundReqInputDTO dto){ mapper.callCreateOutReq(dto); }
    @Override public void modifyOutReq(OutboundReqInputDTO dto){ mapper.callModifyOutReq(dto); }
    @Override public void softDeleteOutReq(Long outReqId, String comId){ mapper.softDeleteOutReq(outReqId, comId); }
    @Override public void approveOutReq(Long outReqId, String managerId){ mapper.approveOutReq(outReqId, managerId); }
    @Override public void registerDispatch(Long outReqId, String vehicleId){ mapper.registerDispatch(outReqId, vehicleId); }
    @Override public void cancelDispatch(Long outReqId){ mapper.cancelDispatch(outReqId); }
    @Override public void createOrder(Long outReqId){ mapper.createOrder(outReqId); }
    @Override public void createWaybill(Long outReqId){ mapper.createWaybill(outReqId); }
    @Override public void markReceived(Long outReqId){ mapper.markReceived(outReqId); }

    // ===== 조회 =====
    @Override
    public OutboundReqItemDTO getOutboundReqById(Long outReqId) {
        List<OutboundReqItemDTO> list = mapper.selectOutboundReqById(outReqId);
        return (list == null || list.isEmpty()) ? null : list.get(0);
    }

    @Override
    public List<OutboundReqListDTO> getOutboundList(String comName, String status, LocalDate startDate, LocalDate endDate) {
        return mapper.selectOutboundList(comName, status, startDate, endDate);
    }

    // ===== 참고(폼) =====
    @Override public List<StockReadDTO> getAvailableStocksForUser(String role, String userId){
        return mapper.selectAvailableStocksForUser(role, userId);
    }
    @Override public List<VehicleDTO> getVehiclesForUser(String role, String userId){
        return mapper.selectVehiclesForUser(role, userId);
    }
    @Override public List<ManagerDetailDTO> getManagers(){ return mapper.selectManagers(); }

    @Override
    public OutboundPageResponse<OutboundReqListDTO> getOutboundListPaged(String comName, String status, LocalDate startDate, LocalDate endDate, String sortCol, String sortDir, OutboundCriteria criteria) {
        // 정렬 화이트리스트
        if(!"comName".equals(sortCol) && !"outDateWish".equals(sortCol) && !"createdAt".equals(sortCol)){
            sortCol = "createdAt";
        }
        if(!"ASC".equalsIgnoreCase(sortDir)) sortDir = "DESC";

        int total = mapper.countOutboundList(comName, status, startDate, endDate);
        List<OutboundReqListDTO> list = mapper.selectOutboundListPaged(
                comName, status, startDate, endDate,
                sortCol, sortDir,
                Math.max(criteria.getSize(),1),
                criteria.getOffset()
        );
        OutboundPageMaker pm = OutboundPageMaker.of(criteria, total);
        return OutboundPageResponse.<OutboundReqListDTO>builder()
                .list(list)
                .PageMaker(pm)
                .build();
    }

    @Override
    public List<OutboundItemDTO> getOutboundItems(Long outReqId) {
        return mapper.selectOutboundItemsByReqId(outReqId);
    }
}
