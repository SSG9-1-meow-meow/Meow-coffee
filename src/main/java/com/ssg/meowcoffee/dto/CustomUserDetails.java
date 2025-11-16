package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.domain.UserStatus;
import com.ssg.meowcoffee.domain.UserVO;
import lombok.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Log4j2
@Getter
@NoArgsConstructor
public class CustomUserDetails implements UserDetails {

    private String userId;
    private String userPwd;
    private UserRole userRole;
    private UserStatus userStatus;

    public CustomUserDetails(UserVO userVO) {
        this.userId = userVO.getUserId();
        this.userPwd = userVO.getUserPwd();
        this.userRole = userVO.getUserRole();
        this.userStatus = userVO.getUserStatus();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // 현재 로그인한 사용자가 보유한 권한을 반환
        List<GrantedAuthority> collection = new ArrayList<>();
        collection.add(new SimpleGrantedAuthority("ROLE_" + this.userRole));
        return collection;
    }

    @Override
    public String getPassword() {
        // 현재 로그인한 사용자의 비밀번호를 반환
        return this.userPwd;
    }

    @Override
    public String getUsername() {
        // 현재 로그인한 사용자의 아이디를 반환
        return this.userId;
    }

    // 계정 만료, 잠금, 비밀번호 만료 관련 조건을 설정하는 부분
    @Override
    public boolean isAccountNonExpired() {  // 계정 만료조건
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {   // 계정 잠금 조건
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() { // 비밀번호 만료조건
        return true;
    }

    @Override
    public boolean isEnabled() {
        // 로그인 가능한 조건을 지정(승인 완료된 계정이어야만 로그인 가능)
        return this.userStatus == UserStatus.APPROVAL;
    }
}
