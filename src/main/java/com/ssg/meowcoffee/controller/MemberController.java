package com.ssg.meowcoffee.controller;

import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserDetailDTO;
import com.ssg.meowcoffee.dto.UserPageDTO;
import com.ssg.meowcoffee.dto.UserStatUpdateDTO;
import com.ssg.meowcoffee.service.MemberService;
import javax.validation.Valid;
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
        UserPageDTO<UserDetailDTO> userList = memberService.getUserList(criteria);
        model.addAttribute("userList", userList);
        return ResponseEntity.ok(userList);
    }

    @GetMapping("/list/{id}")
    public ResponseEntity<UserDetailDTO> readUser(@PathVariable("id") String id) {
        UserDetailDTO userById = memberService.getUserById(id);
        if (userById == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(userById);
    }

    @PutMapping("/list/{id}")
    public ResponseEntity<UserDetailDTO> updateUserInfo(
            @PathVariable("id") String id,
            @Valid @RequestBody UserStatUpdateDTO updateDTO) {
        updateDTO.setUserId(id);
        boolean result = memberService.modifyUserStatus(updateDTO);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO updated = memberService.getUserById(id);
        return ResponseEntity.ok(updated);
    }

    @PutMapping("/list/{id}:deactivate")
    public ResponseEntity<UserDetailDTO> deactivateUser(@PathVariable("id") String id) {
        boolean result = memberService.deactivateUserByAdmin(id);
        if (!result) {
            return ResponseEntity.notFound().build();
        }
        UserDetailDTO deactivated = memberService.getUserById(id);
        return ResponseEntity.ok(deactivated);
    }
}
