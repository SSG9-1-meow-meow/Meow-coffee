<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ include
file="/WEB-INF/views/includes/_header.jsp" %>

<div class="page-header">
  <h3 class="fw-bold mb-3">회원관리</h3>
  <ul class="breadcrumbs mb-3">
    <li class="nav-home">
      <a href="#">
        <i class="icon-home"></i>
      </a>
    </li>
    <li class="separator">
      <i class="icon-arrow-right"></i>
    </li>
    <li class="nav-item">
      <a href="#">회원관리</a>
    </li>
    <li class="separator">
      <i class="icon-arrow-right"></i>
    </li>
    <li class="nav-item">
      <a href="#">회원리스트</a>
    </li>
  </ul>
</div>
<div class="row">
  <div class="col-md-12">
    <div class="card">
      <form>
        <div class="card-header">
          <div class="card-title">회원 검색 필터</div>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 col-lg-4">
              <label class="mb-3"><b>회원유형/상태별 구분</b></label>
              <div class="form-group form-group-default">
                <label class="form-label">회원유형</label>
                <div class="selectgroup w-100">
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="roleType"
                            value="COMPANY"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">거래처</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="roleType"
                            value="MANAGER"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">창고관리자</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="roleType"
                            value="ADMIN"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">총관리자</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="roleType"
                            value="DELIVERYMAN"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">배송기사</span>
                  </label>
                </div>
              </div>
              <div class="form-group form-group-default">
                <label class="form-label">회원상태</label>
                <div class="selectgroup w-100">
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="statusType"
                            value="WAITING_APPROVAL"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">승인대기</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="statusType"
                            value="APPROVAL"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">승인완료</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="statusType"
                            value="WAITING_DEACTIVATE"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">휴면대기</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="statusType"
                            value="DEACTIVATED"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">휴면상태</span>
                  </label>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-lg-4">
              <label class="mb-3"><b>키워드 검색</b></label>
              <div class="form-group form-group-default">
                <div>
                  <label class="form-label">키워드 검색 옵션</label>
                </div>
                <div class="selectgroup selectgroup-pills">
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="type"
                            value="id"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">아이디</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="type"
                            value="name"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">이름</span>
                  </label>
                </div>
              </div>
              <div class="form-group form-group-default">
                <label>이름/아이디 검색</label>
                <input
                        type="text"
                        name="keyword"
                        class="form-control"
                        value=""
                        placeholder="검색할 키워드 입력"
                />
              </div>
            </div>
            <div class="col-md-6 col-lg-4">
              <label class="mb-3"><b>기간별 구분</b></label>
              <div class="form-group form-group-default">
                <div>
                  <label class="form-label">기간 설정 옵션</label>
                </div>
                <div class="selectgroup selectgroup-pills">
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="periodFilter"
                            value="regDate"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">가입일</span>
                  </label>
                  <label class="selectgroup-item">
                    <input
                            type="radio"
                            name="periodFilter"
                            value="lastLogin"
                            class="selectgroup-input"
                    />
                    <span class="selectgroup-button">마지막 로그인 날짜</span>
                  </label>
                </div>
              </div>
              <div class="form-group form-group-default">
                <label for="from">시작 날짜</label>
                <input
                        type="date"
                        class="form-control form-control"
                        name="from"
                        id="from"
                        placeholder="시작일"
                />
              </div>
              <div class="form-group form-group-default">
                <label for="to">마지막 날짜</label>
                <input
                        type="date"
                        class="form-control form-control"
                        name="to"
                        id="to"
                        placeholder="시작일"
                />
              </div>
            </div>
          </div>
        </div>
        <div class="card-action">
          <div class="d-flex align-items-center">
            <button type="submit" onclick="searchUsers()" class="btn btn-primary btn-round ms-auto">
              검색
            </button>
          </div>
        </div>
      </form>
    </div>
    <div class="card">
      <div class="card-header">
        <div class="d-flex align-items-center">
          <h4 class="card-title">회원리스트</h4>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="add-row" class="display table table-striped table-hover">
            <thead>
              <tr>
                <th>아이디</th>
                <th>회원유형</th>
                <th>이름</th>
                <th>회원상태</th>
                <th>회원등록일</th>
                <th>마지막 로그인</th>
                <th style="width: 10%">회원상태 변경</th>
              </tr>
            </thead>
            <tbody id="userSearchResult"></tbody>
          </table>
        </div>

        <div class="dataTables_paginate paging_simple_numbers" id="basic-datatables_paginate">
          <ul class="pagination pg-primary mb-0 justify-content-end" id="userPagination" tabindex="-1">

          </ul>
        </div>
      </div>

      <!-- Modal -->
      <div
              class="modal fade"
              id="infoModal"
              tabindex="-1"
              role="dialog"
              aria-hidden="true"
      >
        <div class="modal-dialog" role="document">
          <div class="modal-content">
              <div class="modal-header border-0">
                <h5 class="modal-title">
                  <span class="fw-mediumbold">회원정보</span>
                </h5>
                <button
                        type="button"
                        class="close"
                        data-dismiss="modal"
                        aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <p>회원정보</p>
                <form>
                  <div class="row" id="basicInfo">
                    <label>기본 인적사항</label>
                    <div class="col-sm-12">
                      <div class="form-group form-group-default">
                        <label>아이디</label>
                        <input
                                id="userId"
                                type="text"
                                class="form-control"
                                placeholder="fill name"
                                readonly
                        />
                      </div>
                    </div>
                    <div class="col-md-6 pe-0">
                      <div class="form-group form-group-default">
                        <label>회원유형</label>
                        <input
                                id="addPosition"
                                type="text"
                                class="form-control"
                                placeholder="fill position"
                                readonly
                        />
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group form-group-default">
                        <label>계정상태</label>
                        <select
                                class="form-select form-control"
                                id="userStatus"
                        >
                          <option>APPROVAL</option>
                          <option>WAITING_APPROVAL</option>
                          <option>DEACTIVATED</option>
                          <option>WAITING_DEACTIVATE</option>
                        </select>
                      </div>
                    </div>
                    <div class="col-sm-12">
                      <div class="form-group form-group-default">
                        <label>이메일</label>
                        <input
                                id="userEmail"
                                type="email"
                                class="form-control"
                                placeholder="fill name"
                                readonly
                        />
                      </div>
                    </div>
                    <div class="col-sm-12">
                      <div class="form-group form-group-default">
                        <label>연락처</label>
                        <input
                                id="userPhone"
                                type="text"
                                class="form-control"
                                placeholder="fill name"
                                readonly
                        />
                      </div>
                    </div>
                  </div>

                  <%-- 모달의 이 부분들은 회원권한에 따라 선택적으로 출력할 부분 --%>
                  <div class="row" class="companyInfo">
                    <label>
                      <c:choose>
                        <c:when test="${userRole == 'COMPANY'}">거래처 회원정보 조회</c:when>
                        <c:when test="${userRole == 'MANAGER' || userRole == 'ADMIN'}">관리자 회원정보 조회</c:when>
                        <c:when test="${userRole == 'DELIVERY'}">배송기사 회원정보 조회</c:when>
                        <c:otherwise>회원정보 조회</c:otherwise>
                      </c:choose>
                    </label>
                    <c:if test='${userRole == "COMPANY"}'>
                      <div class="col-md-12">
                        <div class="form-group form-group-default">
                          <label>업체명</label>
                          <input
                                  id="userCompanyName"
                                  type="text"
                                  class="form-control"
                                  placeholder="fill name"
                                  readonly
                          />
                        </div>
                      </div>
                    </c:if>
                    <div class="col-md-6 pe-0">
                      <div class="form-group form-group-default">
                        <label><c:out value='${userRole == "COMPANY" ? "대표자명" : "회원명"}'/></label>
                        <input
                                id="userName"
                                type="text"
                                class="form-control"
                                placeholder="fill position"
                                readonly
                        />
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group form-group-default">
                        <label><c:out value='${userRole == "COMPANY" || userRole == "DELIVERYMAN" ? "사업자등록번호" : "사번"}'/></label>
                        <input
                                id="userCode"
                                type="text"
                                class="form-control"
                                placeholder="fill name"
                                readonly
                        />
                      </div>
                    </div>
                    <c:if test='${userRole == "COMPANY"}'>
                      <div class="col-md-6 pe-0">
                        <div class="form-group form-group-default">
                          <label>도로명주소</label>
                          <input
                                  id="userRoadAddr"
                                  type="text"
                                  class="form-control"
                                  placeholder="fill name"
                                  readonly
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group form-group-default">
                          <label>상세주소</label>
                          <input
                                  id="userDetailAddr"
                                  type="text"
                                  class="form-control"
                                  placeholder="fill name"
                                  readonly
                          />
                        </div>
                      </div>
                    </c:if>
                    <c:if test='${userRole == "DELIVERYMAN"}'>
                      <div class="col-md-6 pe-0">
                        <div class="form-group form-group-default">
                          <label>차량번호</label>
                          <input
                                  id="delivVhcCode"
                                  type="text"
                                  class="form-control"
                                  placeholder="fill position"
                                  readonly
                          />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group form-group-default">
                          <label>차종모델</label>
                          <input
                                  id="delivVhcModel"
                                  type="text"
                                  class="form-control"
                                  placeholder="fill name"
                                  readonly
                          />
                        </div>
                      </div>
                    </c:if>
                    <c:if test='${userRole == "MANAGER" || userRole == "ADMIN"}'>
                      <div class="col-md-6">
                        <div class="form-group form-group-default">
                          <label>직급</label>
                          <input
                                  id="managerRole"
                                  type="${userRole == 'COMPANY' || userRole == 'DELIVERYMAN' ? 'hidden' : 'text'}"
                                  class="form-control"
                                  placeholder="fill name"
                                  readonly
                          />
                        </div>
                      </div>
                    </c:if>
                  </div>
              </div>
              <div class="modal-footer border-0">
                <button type="button" id="addRowButton" class="btn btn-primary">
                  수정
                </button>
                <button
                        type="button"
                        class="btn btn-danger"
                        data-dismiss="modal"
                >
                  닫기
                </button>
              </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  let criteria = {
    page: 1,
    amount: 10,
    roleType: '',
    statusType: '',
    type: '',
    periodFilter: '',
    keyword: '',
    from: '',
    to: ''
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadUserList();
  })

  function loadUserList() {
    axios.get('/members/list/api?${params.toString()}', {params: criteria})
            .then(function (response) {
              renderUserTable(response.data.dtoList);
              renderPage(response.data);
            })
            .catch(function (error) {
              console.error("회원 목록 로드 중 오류 발생:", error);
              const tbody = document.getElementById("userSearchResult");
              tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;">'
                      + '회원 목록 로드 중 오류 발생:' + error.message
                      + '</td></tr>';
            });
  }

  function getRoleName(userRole) {
    switch (userRole) {
      case 'COMPANY':
        return '거래처';
      case 'MANAGER':
        return '창고관리자'
      case 'ADMIN':
        return '총관리자'
      case 'DELIVERYMAN':
        return '배송기사'
    }
  }

  function getStatus(userStatus) {
    const userStatusInfo = {
      class: 'bg-warning text-dark',  // 회원상태의 초기값은 승인대기 -> 노란색
      text: '승인대기'
    }
    switch (userStatus) {
      case 'APPROVAL':
        userStatusInfo.class = 'bg-primary';
        userStatusInfo.text = '승인완료';
        break;
      case 'WAITING_DEACTIVATE':  // 휴면대기
        userStatusInfo.text = '휴면대기'
        break;
      case 'DEACTIVATED':         // 휴면상태
        userStatusInfo.class = 'bg-danger';
        userStatusInfo.text = '휴면상태';
        break;
    }
    return userStatusInfo;
  }

  function renderUserTable(userList) {
    const tbody = document.getElementById("userSearchResult");
    tbody.innerHTML = ''; // 기존 내용을 초기화

    if (!userList || userList.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;">조회된 회원이 없습니다.</td></tr>';
      return;
    }

    let html = ''; // HTML 문자열을 조립
    userList.forEach(user => {
      const userRole = getRoleName(user.userRole);
      const userStatusInfo = getStatus(user.userStatus);
      const joinDate = user.userJoinDate === null ? '-' : new Date(user.userJoinDate).toLocaleString("ko-KR");
      const lastLogin = user.userLastLogin === null ? '-' : new Date(user.userLastLogin).toLocaleString("ko-KR");

      html += '<tr>'
              + '<td>' + user.userId + '</td>'
              + '<td>' + userRole + '</td>'
              + '<td>' + user.userName + '</td>'
              + '<td><span class="badge ' + userStatusInfo.class + '">' + userStatusInfo.text + '</td>'
              + '<td>' + joinDate + '</td>'
              + '<td>' + lastLogin + '</td>'
              + '<td>' +
                  '<div class="form-button-action">' +
                    '<button id="editUserStatusBtn" class="btn btn-link btn-primary" data-bs-toggle="modal" data-bs-target="#infoModal">' +
                      '<i class="fa fa-edit"></i>' +
                    '</button>' +
                    '<button id="deactivateBtn" class="btn btn-link btn-danger">' +
                      '<i class="fas fa-lock"></i>' +
                    '</button>' +
                   '</div>' +
                  '</td>' +
                '</tr>'
    });
    tbody.innerHTML = html; // 조립된 HTML을 tbody에 한 번에 삽입
  }

  function changePage(page) {
    criteria.page = page;
    loadUserList();
  }

  function renderPage(userPage) {
    const pagination = document.getElementById('userPagination');
    pagination.innerHTML = '';

    if (userPage.prev) {
      pagination.innerHTML += '<li class="page-item"><a class="page-link" onclick="changePage(' + (userPage.startPage - 1) + ')">이전</a></li>';
    }
    for (let i = userPage.startPage; i <= userPage.endPage; i++) {
      const isActive = (i === userPage.cri.page) ? 'active' : '';
      pagination.innerHTML += '<li class="page-item ' + isActive + '"><a class="page-link" onclick="changePage("' + i + '")">' + i + '</a></li>';
    }
    if (userPage.next) {
      pagination.innerHTML += '<li class="page-item"><a class="page-link" onclick="changePage(' + (userPage.endPage + 1) + ')">다음</a></li>';
    }
  }

  function searchUsers() {
    // 1. (수정) null-safe하게 요소(element)를 먼저 찾음
    const roleEl = document.querySelector("input[name='roleType']:checked");
    const statusEl = document.querySelector("input[name='statusType']:checked");
    const typeEl = document.querySelector("input[name='type']:checked");
    const periodEl = document.querySelector("input[name='periodFilter']:checked");

    // 2. (수정) 검색 시 항상 1페이지로 리셋
    criteria.page = 1;

    // 3. (수정) 요소가 있으면 .value를, 없으면 빈 문자열(또는 null)을 할당
    criteria.roleType = roleEl ? roleEl.value : '';
    criteria.statusType = statusEl ? statusEl.value : '';
    criteria.type = typeEl ? typeEl.value : '';
    criteria.periodFilter = periodEl ? periodEl.value : '';

    // 4. 나머지 값 할당
    criteria.keyword = document.querySelector("input[name='keyword']").value;
    criteria.from = document.getElementById("from").value;
    criteria.to = document.getElementById("to").value;

    loadUserList(); // 수정된 criteria로 목록 로드
  }
