package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CompanyVO;
import com.ssg.meowcoffee.domain.DeliverymanVO;
import com.ssg.meowcoffee.domain.ManagerVO;
import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserInfoUpdateDTO;
import com.ssg.meowcoffee.dto.UserStatUpdateDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MemberMapper {

    // 회원 리스트 출력(필터링 옵션 지정 - 관리자 전용)
    List<UserVO> selectUsers(@Param("cri") UserCriteria criteria);

    // 회원 리스트에서의 회원정보 조회 - 창고관리자, 총관리자 전용기능
    // (승인대기, 휴면상태, 휴면대기 회원도 조회해야 하므로 users에서 조회)
    UserVO selectUserById(@Param("userId") String userId);

    // 현재 로그인한 회원정보 조회
    ManagerVO selectManagerById(@Param("userId") String userId);
    CompanyVO selectCompanyById(@Param("userId") String userId);
    DeliverymanVO selectDeliverymenById(@Param("userId") String userId);

    int getCount(@Param("cri") UserCriteria criteria);

    int updateUser(@Param("userInfo") UserInfoUpdateDTO userInfoUpdateDTO);                // 회원정보 변경
    int updateUserStatus(@Param("userStat") UserStatUpdateDTO userStatUpdateDTO);      // 회원상태 변경(총관리자 전용)

    int deleteUser(@Param("currentId") String currentId);         // 휴면회원 전환 신청
    int deleteUserByAdmin(@Param("targetId") String targetId);   // 휴면회원 전환(총관리자 전용)
}
