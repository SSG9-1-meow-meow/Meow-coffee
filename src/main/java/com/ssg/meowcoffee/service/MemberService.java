package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.CompanyDetailDTO;
import com.ssg.meowcoffee.dto.DeliverymanDTO;
import com.ssg.meowcoffee.dto.ManagerDetailDTO;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserDetailDTO;
import com.ssg.meowcoffee.dto.UserInfoUpdateDTO;
import com.ssg.meowcoffee.dto.UserPageDTO;
import com.ssg.meowcoffee.dto.UserStatUpdateDTO;

public interface MemberService {

    UserPageDTO<UserDetailDTO> getUserList(UserCriteria userCriteria);
    UserDetailDTO getUserById(String userId);

    ManagerDetailDTO getManagerById(String userId);
    CompanyDetailDTO getCompanyById(String userId);
    DeliverymanDTO getDeliverymenById(String userId);

    void modifyUser(UserInfoUpdateDTO userInfoUpdateDTO);           // 회원정보 변경
    void modifyUserStatus(UserStatUpdateDTO userStatUpdateDTO);     // 회원상태 변경(총관리자 전용)

    void deactivateUser(String currentId);          // 휴면회원 전환 신청
    void deactivateUserByAdmin(String targetId);    // 휴면회원 전환(총관리자 전용)
}
