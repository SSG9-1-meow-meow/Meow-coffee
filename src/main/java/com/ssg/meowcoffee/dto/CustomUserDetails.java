package com.ssg.meowcoffee.dto;

import com.ssg.meowcoffee.domain.UserVO;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Log4j2
@Data
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {

    private final UserVO userVO;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> collection = new ArrayList<>();
        collection.add(new SimpleGrantedAuthority("ROLE_" + userVO.getUserRole()));
        return collection;
    }

    @Override
    public String getPassword() {
        return userVO.getUserPwd();
    }

    @Override
    public String getUsername() {
        return userVO.getUserId();
    }

    @Override
    public boolean isAccountNonExpired() {  // 계정 만료
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {   // 계정 잠금
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {  // 자격 증명 만료
        return true;
    }

    @Override
    public boolean isEnabled() {    // 로그인 가능한 계정인지
        return true;
    }
}
