package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.CompanyVO;
import com.ssg.meowcoffee.domain.DeliverymanVO;
import com.ssg.meowcoffee.domain.ManagerVO;
import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserInfoDTO;
import com.ssg.meowcoffee.dto.UserStatusDTO;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MemberMapper {

    // 회원 리스트 출력(필터링 옵션 지정 - 관리자 전용)
    List<UserVO> selectUsers(@Param("cri") UserCriteria criteria);

    // 현재 회원정보 조회
    ManagerVO selectManagerById(String userId);
    CompanyVO selectCompanyById(String userId);
    DeliverymanVO selectDeliverymenById(String userId);

    int getCount(@Param("cri") UserCriteria criteria);

    int updateUser(UserInfoDTO userInfoDTO);                // 회원정보 변경
    int updateUserStatus(UserStatusDTO userStatusDTO);      // 회원상태 변경(총관리자 전용)

    int deleteUser(String currentId);         // 휴면회원 전환 신청
    int deleteUserByAdmin(String targetId);   // 휴면회원 전환(총관리자 전용)
}
