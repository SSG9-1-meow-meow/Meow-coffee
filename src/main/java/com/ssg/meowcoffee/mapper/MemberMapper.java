package com.ssg.meowcoffee.mapper;

import com.ssg.meowcoffee.domain.UserVO;
import java.util.List;

public interface MemberMapper {

    List<UserVO> selectUsers();
}
