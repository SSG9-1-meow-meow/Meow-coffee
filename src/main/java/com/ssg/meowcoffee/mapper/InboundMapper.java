package com.ssg.meowcoffee.mapper;



import com.ssg.meowcoffee.dto.InboundRequestInputDTO;

public interface InboundMapper {
  /**
   * 입고 요청을 저장하는 프로시저를 호출하고, 생성된 ID를 DTO의 generatedInReqId 필드에 담아 반환합니다.
   * @param input DTO에 모든 IN/OUT 파라미터가 포함됩니다.
   */
  void callCreateInReq(InboundRequestInputDTO input);

}
