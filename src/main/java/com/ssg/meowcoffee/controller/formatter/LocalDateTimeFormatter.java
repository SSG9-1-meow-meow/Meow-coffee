package com.ssg.meowcoffee.controller.formatter;

import java.text.ParseException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import org.springframework.format.Formatter;

// LocalDateTime 대신 LocalDate를 사용할 경우, 타입을 LocalDateTime에서 LocalDate로 변경해주세요.
public class LocalDateTimeFormatter implements Formatter<LocalDateTime> {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public LocalDateTime parse(String text, Locale locale) throws ParseException {
        return LocalDateTime.parse(text, FORMATTER);
    }

    @Override
    public String print(LocalDateTime object, Locale locale) {
        return FORMATTER.format(object);
    }
}
