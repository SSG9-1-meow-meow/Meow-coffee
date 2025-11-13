package com.ssg.springsecurityex.controller;

import com.ssg.springsecurityex.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.ssg.springsecurityex.service.MemberService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final MemberService memberService;

    // 로그인/로그아웃
    @GetMapping({"/login", "/auth"})
    public String login() {
        log.info("GET login page... /login");
        return "redirect:/auth/login";
    }

    @GetMapping("/auth/login")
    public String loginGET() {
        log.info("GET login page... /auth/login");
        return "auth/login";
    }

    @GetMapping("/logout")
    public String logout() throws Exception {
        return "redirect:/auth/logout";
    }


    // 회원가입 경로 설정
    @GetMapping("/auth/register-select")
    public void selectRole(String role, Model model) {
        log.info("select register role ... /auth/register-select");
        model.addAttribute("userRole", role);
    }

    @PostMapping("/auth/register-select")
    public String registerSelect(@RequestParam("userRole") String role) {
        log.info("POST register...");
        return "redirect:/auth/register/"+role;
    }

    @GetMapping("/auth/register")
    public String registerGet() {
        log.info("redirect to /auth/register-select");
        return "redirect:/auth/register-select";
    }

    @GetMapping("/auth/register/{role}")
    public String registerGET(@PathVariable("role") String role, Model model) {
        log.info("GET member register ...");
        model.addAttribute("userRole", role);
        return "auth/register";
    }

    @PostMapping("/auth/register")
    public String registerPost(UserDetailDTO userDetailDTO, RedirectAttributes redirectAttributes) {
        log.info(userDetailDTO.toString());

        // 회원가입 실패 시 회원가입 페이지로 이동
        boolean result = memberService.registerUser(userDetailDTO);
        if (!result) {
            redirectAttributes.addFlashAttribute("registerError", "회원가입에 실패했습니다.");
            return "redirect:/auth/register-select";
        }
        // 회원가입 완료 시 로그인 페이지로 이동
        return "redirect:/auth/login";
    }


    // 아이디 찾기
    @GetMapping("/auth/forgot-id")
    public String forgotId() {
        log.info("GET /auth/forgot-id...");
        return "auth/forgot-id";
    }

    @PostMapping("/auth/forgot-id")
    public String forgotId(String userRole) {
        log.info("POST /auth/forgot-id...");
        return "redirect:/auth/forgot-id/" + userRole;
    }

    @GetMapping("/auth/forgot-id/{role}")
    public String forgotIdSelectRole(@PathVariable("role") String targetRole, HttpSession session, Model model) {
        log.info("GET /auth/forgot-id/" + targetRole);
        if (session.getAttribute("findIdProcessCompleted") != null) {
            session.removeAttribute("findIdProcessCompleted");
            return "redirect:/auth/forgot-id";
        }
        model.addAttribute("targetRole", targetRole);
        return "auth/forgot-id-form";
    }

    @PostMapping("/auth/forgot-id/result")
    public String searchIdByUserInfo(FindIDDTO findIDDTO, HttpSession session, RedirectAttributes redirectAttributes) {
        log.info("POST /auth/forgot-id/result...");
        log.info("findInput: " + findIDDTO.getUserCode());
        FindIDResultDTO foundDTO = memberService.getUserIdBy(findIDDTO);

        if (foundDTO == null || foundDTO.getUserId() == null) {
            redirectAttributes.addFlashAttribute("error", "해당하는 아이디를 찾을 수 없습니다.");
            return "redirect:/auth/forgot-id";
        }
        session.setAttribute("findIdProcessCompleted", true);
        redirectAttributes.addFlashAttribute("foundDTO", foundDTO);
        return "redirect:/auth/forgot-id/result";
    }

    @GetMapping("/auth/forgot-id/result")
    public String foundIdResult(Model model) {
        log.info("GET /auth/forgot-id/result...");
        if (!model.containsAttribute("foundDTO")) {
            log.warn("비정상적인 주소 입력입니다. 아이디 찾기의 첫 페이지로 이동합니다.");
            return "redirect:/auth/forgot-id";
        }
        return "auth/search-id-result";
    }


    // 비밀번호 찾기(비밀번호 재설정)
    @GetMapping("/auth/forgot-pwd")
    public String showForgotPwdForm(HttpSession session) {
        log.info("GET /auth/forgot-pwd...");
        // 비밀번호 찾기를 수행할 아이디, 이메일 입력창 출력
        if (session.getAttribute("resetPwdProcessCompleted") != null) {
            session.removeAttribute("resetPwdProcessCompleted");
            return "redirect:/auth/login";
        }
        return "auth/forgot-pwd-form";
    }

    @PostMapping("/auth/forgot-pwd")
    public String submitForgotPwdForm(ForgotPwdDTO forgotPwdDTO, HttpSession session, RedirectAttributes redirectAttributes) {
        log.info("POST /auth/forgot-pwd...");
        FindIDResultDTO findIDResultDTO = memberService.checkUserInfo(forgotPwdDTO);
        if (findIDResultDTO == null) {
            redirectAttributes.addFlashAttribute("resetPwdError", "해당하는 회원이 없습니다.");
            return "redirect:/auth/forgot-pwd";
        }
        session.setAttribute("resetPwdProcessCompleted", true);
        redirectAttributes.addFlashAttribute("foundDTO", findIDResultDTO);
        return "redirect:/auth/reset-pwd";
    }

    @GetMapping("/auth/reset-pwd")
    public String showResetPwdForm() {  // 비밀번호 변경 페이지 출력
        log.info("GET /auth/reset-pwd...");
        return "auth/reset-pwd-form";
    }

    @PutMapping("/auth/reset-pwd")
    public ResponseEntity<UserDetailDTO> resetPwd(@RequestBody ResetPwdDTO resetPwdDTO, HttpSession session) {
        log.info("PUT /auth/reset-pwd....");
        log.info(resetPwdDTO.getTargetId());
        boolean result = memberService.modifyPwd(resetPwdDTO);
        if (!result) {
            log.error("비밀번호 변경 중 오류 발생");
            return ResponseEntity.badRequest().build();
        }
        session.setAttribute("resetPwdProcessCompleted", true);
        log.info("비밀번호 변경 완료");
        UserDetailDTO user = memberService.getUserById(resetPwdDTO.getTargetId());
        return ResponseEntity.ok(user);
    }
}
