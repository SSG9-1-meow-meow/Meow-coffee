package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CompanyVO;
import com.ssg.meowcoffee.domain.DeliverymanVO;
import com.ssg.meowcoffee.domain.ManagerVO;
import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemberMapper {

    // 회원 리스트 출력(필터링 옵션 지정 - 관리자 전용)
    List<UserVO> selectUsers(@Param("cri") UserCriteria criteria);

    // 회원 리스트에서의 회원정보 조회 - 창고관리자, 총관리자 전용기능
    // (승인대기, 휴면상태, 휴면대기 회원도 조회해야 하므로 users에서 조회)
    UserVO selectUserById(@Param("userId") String userId);
    UserVO selectLoginUser(@Param("userId") String userId);

    // 현재 로그인한 회원정보 조회
    ManagerVO selectManagerById(@Param("userId") String userId);
    CompanyVO selectCompanyById(@Param("userId") String userId);
    DeliverymanVO selectDeliverymenById(@Param("userId") String userId);

    int getCount(@Param("cri") UserCriteria criteria);

    int insertUser(@Param("userInfo") UserDetailDTO userDetailDTO);

    // 회원정보 변경
    // 변경된 비밀번호는 서비스 계층에서 반드시 암호화되어 전달되어야 하므로 기존의 updateUser() 메서드를 재사용
    int updateUser(@Param("userInfo") UserInfoUpdateDTO userInfoUpdateDTO);
    int updateUserStatus(@Param("userStat") UserStatUpdateDTO userStatUpdateDTO);      // 회원상태 변경(총관리자 전용)

    int deleteUser(@Param("currentId") String currentId);         // 휴면회원 전환 신청
    int deleteUserByAdmin(@Param("targetId") String targetId);   // 휴면회원 전환(총관리자 전용)

    FindIDResultDTO findUserId(@Param("userInfo") FindIDDTO findIDDTO);
    FindIDResultDTO selectUserByIdAndEmail(@Param("userInfo") ForgotPwdDTO forgotPwdDTO);
    int updateLoginTime(@Param("userId") String userId);
    int updatePwd(@Param("resetPwd") ResetPwdDTO resetPwdDTO);
    boolean existsId(String userId);
}
