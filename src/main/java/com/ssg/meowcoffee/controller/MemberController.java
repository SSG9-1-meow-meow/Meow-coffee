package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/members")
public class MemberController {

    private final MemberService memberService;

    // 관리자(창고관리자, 총관리자) 전용 기능: 회원리스트 조회, 회원상태 변경, 휴면회원 전환
    @GetMapping("/list")
    public String memberList(@Valid UserCriteria criteria, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            criteria = UserCriteria.builder().build();
        }
        model.addAttribute("userList", memberService.getUserList(criteria));
        return "member/list";
    }

    @GetMapping("/list:api")
    public ResponseEntity<UserPageDTO<UserDetailDTO>> memberListData(@Valid UserCriteria criteria, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            criteria = UserCriteria.builder().build();
        }
        UserPageDTO<UserDetailDTO> userPageDTO = memberService.getUserList(criteria);
        model.addAttribute("userPageDTO", userPageDTO);
        return ResponseEntity.ok(userPageDTO);
    }

    // 승인대기, 휴면대기, 휴면상태 회원까지 조회하기 위한 관리자 기능
    @GetMapping("/list/{id}")
    public ResponseEntity<UserDetailDTO> readUser(@PathVariable("id") String userId) {
        UserDetailDTO userById = memberService.getUserById(userId);
        if (userById == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(userById);
    }

    @PutMapping("/list/{id}")
    public ResponseEntity<UserDetailDTO> updateUserInfo(
            @PathVariable("id") String userId,
            @Valid @RequestBody UserStatUpdateDTO updateDTO) {
        updateDTO.setUserId(userId);

        boolean result = memberService.modifyUserStatus(updateDTO);
        if (!result) {
            return ResponseEntity.notFound().build();
        }

        UserDetailDTO updated = memberService.getUserById(userId);
        return ResponseEntity.ok(updated);
    }

    @PutMapping("/list/{id}:deactivate")
    public ResponseEntity<UserDetailDTO> deactivateUser(@PathVariable("id") String userId) {
        boolean result = memberService.deactivateUserByAdmin(userId);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO deactivated = memberService.getUserById(userId);
        return ResponseEntity.ok(deactivated);
    }
    // 관리자 전용 기능 끝

    // 여기서부터는 단일 회원정보 관리
    // 현재 회원정보 수정 & 휴면회원 신청
    @PutMapping("/profile/{id}")
    public ResponseEntity<UserDetailDTO> modifyUserInfo(
            @PathVariable("id") String userId,
            @Valid @RequestBody UserInfoUpdateDTO userInfoUpdateDTO) {
        userInfoUpdateDTO.setUserId(userId);
        boolean result = memberService.modifyUser(userInfoUpdateDTO);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO newProfile = memberService.getUserById(userId);
        return ResponseEntity.ok(newProfile);
    }

    @PutMapping("/profile/{id}:deactivate")
    public ResponseEntity<UserDetailDTO> deactivateCurrentUser(
            @PathVariable("id") String userId,
            RedirectAttributes redirectAttributes) {
        boolean result = memberService.deactivateUser(userId);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO deactivated = memberService.getUserById(userId);
        return ResponseEntity.ok(deactivated);
    }

    // 임시 구현 코드 - 이 부분은 스프링시큐리티를 적용해서 변경할 예정입니다.
    @GetMapping("/profile/{id}")
    public String readUserProfile(@PathVariable("id") String userId, Model model) {
        // 1) 현재 회원 정보 조회
        UserDetailDTO userDetailDTO = memberService.getUserById(userId);

        // 2) 없으면 홈이나 에러 페이지로 보냄
        if (userDetailDTO == null) {
            return "redirect:/index";
        }

        // 3) JSP에서 사용할 모델 세팅
        model.addAttribute("userInfo", userDetailDTO);

        // 4) 프로필 JSP로 포워딩
        return "member/profile";   // /WEB-INF/views/member/profile.jsp
    }

    // 승인완료 상태인 현재 회원정보 조회
    @GetMapping("/profile/{id}:manager")
    public ResponseEntity<ManagerDetailDTO> readManager(@PathVariable("id") String userId) {
        ManagerDetailDTO managerDetail = memberService.getManagerById(userId);
        return (managerDetail != null)
                ? ResponseEntity.ok(managerDetail)
                : ResponseEntity.notFound().build();
    }

    @GetMapping("/profile/{id}:company")
    public ResponseEntity<CompanyDetailDTO> readCompany(@PathVariable("id") String userId) {
        CompanyDetailDTO companyDetail = memberService.getCompanyById(userId);
        return (companyDetail != null)
                ? ResponseEntity.ok(companyDetail)
                : ResponseEntity.notFound().build();
    }

    @GetMapping("/profile/{id}:deliveryman")
    public ResponseEntity<DeliverymanDTO> readDeliveryman(@PathVariable("id") String userId) {
        DeliverymanDTO deliveryman = memberService.getDeliverymenById(userId);
        return (deliveryman != null)
                ? ResponseEntity.ok(deliveryman)
                : ResponseEntity.notFound().build();
    }
}
