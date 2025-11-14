<%-- profile.jsp : 권한별(거래처/관리자/배송기사) 회원 단일 조회/수정 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 1) 컨트롤러에서 넘긴 userInfo / userRole / userId 먼저 세팅 --%>
<c:set var="userInfo" value="${userInfo}" />
<c:set var="userRole" value="${userInfo.userRole}" />
<c:set var="userId"   value="${userInfo.userId}" />

<%-- 2) 그 다음에 header include --%>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
<%@ include file="/WEB-INF/views/includes/_headerNav.jsp" %>

<div class="container">
    <div class="page-inner">
        <div class="page-header"></div>

        <div class="row">
            <div class="col-md-8 mx-auto w-66">
                <div class="card">
                    <form id="memberForm">
                        <div class="card-header">
                            <div class="card-title" id="profileTitle">
                                <c:choose>
                                    <c:when test="${userRole == 'COMPANY'}">거래처 회원정보 조회</c:when>
                                    <c:when test="${userRole == 'MANAGER' || userRole == 'ADMIN'}">관리자 회원정보 조회</c:when>
                                    <c:when test="${userRole == 'DELIVERY'}">배송기사 회원정보 조회</c:when>
                                    <c:otherwise>회원정보 조회</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="row">
                                <!-- 왼쪽 : 기본 인적사항 (공통) -->
                                <div class="col-md-6 col-lg-6">
                                    <label class="mb-3"><b>기본 인적사항</b></label>

                                    <div class="form-group">
                                        <label for="userId">아이디(읽기 전용)</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                id="userId"
                                                name="userId"
                                                value="${userInfo.userId}"
                                                readonly
                                        />
                                    </div>

                                    <input type="hidden" id="originPwd" value="${userInfo.userPwd}" />


                                    <div class="form-group">
                                        <label for="currentPwd">현재 비밀번호</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                id="currentPwd"
                                                name="currentPwd"
                                                placeholder="비밀번호 변경 시 입력"
                                        />
                                        <small id="currentPwdError" class="form-text text-danger"></small>
                                    </div>

                                    <div class="form-group">
                                        <label for="newPwd">비밀번호 재입력</label>
                                        <input
                                                type="password"
                                                class="form-control"
                                                id="newPwd"
                                                name="newPwd"
                                                placeholder="변경할 비밀번호 재입력"
                                        />
                                        <small id="newPwdError" class="form-text text-danger"></small>
                                    </div>

                                    <div class="form-group">
                                        <label for="userEmail">이메일</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                id="userEmail"
                                                name="userEmail"
                                                value="${userInfo.userEmail}"
                                                required
                                        />
                                        <small id="emailError" class="form-text text-danger"></small>
                                    </div>

                                    <div class="form-group">
                                        <label for="userPhone">연락처</label>
                                        <input
                                                type="text"
                                                class="form-control"
                                                id="userPhone"
                                                name="userPhone"
                                                value="${userInfo.userPhone}"
                                                required
                                        />
                                        <small id="phoneError" class="form-text text-danger"></small>
                                    </div>
                                </div>

                                <!-- 오른쪽 : 권한별 정보 -->
                                <div class="col-md-6 col-lg-6">

                                    <!-- 거래처 전용 영역 -->
                                    <c:if test="${userRole == 'COMPANY'}">
                                        <div id="companySection">
                                            <label class="mb-3"><b>거래처 확인 정보</b></label>

                                            <div class="form-group">
                                                <label for="userCompanyName">업체명</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="userCompanyName"
                                                        name="userCompanyName"
                                                        value="${userInfo.userCompanyName}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="form-group">
                                                <label for="userName">대표자명</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="userName"
                                                        name="userName"
                                                        value="${userInfo.userName}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="form-group">
                                                <label for="userCode">사업자등록번호</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="userCode"
                                                        name="userCode"
                                                        value="${userInfo.userCode}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="d-flex">
                                                <div class="col-md-6 pe-1">
                                                    <div class="form-group">
                                                        <label for="userRoadAddr">도로명주소</label>
                                                        <input
                                                                type="text"
                                                                class="form-control"
                                                                id="userRoadAddr"
                                                                name="userRoadAddr"
                                                                value="${userInfo.userRoadAddr}"
                                                        />
                                                    </div>
                                                </div>
                                                <div class="col-md-6 ps-1">
                                                    <div class="form-group">
                                                        <label for="userDetailAddr">상세주소</label>
                                                        <input
                                                                type="text"
                                                                class="form-control"
                                                                id="userDetailAddr"
                                                                name="userDetailAddr"
                                                                value="${userInfo.userDetailAddr}"
                                                        />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 관리자(MANAGER/ADMIN) 전용 영역 -->
                                    <c:if test="${userRole == 'MANAGER' || userRole == 'ADMIN'}">
                                        <div id="managerSection">
                                            <label class="mb-3"><b>관리자 확인 정보</b></label>

                                            <div class="form-group">
                                                <label for="adminName">관리자명(읽기 전용)</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="adminName"
                                                        name="adminName"
                                                        value="${userInfo.userName}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="form-group">
                                                <label for="adminCode">사번(읽기 전용)</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="adminCode"
                                                        name="adminCode"
                                                        value="${userInfo.userCode}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="form-group">
                                                <label for="adminRole">직급(읽기 전용)</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="adminRole"
                                                        name="adminRole"
                                                        value="${userRole}"
                                                        readonly
                                                />
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 배송기사 전용 영역 -->
                                    <c:if test="${userRole == 'DELIVERY'}">
                                        <div id="deliverySection">
                                            <label class="mb-3"><b>배송기사 확인 정보</b></label>

                                            <div class="form-group">
                                                <label for="deliveryName">기사명(읽기 전용)</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="deliveryName"
                                                        name="deliveryName"
                                                        value="${userInfo.userName}"
                                                        readonly
                                                />
                                            </div>

                                            <div class="form-group">
                                                <label for="vehicleId">차량번호(읽기 전용)</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="vehicleId"
                                                        name="vehicleId"
                                                        value="${userInfo.vehicleId}"
                                                        readonly
                                                />
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 가입일/최근 로그인 : 공통 하단 -->
                                    <div class="d-flex mt-3">
                                        <div class="col-md-6 pe-1">
                                            <div class="form-group">
                                                <label for="userJoinDate">가입일</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="userJoinDate"
                                                        name="userJoinDate"
                                                        value="${userInfo.userJoinDate}"
                                                        readonly
                                                />
                                            </div>
                                        </div>

                                        <div class="col-md-6 ps-1">
                                            <div class="form-group">
                                                <label for="userLastLogin">최근 로그인</label>
                                                <input
                                                        type="text"
                                                        class="form-control"
                                                        id="userLastLogin"
                                                        name="userLastLogin"
                                                        value="${userInfo.userLastLogin}"
                                                        readonly
                                                />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div> <!-- row -->
                        </div> <!-- card-body -->

                        <div class="card-action">
                            <div class="d-flex justify-content-evenly mt-0 mb-4">
                                <button
                                        type="button"
                                        id="updateBtn"
                                        class="btn btn-primary"
                                >
                                    회원정보 변경
                                </button>

                                <button
                                        type="button"
                                        id="dormantBtn"
                                        class="btn btn-warning"
                                >
                                    휴면전환 신청
                                </button>
                            </div>
                        </div>
                    </form>
                </div> <!-- card -->
            </div>
        </div>

        <!-- 회원정보 변경 모달 -->
        <div class="modal fade" id="updateConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">회원정보 변경</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">회원정보를 변경하시겠습니까?</div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">아니오</button>
                        <button type="button" class="btn btn-primary" id="updateConfirmBtn">예</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 휴면회원 전환 모달 -->
        <div class="modal fade" id="dormantConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">휴면회원 전환</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">휴면회원으로 전환하시겠습니까?</div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">아니오</button>
                        <button type="button" class="btn btn-danger" id="dormantConfirmBtn">예</button>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
    </div>
