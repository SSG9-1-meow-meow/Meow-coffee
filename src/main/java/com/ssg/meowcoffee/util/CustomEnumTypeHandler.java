package com.ssg.meowcoffee.util;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeException;
import org.apache.ibatis.type.TypeHandler;

// DB 테이블의 문자열에 해닿하는 Enum값으로 변환
@RequiredArgsConstructor
public class CustomEnumTypeHandler<E extends Enum<E>> implements TypeHandler<UserEnum> {

    private final Class<E> enumType;

    @Override
    public void setParameter(PreparedStatement pstmt, int i, UserEnum userEnum, JdbcType jdbcType)
            throws SQLException {
        // 쿼리문에 사용할 값 -> DB의 값과 일치하는 enum의 요소
        pstmt.setString(i, userEnum.getName());
    }

    @Override
    public UserEnum getResult(ResultSet rs, String columnName) throws SQLException {
        // executeQuery 수행 결과(칼럼명으로 반환)
        String roleName = rs.getString(columnName);
        return getEnum(roleName);
    }

    @Override
    public UserEnum getResult(ResultSet rs, int i) throws SQLException {
        // executeQuery 수행 결과(칼럼 인덱스를 통해 반환)
        String roleName = rs.getString(i);
        return getEnum(roleName);
    }

    @Override
    public UserEnum getResult(CallableStatement call, int i) throws SQLException {
        // 프로시저 조회 쿼리 실행 시 반환 방법
        String roleName = call.getString(i);
        return getEnum(roleName);
    }

    private UserEnum getEnum(String enumName) {
        // 지정한 Enum 클래스의 상수들 중 해당하는 값을 반환
        return Arrays.stream((UserEnum[])enumType.getEnumConstants())
                .filter(enumConst -> enumName.equals(enumConst.getName()))
                .findAny()
                .orElseThrow(TypeException::new);
    }
}
