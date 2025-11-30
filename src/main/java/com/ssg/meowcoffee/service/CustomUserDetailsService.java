package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.CustomUserDetails;
import com.ssg.meowcoffee.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service("customUserDetailsService")
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserVO userData = memberMapper.selectLoginUser(username);
        if (userData != null) {
            // 로그인 처리 완료 시 수행할 로직
            memberMapper.updateLoginTime(userData.getUserId());
            return CustomUserDetails.from(userData);
        }
        throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
    }
}
