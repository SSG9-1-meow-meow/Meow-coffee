package com.ssg.meowcoffee.controller;

import javax.validation.Valid;

import com.ssg.meowcoffee.dto.*;
import com.ssg.meowcoffee.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

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
    public ResponseEntity<UserDetailDTO> deactivateCurrentUser(@PathVariable("id") String userId) {
        boolean result = memberService.deactivateUser(userId);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO deactivated = memberService.getUserById(userId);
        return ResponseEntity.ok(deactivated);
    }

    /* 이 컨트롤러의 내용을 아래와 같이 수정하여 사용합니다. */
    @GetMapping("/profile/{id}")
    public String readUserProfile(@PathVariable("id") String userId, Model model) {
        UserDetailDTO userDetailDTO = memberService.getUserById(userId);
        model.addAttribute("userInfo", userDetailDTO);
        return "member/profile";
    }

    /* 아래의 3개 컨트롤러는 사용하지 않습니다. 아래의 주석 처리한 부분은 삭제해주세요. */

//    // 승인완료 상태인 현재 회원정보 조회
//    @GetMapping("/profile/{id}:manager")
//    public String readManager(@PathVariable("id") String userId, Model model) {
//        ManagerDetailDTO managerDetail = memberService.getManagerById(userId);
//        model.addAttribute("profile", managerDetail);
//        return "member/profile";
//    }
//
//    @GetMapping("/profile/{id}:company")
//    public String readCompany(@PathVariable("id") String userId, Model model) {
//        CompanyDetailDTO companyDetail = memberService.getCompanyById(userId);
//        model.addAttribute("profile", companyDetail);
//        return "member/profile";
//    }
//
//    @GetMapping("/profile/{id}:deliveryman")
//    public String readDeliveryman(@PathVariable("id") String userId, Model model) {
//        DeliverymanDTO deliveryman = memberService.getDeliverymenById(userId);
//        model.addAttribute("profile", deliveryman);
//        return "member/profile";
//    }
}