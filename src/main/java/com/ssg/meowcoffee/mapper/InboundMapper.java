package com.ssg.meowcoffee.mapper;


import com.ssg.meowcoffee.domain.CoffeeVO;
import com.ssg.meowcoffee.domain.InboundItemVO;
import com.ssg.meowcoffee.domain.InboundRequestVO;
import com.ssg.meowcoffee.domain.UserRole;
import java.util.List;

import com.ssg.meowcoffee.dto.CriteriaInbound;
import com.ssg.meowcoffee.dto.InboundReqItemDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;
import org.apache.ibatis.annotations.Param;

public interface InboundMapper {
  /**
   * 입고 요청을 저장하는 프로시저를 호출하고, 생성된 ID를 DTO의 generatedInReqId 필드에 담아 반환합니다.
   */
  void callCreateInReq(InboundReqInputDTO input);
  void callUpdateInReq(InboundReqInputDTO input);
  int deleteInReq(@Param("inReqId") Long inReqId,
                  @Param("userId") String userId,
                  @Param("userRole") UserRole userRole);


  List<InboundReqItemDTO> selectInReqItemList(
      @Param("criteria") CriteriaInbound criteria,
      @Param("userId") String userId,
      @Param("userRole") UserRole userRole
  );

  List<CoffeeVO> selectCoffeeList();

  InboundRequestVO selectInReqById(@Param("inReqId") long inReqId);
  List<InboundItemVO> selectInItemsByReqId(@Param("inReqId") long inReqId);


}
