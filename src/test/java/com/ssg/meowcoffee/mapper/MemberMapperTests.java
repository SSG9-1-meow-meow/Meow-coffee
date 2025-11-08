package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.ManagerVO;
import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.Criteria;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserInfoDTO;
import com.ssg.meowcoffee.dto.UserStatusDTO;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MemberMapperTests {

    @Autowired(required = false)
    private MemberMapper memberMapper;

    @Test
    @DisplayName("MemberMapper ResultMap 활용 조회 쿼리 테스트")
    public void testSelectAll() {
        UserCriteria criteria = UserCriteria.builder()
                .pageNum(1)
                .amount(10)
                .build();
        List<UserVO> list = memberMapper.selectUsers(criteria);
        list.forEach(log::info);
        Assertions.assertFalse(list.isEmpty());
    }

    @Test
    @DisplayName("회원정보 테이블에 저장된 회원정보의 개수 구하기")
    public void testGetCount() {
        UserCriteria criteria = UserCriteria.builder().build();
        log.info(memberMapper.getCount(criteria));
    }

    @Test
    @DisplayName("회원권한이 관리자인 회원정보를 조회")
    public void testSelectManagerById() {
        String userId = "manager_kim";
        ManagerVO managerVO = memberMapper.selectManagerById(userId);
        log.info(managerVO);
        Assertions.assertNotNull(managerVO);
    }

    @Test
    @DisplayName("현재 로그인한 회원이 회원 정보를 변경")
    public void testUpdateUser() {
        String userId = "manager01";
        UserInfoDTO newUserInfo = UserInfoDTO.builder()
                .userId(userId)
                .userPwd("2222")
                .userPhone("010-1234-5678")
                .userEmail("manager01@testers.com")
                .build();
        int affected = memberMapper.updateUser(newUserInfo);
        Assertions.assertEquals(1, affected);
    }

    @Test
    @DisplayName("현재 로그인한 총관리자가 회원의 계정상태를 변경 - 회원가입 승인")
    public void testUpdateUserStatus() {
        String userId = "manager02";
        UserStatusDTO newStatus = UserStatusDTO.builder()
                .userId(userId)
                .userRole(UserRole.COMPANY)
                .oldStatus(UserStatus.WAITING_APPROVAL)
                .newStatus(UserStatus.APPROVAL)
                .build();
        int affected = memberMapper.updateUserStatus(newStatus);
        Assertions.assertEquals(1, affected);
    }

    @Test
    @DisplayName("현재 로그인한 관리자가 휴면회원 전환 신청 버튼을 클릭")
    public void testDelete() {
        String currentId = "manager01";
        int affected = memberMapper.deleteUser(currentId);
        Assertions.assertEquals(1, affected);
    }
}
