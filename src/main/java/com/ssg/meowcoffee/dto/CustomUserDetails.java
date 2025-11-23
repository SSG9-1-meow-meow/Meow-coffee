package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import com.ssg.meowcoffee.domain.UserVO;
import lombok.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Log4j2
@Getter
public class CustomUserDetails extends User implements Serializable {

    private UserRole userRole;
    private UserStatus userStatus;

    private CustomUserDetails(UserVO userVO) {
        super(userVO.getUserId(),
                userVO.getUserPwd(),
                userVO.getUserStatus() == UserStatus.APPROVAL,  // 로그인 가능 조건
                true,                                                   // 계정 유효조건
                true,                                                   // 비밀번호 유효기간
                userVO.getUserStatus() == UserStatus.APPROVAL,          // 계정 활성화 조건
                createAuthorities(userVO.getUserRole())
        );
        this.userRole = userVO.getUserRole();
        this.userStatus = userVO.getUserStatus();
    }

    private static Collection<? extends GrantedAuthority> createAuthorities(UserRole userRole) {
        // 현재 로그인한 사용자가 보유한 권한을 반환
        List<GrantedAuthority> collection = new ArrayList<>();
        collection.add(new SimpleGrantedAuthority("ROLE_" + userRole.getRoleName()));
        return collection;
    }

    public static CustomUserDetails from(UserVO userVO) {
        return new CustomUserDetails(userVO);
    }

    // 기존 코드 호환성 유지용 getter
    public String getUserId() {
        return super.getUsername();
    }
}
