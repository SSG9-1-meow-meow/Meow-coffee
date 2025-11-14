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
                                비밀번호 찾기
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row d-flex justify-content-center">
                                <div class="col-md-12">
                                    <div class="text-center align-content-center">
                                        <small id="forgotPwdMsg" class="form-text text-muted">
                                            비밀번호를 변경할 회원의 아이디와 이메일을 입력해주세요.
                                        </small>
                                    </div>
                                    <div class="form-group">
                                        <label for="userId">아이디</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                name="userId"
                                                id="userId"
                                                placeholder="아이디 입력"
                                                required
                                        />
                                    </div>
                                    <div class="form-group">
                                        <label for="userEmail">이메일</label>
                                        <input
                                                type="email"
                                                class="form-control"
                                                name="userEmail"
                                                id="userEmail"
                                                placeholder="이메일 입력"
                                                required
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-action">
                            <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                <input type="hidden" name="targetRole" value="${targetRole}">
                                <button type="submit" formaction="/auth/forgot-pwd" formmethod="post"  class="btn btn-primary">다음</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <c:if test="${not empty resetPwdError}" >
        <script>
            const errorMessage = "<c:out value='${resetPwdError}'/>"
            alert(errorMessage)
        </script>
        </c:if>
<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
