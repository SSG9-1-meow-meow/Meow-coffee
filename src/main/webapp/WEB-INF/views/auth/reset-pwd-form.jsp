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
                    <form id="resetPwdForm">
                        <div class="card-header">
                            <div class="card-title">
                                비밀번호 재설정
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row d-flex justify-content-center">
                                <div class="col-md-12">
                                    <div class="text-center align-content-center">
                                        <small id="forgotPwdMsg" class="form-text text-muted">
                                            새로 변경할 비밀번호를 입력해주세요.
                                        </small>
                                    </div>
                                    <div class="form-group">
                                        <input type="hidden" name="targetId" id="targetId" value="${foundDTO.userId}">
                                    </div>
                                    <div class="form-group">
                                        <label for="newPwd">비밀번호</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                name="newPwd"
                                                id="newPwd"
                                                placeholder="변경할 비밀번호 입력"
                                                required
                                        />
                                    </div>
                                    <div class="form-group">
                                        <label for="confirmPwd">비밀번호 재입력</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                name="confirmPwd"
                                                id="confirmPwd"
                                                placeholder="변경할 비밀번호 확인"
                                                required
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-action">
                            <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                <button type="button" onclick="resetPwd()" id="resetPwdBtn" class="btn btn-primary">비밀번호 재설정</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function resetPwd() {
                // 1. 입력한 데이터 가져오기
                const userId = document.getElementById('targetId').value;
                const newPwd = document.getElementById('newPwd').value;
                const confirmPwd = document.getElementById('confirmPwd').value;

                // 2. 입력한 비밀번호 유효성 검사
                if (!newPwd || !confirmPwd) {
                    alert("비밀번호를 입력해주세요.");
                    return;
                }
                if (newPwd !== confirmPwd) {
                    alert("입력한 비밀번호가 일치하지 않습니다.");
                    return;
                }

                // 3. 전송할 데이터 지정
                const payload = {
                    targetId: userId,
                    newPwd: newPwd
                };

                axios.put('/auth/reset-pwd', payload)
                    .then(response => {
                        alert("비밀번호 변경이 완료되었습니다.");
                        location.href = "/auth/login";
                    })
                    .catch(error => {
                        alert(error.message);
                    });
            }
        </script>
        <%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
