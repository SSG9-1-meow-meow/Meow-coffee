package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.InboundDetailDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.mapper.InboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.sql.SQLException;

@Service
@Log4j2
@RequiredArgsConstructor
public class InboundServiceImpl implements InboundService {

  private final InboundMapper inboundMapper;

  @Override
  public long registerInboundRequest(InboundReqInputDTO input) {

    try {
      inboundMapper.callCreateInReq(input);
    } catch (Exception e) {
      throw new DatabaseTransactionException("입고 요청 DB 처리 중 실패했습니다.", e);
    }

    Long generatedId = input.getGeneratedInReqId();

    if (generatedId == null || generatedId == 0) {
      throw new DatabaseTransactionException("입고 요청 ID 생성에 실패했습니다. (프로시저 로직 오류 추정)");
    }

    return generatedId;
  }

  @Override
  public void modifyInboundRequest(InboundReqInputDTO input) {
    try {
      inboundMapper.callUpdateInReq(input);
    } catch (DataAccessException e) {
      // 프로시저에서 SIGNAL로 발생시킨 예외가 여기에 포함될 수 있음
      if (e.getCause() instanceof SQLException && ((SQLException) e.getCause()).getMessage().contains("permission denied")) {
        throw new RuntimeException("수정 권한이 없습니다.");
      }
      throw new RuntimeException("입고 요청 수정 중 오류가 발생했습니다.", e);
    }
  }

  @Override
  public InboundDetailDTO getInboundDetail(long inReqItemsId) {
    return inboundMapper.selectInboundDetailById(inReqItemsId);
  }


  public boolean cancelInboundRequest(long inReqId, String userId, UserRole userRole) {
    int affectedRows = inboundMapper.deleteInReq(inReqId, userId, userRole);

    // affectedRows가 1이라는 것은 업데이트가 성공했음을 의미
    if (affectedRows == 0) {
      // 업데이트가 실패한 경우 (요청이 존재하지 않거나, 권한이 없는 경우)
      throw new RuntimeException("요청을 취소할 수 없거나 권한이 없습니다.");
    }
    return true;
  }




}
