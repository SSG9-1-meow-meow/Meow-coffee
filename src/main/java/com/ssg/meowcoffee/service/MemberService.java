package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.CompanyDetailDTO;
import com.ssg.meowcoffee.dto.DeliverymanDTO;
import com.ssg.meowcoffee.dto.ManagerDetailDTO;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserDetailDTO;
import com.ssg.meowcoffee.dto.UserPageDTO;

public interface MemberService {

    UserPageDTO<UserDetailDTO> getUserList(UserCriteria userCriteria);
    UserDetailDTO getUserById(String userId);

    ManagerDetailDTO getManagerById(String userId);
    CompanyDetailDTO getCompanyById(String userId);
    DeliverymanDTO getDeliverymenById(String userId);
}
