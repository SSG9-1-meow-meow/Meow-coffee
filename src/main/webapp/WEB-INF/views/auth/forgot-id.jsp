<%--
  Created by IntelliJ IDEA.
  User: USER
  Date: 2025-11-02
  Time: 오후 1:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
<%@ include file="/WEB-INF/views/includes/_headerNavNotLogin.jsp" %>
        <!-- 여기부터 각 JSP 파일의 메인 컨텐츠가 시작됩니다. -->
        <div class="container">
            <div class="page-inner">

                <div class="page-header">
                </div>
                <div class="row">
                    <div class="col-md-8 mx-auto w-66">
                        <div class="card">
                            <form name="forgotIdForm">
                                <div class="card-header">
                                    <div class="card-title">아이디 찾기</div>
                                </div>
                                <div class="card-body">
                                    <div class="text-center">
                                        <small id="forgotIdMsg" class="form-text text-muted"
                                        >아이디를 찾으실 회원유형을 선택해주세요.</small
                                        >
                                    </div>
                                    <div class="col-md-12 mt-4">
                                        <div class="form-group form-group-default">
                                            <div class="selectgroup w-100">
                                                <label class="selectgroup-item">
                                                    <input
                                                            type="radio"
                                                            name="userRole"
                                                            value="COMPANY"
                                                            class="selectgroup-input"
                                                            checked=""
                                                    />
                                                    <span class="selectgroup-button">거래처</span>
                                                </label>
                                                <label class="selectgroup-item">
                                                    <input
                                                            type="radio"
                                                            name="userRole"
                                                            value="MANAGER"
                                                            class="selectgroup-input"
                                                    />
                                                    <span class="selectgroup-button">창고관리자</span>
                                                </label>
                                                <label class="selectgroup-item">
                                                    <input
                                                            type="radio"
                                                            name="userRole"
                                                            value="ADMIN"
                                                            class="selectgroup-input"
                                                    />
                                                    <span class="selectgroup-button">총관리자</span>
                                                </label>
                                                <label class="selectgroup-item">
                                                    <input
                                                            type="radio"
                                                            name="userRole"
                                                            value="DELIVERYMAN"
                                                            class="selectgroup-input"
                                                    />
                                                    <span class="selectgroup-button">배송기사</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-action">
                                    <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                        <button type="submit" formaction="/auth/forgot-id" formmethod="post"  class="btn btn-primary">다음</button>
                                    </div>
                                    <div class="d-flex justify-content-evenly">
                                        <a href="/auth/forgot-pwd">비밀번호 찾기</a>
                                        <a href="/">메인 메뉴</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty error}" >
                    <script>
                        const errorMessage = "<c:out value='${error}'/>"
                        alert(errorMessage)
                    </script>
                </c:if>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>