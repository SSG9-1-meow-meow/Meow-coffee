package com.ssg.meowcoffee.mapper;


import com.ssg.meowcoffee.dto.Criteria;
import java.util.List;
import com.ssg.meowcoffee.dto.InboundReqItemDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;
import org.apache.ibatis.annotations.Param;

public interface InboundMapper {
  /**
   * 입고 요청을 저장하는 프로시저를 호출하고, 생성된 ID를 DTO의 generatedInReqId 필드에 담아 반환합니다.
   * @param input DTO에 모든 IN/OUT 파라미터가 포함됩니다.
   */
  void callCreateInReq(InboundReqInputDTO input);


  List<InboundReqItemDTO> selectInReqItemList(
      @Param("criteria") Criteria criteria,
      @Param("userId") String userId,
      @Param("userRole") String userRole
  );



}
