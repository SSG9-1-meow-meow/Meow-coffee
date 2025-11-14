package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserStatus;
import com.ssg.meowcoffee.domain.UserVO;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Log4j2
@Data
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails, Serializable {

    private final UserVO userVO;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // 현재 로그인한 사용자가 보유한 권한을 반환
        List<GrantedAuthority> collection = new ArrayList<>();
        collection.add(new SimpleGrantedAuthority("ROLE_" + userVO.getUserRole()));
        return collection;
    }

    @Override
    public String getPassword() {
        // 현재 로그인한 사용자의 비밀번호를 반환
        return userVO.getUserPwd();
    }

    @Override
    public String getUsername() {
        // 현재 로그인한 사용자의 아이디를 반환
        return userVO.getUserId();
    }

    // 계정 만료, 잠금, 자격 증명 만료 관련 조건을 설정하는 부분
    @Override
    public boolean isAccountNonExpired() {  // 만료되지 않은 계정
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() { // 자격 증명 유효조건
        return true;
    }

    @Override
    public boolean isEnabled() {
        // 로그인 가능한 조건을 지정(승인 완료된 계정이어야만 로그인 가능)
        return userVO.getUserStatus() == UserStatus.APPROVAL;
    }
}
