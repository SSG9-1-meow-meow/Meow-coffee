package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.InboundReqInputDTO;

public interface InboundService {

  long registerInboundRequest(InboundReqInputDTO input);

}
