package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.*;
import com.ssg.meowcoffee.dto.*;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDate;
import java.util.List;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/test-mapper-context.xml")
public class MemberMapperTests {

    @Autowired(required = false)
    private MemberMapper memberMapper;

    @Test
    @DisplayName("페이지네이션 및 검색필터 적용된 회원 리스트 조회")
    public void testSelectAllByFilter() {
        UserCriteria criteria = UserCriteria.builder()
                .pageNum(1)
                .amount(10)
                .roleType(UserRole.COMPANY)
                .type("I")          // 키워드 검색 옵션: 아이디
                .keyword("good")
                .from(LocalDate.parse("2025-06-01"))
                .to(LocalDate.parse("2025-11-01"))
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
    @DisplayName("현재 로그인한 사용자의 마지막 로그인 시간을 갱신")
    public void testLastLoginTime() {
        String loginId = "coffeebiz01";
        int affected = memberMapper.updateLoginTime(loginId);
        Assertions.assertEquals(1, affected);
    }

    @Test
    @DisplayName("회원 리스트에서의 승인대기 중인 특정 회원정보 조회")
    public void testSelectUserById() {
        String userId = "delivery02";
        UserVO userVO = memberMapper.selectUserById(userId);
        Assertions.assertEquals(UserStatus.WAITING_APPROVAL, userVO.getUserStatus());
    }

    @Test
    @DisplayName("로그인할 회원 아이디에 해당하는 회원정보 불러오기")
    public void testSelectLoginUser() {
        String userId = "company_good";
        UserVO userVO = memberMapper.selectLoginUser(userId);
        Assertions.assertNotNull(userVO);
    }

    @Test
    @DisplayName("현재 회원권한이 창고관리자인 회원정보를 조회")
    public void testSelectManagerById() {
        String userId = "manager_kim";
        ManagerVO managerVO = memberMapper.selectManagerById(userId);
        log.info(managerVO);
        Assertions.assertEquals(userId, managerVO.getManagerId());
        Assertions.assertEquals("창고관리자", managerVO.getManagerRole().getValue());
    }

    @Test
    @DisplayName("거래처의 담당자가 현재 회원정보를 조회")
    public void testSelectCompanyById() {
        String userId = "company_basic";
        CompanyVO companyVO = memberMapper.selectCompanyById(userId);
        log.info(companyVO);
        Assertions.assertEquals(userId, companyVO.getComId());
    }

    @Test
    @DisplayName("현재 회원권한이 배송기사인 회원정보를 조회")
    public void testSelectDeliverymanById() {
        String userId = "delivery01";
        DeliverymanVO deliverymanVO = memberMapper.selectDeliverymenById(userId);
        log.info(deliverymanVO);
        Assertions.assertEquals(userId, deliverymanVO.getDelivId());
    }

    @Test
    @DisplayName("입력한 이메일, 사업자등록번호에 해당하는 거래처 아이디 찾기")
    public void testFindCompanyId() {
        String userCode = "123-45-67890";
        String userEmail = "ceo1@meowcoffee.com";
        FindIDDTO findIDDTO = FindIDDTO.builder()
                .targetRole(UserRole.COMPANY.getRoleName())
                .userCode(userCode)
                .userEmail(userEmail)
                .build();

        FindIDResultDTO found = memberMapper.findUserId(findIDDTO);
        Assertions.assertEquals("coffeebiz01", found.getUserId());
        Assertions.assertEquals(UserRole.COMPANY, found.getUserRole());
    }

    @Test
    @DisplayName("입력한 이름, 이메일에 해당하는 창고관리자 아이디 찾기")
    public void testFindManagerId() {
        String userName = "최출고";
        String userEmail = "manager.choi@wms.com";
        FindIDDTO findIDDTO = FindIDDTO.builder()
                .targetRole(UserRole.MANAGER.getRoleName())
                .userName(userName)
                .userEmail(userEmail)
                .build();
        FindIDResultDTO found = memberMapper.findUserId(findIDDTO);
        Assertions.assertEquals("manager_choi", found.getUserId());
        Assertions.assertEquals(UserRole.MANAGER, found.getUserRole());
    }

    @Test
    @DisplayName("입력한 사업자등록번호와 이메일에 해당하는 배송기사 아이디 찾기")
    public void testFindDeliverymanId() {
        String userCode = "120-10-12345";
        String userEmail = "delivery.park@wms.com";
        FindIDDTO findIDDTO = FindIDDTO.builder()
                .targetRole(UserRole.DELIVERY.getRoleName())
                .userCode(userCode)
                .userEmail(userEmail)
                .build();
        FindIDResultDTO found = memberMapper.findUserId(findIDDTO);
        log.info(found.getUserId() + ":" + found.getUserRole());
        Assertions.assertEquals("delivery_park", found.getUserId());
        Assertions.assertEquals(UserRole.DELIVERY, found.getUserRole());
    }

    @Test
    @DisplayName("입력한 아이디, 이메일에 해당하는 회원의 아이디 찾기")
    public void testSelectUserByIdAndEmail() {
        String userId = "company_happy";
        String userEmail = "happy@happy.net";

        ForgotPwdDTO forgotPwdDTO = ForgotPwdDTO.builder()
                .userId(userId)
                .userEmail(userEmail)
                .build();
        FindIDResultDTO findIDResultDTO = memberMapper.selectUserByIdAndEmail(forgotPwdDTO);
        Assertions.assertNotNull(findIDResultDTO);
    }

    @Test
    @DisplayName("입력한 아이디를 사용하는 회원이 이미 존재")
    public void testExistUser() {
        String userId = "company_happy";
        boolean result = memberMapper.existsId(userId);
        Assertions.assertTrue(result);
    }

    @Test
    @DisplayName("새로운 거래처 회원 등록")
    public void testInsertUser() {
        UserDetailDTO newUser = UserDetailDTO.builder()
                .userId("company123")
                .userPwd("123456")
                .userCompanyName("이디야")
                .userName("홍길동")
                .userPhone("010-2345-6789")
                .userCode("987-65-43210")
                .userEmail("company1234@test.com")
                .userRoadAddr("서울시 강남구 테헤란로 46")
                .userDetailAddr("1층")
                .userRole(UserRole.COMPANY)
                .build();
        int affected = memberMapper.insertUser(newUser);
        Assertions.assertEquals(1, affected);
    }

    @Test
    @DisplayName("현재 로그인한 회원이 회원 정보를 변경")
    public void testUpdateUser() {
        String userId = "manager01";
        UserInfoUpdateDTO newUserInfo = UserInfoUpdateDTO.builder()
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
        String userId = "company_good";
        UserStatUpdateDTO newStatus = UserStatUpdateDTO.builder()
                .userId(userId)
                .userStatus(UserStatus.APPROVAL)
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

    @Test
    @DisplayName("현재 로그인한 총관리자가 지정한 회원의 상태를 변경 - 휴면회원 전환")
    public void testDeleteUserByAdmin() {
        String targetId = "manager01";
        int affected = memberMapper.deleteUserByAdmin(targetId);
        Assertions.assertEquals(1, affected);
    }

    @Test
    @DisplayName("비밀번호 변경 작업 수행")
    public void testUpdatePwd() {
        ResetPwdDTO resetPwdDTO = ResetPwdDTO.builder()
                .targetId("company5678")
                .newPwd("12345")
                .build();
        int affected = memberMapper.updatePwd(resetPwdDTO);
        Assertions.assertEquals(1, affected);
    }
}
