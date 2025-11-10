package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.InboundCriteria;
import com.ssg.meowcoffee.dto.InboundDetailDTO;
import com.ssg.meowcoffee.dto.InboundReqInputDTO;

import java.util.List;

public interface InboundService {

  long registerInboundRequest(InboundReqInputDTO input);
  boolean cancelInboundRequest(long inReqId, String userId, UserRole userRole);
  void modifyInboundRequest(InboundReqInputDTO input);
  InboundDetailDTO getInboundDetail(long inReqItemsId);

  List<InboundDetailDTO> getInboundListByCriteria(InboundCriteria criteria, String userId, UserRole userRole);
  int getTotalCount(InboundCriteria criteria, String userId, UserRole userRole);



}
