package com.ssg.meowcoffee.util;

import com.ssg.meowcoffee.domain.InboundStatus;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

/**
 * InboundStatus Enum만을 위한 전용 TypeHandler.
 * DB의 VARCHAR('승인대기') <-> Java의 InboundStatus Enum을 변환합니다.
 */
public class InboundStatusTypeHandler extends BaseTypeHandler<InboundStatus> {

    /**
     * Java의 Enum 객체를 DB에 String으로 저장할 때 호출됩니다.
     * (예: InboundStatus.WAITING_APPROVAL -> "승인대기")
     */
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, InboundStatus parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter.getName()); // InboundStatus의 getName() 호출
    }

    /**
     * DB의 String 값을 Java의 Enum 객체로 변환할 때 호출됩니다. (가장 중요)
     * (예: "승인대기" -> InboundStatus.WAITING_APPROVAL)
     */
    @Override
    public InboundStatus getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String name = rs.getString(columnName);
        // DB에서 가져온 name(예: "승인대기")을 이용해 Enum 상수를 찾아서 반환
        return InboundStatus.fromName(name);
    }

    @Override
    public InboundStatus getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String name = rs.getString(columnIndex);
        return InboundStatus.fromName(name);
    }

    @Override
    public InboundStatus getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String name = cs.getString(columnIndex);
        return InboundStatus.fromName(name);
    }
}