<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %></h1>
<p>${userId}</p>
<p>${roleType}</p>
<br/>
<c:if test="${roleType == 'ROLE_ANONYMOUS'}">
    <a href="/auth/login">Login</a>
</c:if>
<c:if test="${roleType != 'ROLE_ANONYMOUS'}">
    <a href="/auth/logout">Logout</a>
</c:if>
<p></p>
</body>
</html>