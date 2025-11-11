package com.ssg.meowcoffee.util;

import com.ssg.meowcoffee.domain.OutboundStatus;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OutboundStatusTypeHandler extends BaseTypeHandler<OutboundStatus> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, OutboundStatus parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter.getName()); // DB 저장 값
    }

    @Override
    public OutboundStatus getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String value = rs.getString(columnName);
        return value == null ? null : OutboundStatus.fromName(value);
    }

    @Override
    public OutboundStatus getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String value = rs.getString(columnIndex);
        return value == null ? null : OutboundStatus.fromName(value);
    }

    @Override
    public OutboundStatus getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String value = cs.getString(columnIndex);
        return value == null ? null : OutboundStatus.fromName(value);
    }
}