package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.InboundRequestInputDTO;
import com.ssg.meowcoffee.exception.DatabaseTransactionException;
import com.ssg.meowcoffee.exception.InboundProcessException;
import com.ssg.meowcoffee.mapper.InboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

@Service
@Log4j2
@RequiredArgsConstructor
public class InboundServiceImpl implements InboundService {

  private final InboundMapper inboundMapper;

  /**
   * 입고 요청 데이터를 받아 DB에 저장하고 생성된 ID를 반환합니다.
   * @param input 입고 요청에 필요한 모든 데이터를 담은 DTO
   * @return 생성된 입고 요청 ID (inReqId)
   */
  public long registerInboundRequest(InboundRequestInputDTO input) {

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



}
