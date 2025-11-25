package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.dto.*;

public interface MemberService {

    UserPageDTO<UserDetailDTO> getUserList(UserCriteria userCriteria);
    UserDetailDTO getUserById(String userId);

    boolean registerUser(UserDetailDTO userDetailDTO);

    boolean modifyUser(UserInfoUpdateDTO userInfoUpdateDTO);           // 회원정보 변경
    boolean modifyUserStatus(UserStatUpdateDTO userStatUpdateDTO);     // 회원상태 변경(총관리자 전용)

    boolean deactivateUser(String currentId);          // 휴면회원 전환 신청
    boolean deactivateUserByAdmin(String targetId);    // 휴면회원 전환(총관리자 전용)

    FindIDResultDTO getUserIdBy(FindIDDTO findIDDTO);
    FindIDResultDTO checkUserInfo(ForgotPwdDTO forgotPwdDTO);  // 비밀번호 변경 전 아이디/이메일 체크
    boolean modifyPwd(ResetPwdDTO resetPwdDTO);
}
