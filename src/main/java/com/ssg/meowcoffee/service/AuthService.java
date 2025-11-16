package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.UserRole;
import com.ssg.meowcoffee.dto.CustomUserDetails;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Log4j2
@Service
public class AuthService {

    public CustomUserDetails getCurrentUser() throws ClassCastException {
        return (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    public String getCurrentUserId() {
        CustomUserDetails principal = (CustomUserDetails) SecurityContextHolder.getContext()
                .getAuthentication()
                .getPrincipal();
        return principal.getUserId();
    }

    public String getCurrentUserRole() {
        UserRole userRole = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
                .getUserRole();
        return userRole.getRoleName();
    }
}
