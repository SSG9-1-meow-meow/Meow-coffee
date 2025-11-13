<%-- Created by IntelliJ IDEA. User: a Date: 2025-10-28 Time: 오후 4:10 To
change this template use File | Settings | File Templates. --%>
<%@ page
        language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
<%@ include
        file="/WEB-INF/views/includes/_headerNavNotLogin.jsp" %>

<!-- 여기부터 각 JSP 파일의 메인 컨텐츠가 시작됩니다. -->
<div class="container">
    <div class="page-inner">
        <div class="page-header"></div>
        <div class="row">
            <div class="col-md-8 mx-auto w-66">
                <div class="card">
                    <form name="registerForm" method="post" action="/auth/register">
                        <div class="card-header">
                            <div class="card-title">회원등록 신청</div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 col-lg-6">
                                    <label class="mb-3"><b>기본 인적사항</b></label>
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
                                        <small
                                                id="userIdError"
                                                class="form-text text-danger"
                                        ></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="userPwd">비밀번호</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                name="userPwd"
                                                id="userPwd"
                                                placeholder="비밀번호 입력"
                                                required
                                        />
                                        <small
                                                id="userPwdError"
                                                class="form-text text-danger"
                                        ></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="userPwd">비밀번호 확인</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                name="confirmPwd"
                                                id="confirmPwd"
                                                placeholder="비밀번호 확인"
                                                required
                                        />
                                        <small
                                                id="confirmError"
                                                class="form-text text-danger"
                                        ></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="userEmail">이메일</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                name="userEmail"
                                                id="userEmail"
                                                placeholder="이메일 입력"
                                                required
                                        />
                                        <small
                                                id="emailError"
                                                class="form-text text-danger"
                                        ></small>
                                    </div>
                                    <div class="form-group">
                                        <label for="userPhone">연락처</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                name="userPhone"
                                                id="userPhone"
                                                placeholder="핸드폰번호 입력"
                                                required
                                        />
                                        <small
                                                id="phoneError"
                                                class="form-text text-danger"
                                        ></small>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-6">
                                    <label class="mb-3">
                                        <b>
                                            <c:choose>
                                                <c:when test='${userRole == "COMPANY"}'>
                                                    <span>거래처 </span>
                                                </c:when>
                                                <c:when
                                                        test='${userRole == "MANAGER" || userRole == "ADMIN"}'
                                                >
                                                    <span>관리자 </span>
                                                </c:when>
                                                <c:when test='${userRole == "DELIVERYMAN"}'>
                                                    <span>배송기사 </span>
                                                </c:when>
                                            </c:choose>
                                            <span>인적사항</span>
                                        </b>
                                    </label>

                                    <c:if test='${userRole == "COMPANY"}'>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userCompanyName">업체명</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userCompanyName"
                                                        id="userCompanyName"
                                                        placeholder="업체명 입력"
                                                        required
                                                />
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="col-md-12">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userName"
                                                ><c:out
                                                        value='${userRole == "COMPANY" ? "대표자명" : "회원명"}'
                                                /></label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userName"
                                                        id="userName"
                                                        placeholder='${userRole == "COMPANY" ? '대표자명 입력' : '회원명 입력'}'
                                                        required
                                                />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-12 d-flex">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userCode">
                                                    <c:out
                                                            value='${userRole == "MANAGER" || userRole == "ADMIN" ? "사번 입력" : "사업자등록번호 입력"}'
                                                    />
                                                </label>
                                                <input type="text" class="form-control" name="userCode"
                                                       id="userCode" placeholder='${userRole == 'MANAGER' || userRole == 'ADMIN' ? '사번 입력' : '사업자등록번호 입력'}' required/>
                                                <small
                                                        id="userCodeError"
                                                        class="form-text text-danger"
                                                ></small>
                                            </div>
                                        </div>

                                        <c:if test='${userRole == "DELIVERYMAN"}'>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="userCompanyName">차량번호</label>
                                                    <input
                                                            type="text"
                                                            class="form-control"
                                                            name="vehicleId"
                                                            id="vehicleId"
                                                            placeholder="차량번호 입력"
                                                            required
                                                    />
                                                </div>
                                            </div>
                                            <small
                                                    id="vehicleIdError"
                                                    class="form-text text-danger"
                                            ></small>
                                        </c:if>

                                        <div class="col-md-6 pe-0">
                                            <div class="form-group">
                                                <c:if
                                                        test='${userRole == "MANAGER" || userRole == "ADMIN"}'
                                                >
                                                    <label for="userRole">직급</label>
                                                </c:if>
                                                <input type='${userRole == 'MANAGER' || userRole == 'ADMIN' ? 'text' : 'hidden'}' class="form-control"
                                                       name="userRole" id="userRole" value="${userRole}"
                                                       readonly/>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test='${userRole == "COMPANY"}'>
                                        <div class="col-md-10">
                                            <div class="form-group">
                                                <label for="userRoadAddr">도로명주소</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userRoadAddr"
                                                        id="userRoadAddr"
                                                        placeholder="도로명주소 입력"
                                                        required
                                                />
                                            </div>
                                        </div>
                                        <div class="col-md-10">
                                            <div class="form-group">
                                                <label for="userDetailAddr">상세주소</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        name="userDetailAddr"
                                                        id="userDetailAddr"
                                                        placeholder="상세주소 입력"
                                                        required
                                                />
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="card-action">
                            <div class="d-flex justify-content-evenly mt-0 mb-4 m">
                                <button
                                        type="submit"
                                        id="registerBtn"
                                        onclick="register()"
                                        formaction="/auth/register"
                                        formmethod="post"
                                        class="btn btn-primary"
                                >
                                    회원등록 신청
                                </button>
                                <button type="reset" class="btn btn-danger">초기화</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function register() {
                document.forms['registerForm'].addEventListener('submit', (evt) => {
                    evt.preventDefault();
                    evt.stopPropagation();

                    const registerForm = new FormData(evt.target);
                    const data = Object.fromEntries(registerForm.entries());

                    document.getElementById("userIdError").textContent = "";
                    document.getElementById("userPwdError").textContent = "";
                    document.getElementById("confirmError").textContent = "";
                    document.getElementById("emailError").textContent = "";
                    document.getElementById("phoneError").textContent = "";
                    document.getElementById("userCodeError").textContent = "";
                    // vehicleIdError는 userRole에 따라 선택적으로 처리
                    if (document.getElementById("vehicleIdError")) {
                        document.getElementById("vehicleIdError").textContent = "";
                    }

                    let isValid = true;

                    if (!/^[a-z0-9]{8,20}$/.test(data.userId)) {
                        document.getElementById('userIdError').textContent =
                            '아이디가 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }
                    if (!/^[a-z0-9]{7,20}$/.test(data.userPwd)) {
                        document.getElementById('userPwdError').textContent =
                            '비밀번호가 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }
                    if (data.userPwd !== data.confirmPwd) {
                        document.getElementById('confirmError').textContent =
                            '입력한 비밀번호가 일치하지 않습니다.';
                        isValid = false;
                    }
                    if (!data.userEmail.includes('@')) {
                        document.getElementById('emailError').textContent =
                            '이메일이 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }
                    if (!/^010-?\d{4}-?\d{4}$/.test(data.userPhone)) {
                        document.getElementById('phoneError').textContent =
                            '연락처가 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }
                    if (!/[A-Z0-9]{3}-\d{2}-\d{5}/.test(data.userCode)) {
                        document.getElementById('userCodeError').textContent =
                            '회원코드가 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }
                    if (data.userRole === 'DELIVERYMAN' && (!data.vehicleId || !/^\d{2,3}[가-힣]\d{4}$/.test(data.vehicleId))) {
                        document.getElementById('vehicleIdError').textContent =
                            '차량번호가 입력 형식에 맞지 않습니다.';
                        isValid = false;
                    }

                    if (isValid) {
                        evt.target.submit();
                        return;
                    }
                    evt.target.reset();
                });
            }
        </script>

        <%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
    </div>
</div>
