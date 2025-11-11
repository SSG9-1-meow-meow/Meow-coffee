package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.OutboundStatus;
import com.ssg.meowcoffee.dto.OutboundReqInputDTO;
import com.ssg.meowcoffee.dto.OutboundReqItemDTO;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class OutboundMapperTests {

    @Autowired(required = false)
    private OutboundMapper outboundMapper;

    @Test
    @DisplayName("회원 출고 요청 생성 - 프로시저 호출")
    @Transactional
    void testCreateOutboundRequest() {
        LocalDateTime now = LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS);

        OutboundReqInputDTO dto = OutboundReqInputDTO.builder()
                .comId("COM001")
                .managerId("MGR001")
                .outDateWish(LocalDate.now().plusDays(3))
                .isTempo(0)
                .outDttmReq(LocalDateTime.now())
                .outItemsJson("[{\"stkId\":\"STK001\",\"outQtyReq\":10,\"vehicleId\":\"VEH001\"}]")
                .build();

        assertNull(dto.getGeneratedOutReqId());

        assertDoesNotThrow(() -> outboundMapper.callCreateOutReq(dto));
        assertNotNull(dto.getGeneratedOutReqId());
        assertTrue(dto.getGeneratedOutReqId() > 0);
        log.info("생성된 출고 요청 ID: {}", dto.getGeneratedOutReqId());
    }

    @Test
    @DisplayName("회원 출고 요청 수정 - 프로시저 호출")
    @Transactional
    void testModifyOutboundRequest() {
        LocalDateTime now = LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS);

        // 먼저 DB에 출고 요청 생성
        OutboundReqInputDTO createDto = OutboundReqInputDTO.builder()
                .comId("COM001")
                .managerId("MGR001")
                .outDateWish(LocalDate.now().plusDays(3))
                .outDttmReq(LocalDateTime.now())
                .isTempo(0)
                .outItemsJson("[{\"stkId\":\"STK001\",\"outQtyReq\":10,\"vehicleId\":\"VEH001\"}]")
                .build();

        outboundMapper.callCreateOutReq(createDto);
        Long outReqId = createDto.getGeneratedOutReqId();
        assertNotNull(outReqId);

        // 수정용 DTO
        OutboundReqInputDTO modifyDto = OutboundReqInputDTO.builder()
                .outReqId(outReqId) // 반드시 존재하는 ID
                .comId("COM001")
                .isTempo(1)
                .outDateWish(LocalDate.now().plusDays(5))
                .outItemsJson("[{\"stkId\":\"STK002\",\"outQtyReq\":20,\"vehicleId\":\"VEH002\"}]")
                .build();

        assertDoesNotThrow(() -> outboundMapper.callModifyOutReq(modifyDto));
        log.info("수정 완료된 출고 요청 ID: {}", modifyDto.getOutReqId());
    }

    @Test
    @DisplayName("회원 출고 요청 soft delete")
    @Transactional
    void testSoftDeleteOutboundRequest() {
        Long outReqId = 1L;
        String comId = "COM001";

        int affectedRows = outboundMapper.softDeleteOutReq(outReqId, comId);
        assertTrue(affectedRows == 1 || affectedRows == 0);
        log.info("soft delete 영향행 수: {}", affectedRows);
    }

    @Test
    @DisplayName("관리자 출고 승인")
    @Transactional
    void testApproveOutboundRequest() {
        Long outReqId = 1L;
        String managerId = "MGR001";

        assertDoesNotThrow(() -> outboundMapper.approveOutReq(outReqId, managerId));
    }

    @Test
    @DisplayName("관리자 배차 등록/수정")
    @Transactional
    void testRegisterDispatch() {
        Long outReqId = 1L;
        String vehicleId = "VEH001";

        assertDoesNotThrow(() -> outboundMapper.registerDispatch(outReqId, vehicleId));
    }

    @Test
    @DisplayName("관리자 배차 취소")
    @Transactional
    void testCancelDispatch() {
        Long outReqId = 1L;
        assertDoesNotThrow(() -> outboundMapper.cancelDispatch(outReqId));
    }

    @Test
    @DisplayName("출고 지시서 생성")
    @Transactional
    void testCreateOrder() {
        Long outReqId = 1L;
        assertDoesNotThrow(() -> outboundMapper.createOrder(outReqId));
    }

    @Test
    @DisplayName("운송장 생성")
    @Transactional
    void testCreateWaybill() {
        Long outReqId = 1L;
        assertDoesNotThrow(() -> outboundMapper.createWaybill(outReqId));
    }

    @Test
    @DisplayName("실물 출고 완료 처리")
    @Transactional
    void testMarkReceived() {
        Long outReqId = 1L;
        assertDoesNotThrow(() -> outboundMapper.markReceived(outReqId));
    }



    @Test
    @DisplayName("단일 출고 조회")
    @Transactional
    void testSelectOutboundRequestById() {
        Long outReqId = 1L;
        List<OutboundReqItemDTO> list = outboundMapper.selectOutboundReqById(outReqId);
        assertFalse(list.isEmpty(), "조회 결과가 없습니다.");

        OutboundReqItemDTO dto = list.get(0);
        assertNotNull(dto);
        log.info("조회된 출고 요청: {}", dto);
    }


    @Test
    @DisplayName("출고 목록 조회")
    @Transactional
    void testSelectOutboundList() {
        String status = OutboundStatus.PENDING.getName();
        List<OutboundReqItemDTO> list = outboundMapper.selectOutboundList(status);
        assertNotNull(list);
        log.info("조회된 출고 목록 수: {}", list.size());
    }
}
