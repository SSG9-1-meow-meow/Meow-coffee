package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.InboundRequestInputDTO;

public interface InboundService {

  long registerInboundRequest(InboundRequestInputDTO input);

}
