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
                    <div class="col-md-6 mx-auto w-66">
                        <div class="card">
                            <form name="loginForm">
                                <div class="card-header">
                                    <div class="card-title">회원 로그인</div>
                                </div>
                                <div class="card-body">
                                    <div class="row d-flex justify-content-center">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label for="userId">User ID</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userId"
                                                        id="userId"
                                                        placeholder="아이디 입력"
                                                />
                                            </div>
                                            <div class="form-group">
                                                <label for="userPwd">Enter Password</label>
                                                <input
                                                        type="password"
                                                        class="form-control"
                                                        name="userPwd"
                                                        id="userPwd"
                                                        placeholder="비밀번호 입력"
                                                />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-action">
                                    <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                        <button type="submit" formaction="/auth/loginProcess" formmethod="post"  class="btn btn-primary">로그인</button>
                                        <button type="button" onclick="location.href='/auth/register-select'" formmethod="get" class="btn btn-secondary">회원가입</button>
                                    </div>
                                    <div class="d-flex justify-content-evenly">
                                        <a href="/auth/forgot-id">아이디 찾기</a>
                                        <a href="/auth/forgot-pwd">비밀번호 찾기</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>