</script>

<script>
  const modalElement = document.getElementById('infoModal');
  const modal = new bootstrap.Modal(modalElement);
  
  function resetInfoModal() {
    // 1. 모달 요소를 찾습니다.
    const modal = document.getElementById("infoModal");

    // 2. 모달 내부의 모든 <input> 필드를 찾습니다.
    //    (readonly 속성이 있어도 JavaScript로 value 변경은 가능합니다)
    const inputs = modal.querySelectorAll("input[type='text'], input[type='email']");

    // 3. 모든 <input>의 value를 빈 문자열('')로 설정합니다.
    inputs.forEach(input => {
      input.value = "";
    });

    // 4. 모달 내부의 모든 <select> 필드를 찾습니다.
    const selects = modal.querySelectorAll("select");

    // 5. 모든 <select>의 선택을 첫 번째 옵션(index 0)으로 되돌립니다.
    selects.forEach(select => {
      select.selectedIndex = 0;
    });
  }

  function deactivateUser(userId) {
    if (!confirm("현재 회원을 휴면회원으로 전환시키겠습니까?")) {
      return;
    }
    axios.put('/members/list/' + userId + ":deactivate")
            .then(response => {
              alert("현재 회원을 휴면회원으로 전환했습니다.");
              loadUserList();
            })
            .catch(error => {
              alert("휴면회원 전환 실패: " + error.message);
              console.error(error.message)
            });
  }
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
