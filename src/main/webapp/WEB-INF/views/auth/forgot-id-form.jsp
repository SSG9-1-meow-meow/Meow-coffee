<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
<%@ include file="/WEB-INF/views/includes/_headerNavNotLogin.jsp" %>

<div class="container">
    <div class="page-inner">

        <div class="page-header">
        </div>
        <div class="row">
            <div class="col-md-6 mx-auto w-66">
                <div class="card">
                    <form name="loginForm">
                        <div class="card-header">
                            <div class="card-title">
                                <c:choose>
                                    <c:when test="${targetRole == 'COMPANY'}">
                                        거래처 아이디 찾기
                                    </c:when>
                                    <c:when test="${targetRole == 'MANAGER' || targetRole == 'ADMIN'}">
                                        관리자 아이디 찾기
                                    </c:when>
                                    <c:when test="${targetRole == 'DELIVERYMAN'}">
                                        배송기사 아이디 찾기
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row d-flex justify-content-center">
                                <div class="col-md-12">
                                    <div class="text-center align-content-center">
                                        <small id="forgotPwdMsg" class="form-text text-muted">
                                            <c:choose>
                                                <c:when test="${targetRole == 'COMPANY' || targetRole == 'DELIVERYMAN'}">
                                                    <span>아이디를 찾고자 하는 ${targetRole == 'COMPANY' ? '거래처' : '배송기사'}의<br/></span>
                                                    <span>사업자등록번호와 이메일을 입력해주세요.</span>
                                                </c:when>
                                                <c:when test="${targetRole == 'MANAGER' || targetRole == 'ADMIN'}">
                                                    <span>아이디를 찾고자 하는 ${targetRole == 'MANAGER' ? '창고관리자' : '총관리자'}의<br/></span>
                                                    <span>이름과 이메일을 입력해주세요.</span>
                                                </c:when>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <div class="form-group">
                                        <c:choose>
                                            <c:when test="${targetRole == 'COMPANY' || targetRole == 'DELIVERYMAN'}">
                                                <label for="userCode">사업자등록번호</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userCode"
                                                        id="userCode"
                                                        placeholder="Enter User Code"
                                                        required
                                                />
                                            </c:when>
                                            <c:when test="${targetRole == 'MANAGER' || targetRole == 'ADMIN'}">
                                                <label for="userName">직원명</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userName"
                                                        id="userName"
                                                        placeholder="Enter User Name"
                                                        required
                                                />
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <div class="form-group">
                                        <label for="userEmail">이메일</label>
                                        <input
                                                type="email"
                                                class="form-control"
                                                name="userEmail"
                                                id="userEmail"
                                                placeholder="Enter Email"
                                                required
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-action">
                            <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                <input type="hidden" name="targetRole" value="${targetRole}">
                                <button type="submit" formaction="/auth/forgot-id/result" formmethod="post"  class="btn btn-primary">다음</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
