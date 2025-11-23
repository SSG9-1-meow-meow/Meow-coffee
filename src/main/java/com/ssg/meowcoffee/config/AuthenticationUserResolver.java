package com.ssg.meowcoffee.config;

import com.ssg.meowcoffee.dto.CustomUserDetails;
import org.springframework.core.MethodParameter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

// HandlerMethodArgumentResolver 인터페이스 구현
public class AuthenticationUserResolver implements HandlerMethodArgumentResolver {

    /**
     * 해당 파라미터(인자)를 이 리졸버가 처리할지 여부를 결정합니다.
     */
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        // 1. 파라미터에 @AuthenticationPrincipal 어노테이션이 붙어 있어야 하고,
        boolean hasAnnotation = parameter.getParameterAnnotation(AuthenticationPrincipal.class) != null;
        // 2. 파라미터의 타입이 CustomUserDetails 클래스여야 합니다.
        boolean isCustomUserDetails = parameter.getParameterType().equals(CustomUserDetails.class);

        return hasAnnotation && isCustomUserDetails;
    }

    /**
     * 실제로 파라미터에 주입할 객체를 반환합니다.
     */
    @Override
    public Object resolveArgument(
            MethodParameter parameter,
            ModelAndViewContainer mavContainer,
            NativeWebRequest webRequest,
            WebDataBinderFactory binderFactory
    ) throws Exception {

        // ⭐️ AuthService에서 성공했던 핵심 로직을 사용합니다.
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            // 메모리(SecurityContext)에 저장된, 이미 초기화된 유효한 객체를 반환합니다.
            return authentication.getPrincipal();
        }

        // 인증되지 않은 경우나 타입 불일치 시 null 반환 (Spring이 알아서 처리)
        return null;
    }
}