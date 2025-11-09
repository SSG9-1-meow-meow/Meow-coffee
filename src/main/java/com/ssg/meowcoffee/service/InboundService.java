package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.InboundDetailDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;

public interface InboundService {

  long registerInboundRequest(InboundReqInputDTO input);
  boolean cancelInboundRequest(long inReqId, String userId, UserRole userRole);
  void modifyInboundRequest(InboundReqInputDTO input);
  InboundDetailDTO getInboundDetail(long inReqItemsId);
}
