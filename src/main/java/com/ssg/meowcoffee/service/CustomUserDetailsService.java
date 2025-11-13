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
            // 여기에 마지막 로그인 날짜 갱신 로직 추가 필요
            memberMapper.updateLoginTime(userData.getUserId());
            return new CustomUserDetails(userData);
        }
        throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
    }
}
