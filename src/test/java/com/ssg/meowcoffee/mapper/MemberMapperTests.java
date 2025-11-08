package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.UserVO;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@Log4j2
@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MemberMapperTests {

    @Autowired(required = false)
    private MemberMapper memberMapper;

    @Test
    @DisplayName("MemberMapper ResultMap 활용 조회 쿼리 테스트")
    public void testSelectAll() {
        List<UserVO> list = memberMapper.selectAllUsers();
        list.forEach(log::info);
    }
}