</div>

<script>
    // 컨텍스트 경로
    const ctx = '${pageContext.request.contextPath}';

    // 컨트롤러에서 넘어온 아이디 / 권한
    const userId   = '${userInfo.userId}';
    const userRole = '${userInfo.userRole}';

    function validateForm() {
        document.getElementById("currentPwdError").textContent = "";
        document.getElementById("newPwdError").textContent = "";
        document.getElementById("emailError").textContent = "";
        document.getElementById("phoneError").textContent = "";

        let isValid = true;

        const currentPwd = document.getElementById("currentPwd").value.trim();
        const newPwd     = document.getElementById("newPwd").value.trim();
        const email      = document.getElementById("userEmail").value.trim();
        const phone      = document.getElementById("userPhone").value.trim();

        // 1) 비밀번호 부분
        if (currentPwd === "" && newPwd === "") {
            // 둘 다 비었으면 비밀번호는 그대로 사용
        } else {
            if (currentPwd === "" && newPwd !== "") {
                document.getElementById("currentPwdError").textContent =
                    "현재 비밀번호를 입력해주세요.";
                isValid = false;
            } else if (currentPwd !== "" && newPwd === "") {
                document.getElementById("newPwdError").textContent =
                    "변경할 비밀번호를 입력해주세요.";
                isValid = false;
            } else {
                if (!/^[a-z0-9]{7,20}$/.test(newPwd)) {
                    document.getElementById("newPwdError").textContent =
                        "새 비밀번호는 영소문자+숫자 7~20자로 입력해주세요.";
                    isValid = false;
                }
            }
        }

        // 2) 이메일 검사
        if (!email.includes("@")) {
            document.getElementById("emailError").textContent =
                "이메일 형식이 올바르지 않습니다.";
            isValid = false;
        }

        // 3) 연락처 검사
        if (!/^010-?\d{4}-?\d{4}$/.test(phone)) {
            document.getElementById("phoneError").textContent =
                "연락처 형식이 올바르지 않습니다.";
            isValid = false;
        }

        return isValid;
    }

    // 회원정보 변경 버튼 클릭 -> 모달 오픈
    document.getElementById("updateBtn").addEventListener("click", function () {
        new bootstrap.Modal(document.getElementById("updateConfirmModal")).show();
    });

    // "예" 버튼 클릭 -> 실제 PUT {ctx}/members/profile/{id}
    document.getElementById("updateConfirmBtn").addEventListener("click", function () {
        if (!validateForm()) return;

        const newPwd    = document.getElementById("newPwd").value.trim();
        const email     = document.getElementById("userEmail").value.trim();
        const phone     = document.getElementById("userPhone").value.trim();
        const originPwd = document.getElementById("originPwd").value || "";   // 기존 비번(해시)

        // 거래처만 주소 수정
        let roadAddr   = null;
        let detailAddr = null;
        if (userRole === 'COMPANY') {
            roadAddr   = document.getElementById("userRoadAddr").value.trim();
            detailAddr = document.getElementById("userDetailAddr").value.trim();
        }

        // 보낼 비밀번호 결정: 기본은 기존 비번, 새 비번 있으면 그걸로 교체
        let sendPwd = originPwd;
        if (newPwd) {
            sendPwd = newPwd;
        }

        const payload = {
            userId: userId,
            userPwd: sendPwd,        // 항상 값 존재
            userPhone: phone,
            userEmail: email,
            userRoadAddr: roadAddr,
            userDetailAddr: detailAddr,
            userImgPath: null
        };

        // ★ 템플릿 문자열 쓰지 말고 문자열 이어붙이기 (EL 충돌 방지)
        fetch(ctx + '/members/profile/' + encodeURIComponent(userId), {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        })
            .then(res => {
                if (!res.ok) {
                    return res.text().then(msg => {
                        console.error('회원정보 변경 실패 - status:', res.status);
                        console.error('response body:', msg);
                        alert('회원정보 변경 중 오류가 발생했습니다.\nstatus=' + res.status);
                        throw new Error('회원정보 변경 실패');
                    });
                }
                return res.json();
            })
            .then(data => {
                // 화면 값 갱신
                document.getElementById("userEmail").value = data.userEmail || '';
                document.getElementById("userPhone").value = data.userPhone || '';

                if (userRole === 'COMPANY') {
                    document.getElementById("userRoadAddr").value   = data.userRoadAddr || '';
                    document.getElementById("userDetailAddr").value = data.userDetailAddr || '';
                }

                // 서버에서 내려준 비밀번호(해시) 다시 hidden에 저장
                if (data.userPwd) {
                    document.getElementById("originPwd").value = data.userPwd;
                }

                document.getElementById("currentPwd").value = "";
                document.getElementById("newPwd").value = "";

                alert('회원정보가 변경되었습니다.');
                bootstrap.Modal
                    .getInstance(document.getElementById("updateConfirmModal"))
                    .hide();
            })
            .catch(err => {
                console.error(err);
            });
    });

    // 휴면전환 신청 버튼 클릭 -> 모달
    document.getElementById("dormantBtn").addEventListener("click", function () {
        new bootstrap.Modal(document.getElementById("dormantConfirmModal")).show();
    });

    // 휴면전환 모달에서 "예" 클릭 -> PUT {ctx}/members/profile/{id}:deactivate
    document.getElementById("dormantConfirmBtn").addEventListener("click", function () {
        fetch(ctx + '/members/profile/' + encodeURIComponent(userId) + ':deactivate', {
            method: 'PUT'
        })
            .then(res => {
                if (!res.ok) {
                    return res.text().then(msg => {
                        console.error('휴면전환 실패 - status:', res.status);
                        console.error('response body:', msg);
                        alert('휴면전환 중 오류가 발생했습니다.\nstatus=' + res.status);
                        throw new Error('휴면전환 실패');
                    });
                }
                return res.json();
            })
            .then(data => {
                alert('휴면회원 전환이 신청되었습니다.');
                bootstrap.Modal
                    .getInstance(document.getElementById("dormantConfirmModal"))
                    .hide();
            })
            .catch(err => {
                console.error(err);
            });
    });
</script>
