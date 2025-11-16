package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.AuthService;
import com.ssg.meowcoffee.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/members")
public class MemberController {

    private final MemberService memberService;
    private final AuthService authService;  // 권한 확인 오류 해결

    // 관리자(창고관리자, 총관리자) 전용 기능: 회원리스트 조회, 회원상태 변경, 휴면회원 전환
    @GetMapping("/list")
    public String memberList() {
        log.info("GET /members/list");

        String currentUserRole = authService.getCurrentUserRole();
        if (!currentUserRole.equals("ADMIN") && !currentUserRole.equals("MANAGER")) {
            log.error("관리자 권한이 없는 사용자입니다.");
            return "redirect:/";
        }
        return "member/list";
    }

    @GetMapping("/list/api")
    public ResponseEntity<UserPageDTO<UserDetailDTO>> memberListData(@Valid UserCriteria criteria, BindingResult bindingResult) {
        log.info("GET /members/list/api...");
        if (bindingResult.hasErrors()) {
            criteria = UserCriteria.builder().build();
        }
        UserPageDTO<UserDetailDTO> userPageDTO = memberService.getUserList(criteria);
        return ResponseEntity.ok(userPageDTO);
    }

    // 승인대기, 휴면대기, 휴면상태 회원까지 조회하기 위한 관리자 기능
    @GetMapping("/list/{id}")
    public ResponseEntity<UserDetailDTO> readUser(@PathVariable("id") String userId) {
        String currentUserRole = authService.getCurrentUserRole();

        if (!currentUserRole.equals("ADMIN") && !currentUserRole.equals("MANAGER")) {
            log.error("회원리스트 조회는 관리자만 가능합니다.");
            return ResponseEntity.badRequest().build();
        }

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
        String currentUserRole = authService.getCurrentUserRole();

        if (!currentUserRole.equals("ADMIN")) {
            log.error("회원상태 변경은 오직 총관리자만 가능합니다.");
            return ResponseEntity.badRequest().build();
        }

        updateDTO.setUserId(userId);
        boolean result = memberService.modifyUserStatus(updateDTO);
        if (!result) {
            return ResponseEntity.internalServerError().build();
        }

        UserDetailDTO updated = memberService.getUserById(userId);
        return ResponseEntity.ok(updated);
    }

    @PutMapping("/list/{id}:deactivate")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public ResponseEntity<UserDetailDTO> deactivateUser(@PathVariable("id") String userId) {
        String currentUserRole = authService.getCurrentUserRole();

        if (!currentUserRole.equals("ADMIN")) {
            log.error("휴면회원 전환은 오직 총관리자만 가능합니다.");
            return ResponseEntity.badRequest().build();
        }

        boolean result = memberService.deactivateUserByAdmin(userId);
        if (!result) {
            return ResponseEntity.internalServerError().build();
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
    public ResponseEntity<UserDetailDTO> deactivateCurrentUser(@PathVariable("id") String userId) {
        boolean result = memberService.deactivateUser(userId);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO deactivated = memberService.getUserById(userId);
        return ResponseEntity.ok(deactivated);
    }

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
}
