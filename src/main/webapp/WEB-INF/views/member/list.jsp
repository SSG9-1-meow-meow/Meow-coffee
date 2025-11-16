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
                            value="ALL"
                            class="selectgroup-input"
                            checked
                    />
                    <span class="selectgroup-button">전체</span>
                  </label>
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
                            value="ALL"
                            class="selectgroup-input"
                            checked
                    />
                    <span class="selectgroup-button">전체</span>
                  </label>
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
            <button type="button" onclick="searchUsers()" class="btn btn-primary btn-round ms-auto">
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
                  <span class="fw-mediumbold" id="modalTitle">회원정보</span>
                </h5>
                <button
                        type="button"
                        class="close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <p>회원정보</p>
                <form>
                  <div class="row" id="basicInfoContainer">
                    <label>기본 인적사항</label>
                    <div class="col-sm-12">
                      <div class="form-group form-group-default">
                        <label>아이디</label>
                        <input
                                id="userId"
                                type="text"
                                class="form-control"
                                readonly
                        />
                      </div>
                    </div>
                    <div class="col-md-6 pe-0">
                      <div class="form-group form-group-default">
                        <label>회원유형</label>
                        <input
                                id="userRoleType"
                                type="text"
                                class="form-control"
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
                                readonly
                        />
                      </div>
                    </div>
                  </div>

                  <%-- 모달의 이 부분들은 회원권한에 따라 선택적으로 출력할 부분 --%>
                  <div class="row" id="roleSpecificContainer">
                  </div>
              </div>
              <div class="modal-footer border-0">
                <button type="button" id="editButton" class="btn btn-primary">
                  수정
                </button>
                <button type="button" id="closeBtn" class="btn btn-danger" data-bs-dismiss="modal">
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
    pageNum: 1,
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
    loadInfoModal();

    // [신규 추가] 모달의 "수정" 버튼(id="editButton")에 클릭 이벤트 리스너 추가
    const editButton = document.getElementById('editButton');
    editButton.addEventListener('click', () => {
      const userId = editButton.dataset.userId;

      if (!userId) {
        alert("수정할 사용자 ID를 찾을 수 없습니다.");
        return;
      }
      updateUserStatus(userId);
    });
  })

  function loadUserList() {

    axios.get('/members/list/api', {params: criteria})
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
      const joinDate = user.userJoinDate === null ? '-' : new Date(user.userJoinDate).toLocaleDateString("ko-KR");
      const lastLogin = user.userLastLogin === null ? '-' : new Date(user.userLastLogin).toLocaleDateString("ko-KR");

      html += '<tr>'
              + '<td>' + user.userId + '</td>'
              + '<td>' + userRole + '</td>'
              + '<td>' + user.userName + '</td>'
              + '<td><span class="badge ' + userStatusInfo.class + '">' + userStatusInfo.text + '</td>'
              + '<td>' + joinDate + '</td>'
              + '<td>' + lastLogin + '</td>'
              + '<td>' +
                  '<div class="form-button-action">' +
                    '<button type="button" class="btn btn-link btn-primary view-user-btn" data-user-id="' + user.userId + '">' +
                      '<i class="fa fa-edit"></i>' +
                    '</button>' +
                    '<button type="button" class="btn btn-link btn-danger deactivate-btn" data-user-id="' + user.userId + '">' +
                      '<i class="fas fa-lock"></i>' +
                    '</button>' +
                  '</div>' +
                '</td>' +
              '</tr>'
    });
    tbody.innerHTML = html; // 조립된 HTML을 tbody에 한 번에 삽입
  }

  function changePage(pageNum) {
    criteria.pageNum = pageNum;
    loadUserList();
  }

  function renderPage(userPage) {
    const pagination = document.getElementById('userPagination');
    pagination.innerHTML = ''; // 기존 페이지 버튼 비우기

    /**
     * 페이지 링크(li, a)를 생성하고 클릭 이벤트를 바인딩하는 헬퍼 함수
     */
    const createPageLink = (page, text, isActive = false) => {
      // 1. <li> 태그 생성
      const li = document.createElement('li');
      li.className = 'page-item';
      if (isActive) {
        li.classList.add('active'); // 활성화된 페이지는 active 클래스 추가
      }

      // 2. <a> 태그 생성
      const a = document.createElement('a');
      a.className = 'page-link';
      a.href = 'javascript:void(0);'; // href 속성 추가
      a.textContent = text; // 페이지 번호 또는 '이전'/'다음' 텍스트

      // 3. (!!!핵심!!!) <a> 태그에 'click' 이벤트 리스너 직접 추가
      a.addEventListener('click', () => {
        changePage(page); // changePage 함수 호출
      });

      // 4. <li>에 <a>를 자식으로 추가
      li.appendChild(a);

      // 5. 완성된 <li> 반환
      return li;
    };

    // "이전" 버튼 생성
    if (userPage.prev) {
      pagination.appendChild(
              createPageLink(userPage.startPage - 1, '이전')
      );
    }

    // 페이지 번호 버튼 생성
    for (let i = userPage.startPage; i <= userPage.endPage; i++) {
      const isActive = (i === criteria.pageNum); // criteria.page와 비교
      pagination.appendChild(
              createPageLink(i, i, isActive) // (i, i) -> (페이지번호, 텍스트)
      );
    }

    // "다음" 버튼 생성
    if (userPage.next) {
      pagination.appendChild(
              createPageLink(userPage.endPage + 1, '다음')
      );
    }
  }

  function searchUsers() {
    // 1. (수정) null-safe하게 요소(element)를 먼저 찾음
    const roleEl = document.querySelector("input[name='roleType']:checked");
    const statusEl = document.querySelector("input[name='statusType']:checked");
    const typeEl = document.querySelector("input[name='type']:checked");
    const periodEl = document.querySelector("input[name='periodFilter']:checked");

    // 2. (수정) 검색 시 항상 1페이지로 리셋
    criteria.pageNum = 1;

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

  function loadInfoModal() {
    // 1. Bootstrap 모달 인스턴스 생성
    const infoModalElement = document.getElementById('infoModal');
    const infoModal = new bootstrap.Modal(infoModalElement);

    // 2. 이벤트 위임 (Event Delegation)
    const userListBody = document.getElementById('userSearchResult');

    // 컨테이너에 클릭 이벤트를 추가합니다.
    userListBody.addEventListener('click', (event) => {
      // 가장 가까운 상위 요소 중 .view-user-btn을 찾습니다.
      const viewButton = event.target.closest('.view-user-btn');
      const deactivateButton = event.target.closest('.deactivate-btn');

      if (viewButton) {
        // 3. 데이터 가져오기 (Axios)
        // 버튼의 data-user-id 속성에서 ID를 가져옵니다.
        const userId = viewButton.dataset.userId;
        if (!userId) {
          console.error("해당하는 사용자가 없습니다.")
          return;
        }

        // Axios로 서버에 데이터를 요청합니다.
        axios.get('/members/list/' + userId)
                .then(response => {
                  const user = response.data; // 회원 정보 JSON

                  // 4. 모달 내용 채우기 (헬퍼 함수 호출)
                  populateBasicInfo(user);
                  populateRoleSpecificInfo(user);

                  // 5. (참고) 수정 버튼에 PK 할당
                  document.getElementById('editButton').dataset.userId = user.userId;

                  // 6. Bootstrap 모달 띄우기 (인스턴스 사용)
                  infoModal.show();
                })
                .catch(error => {
                  console.error('회원 정보 조회 실패:', error);
                  alert('정보를 불러오는 데 실패했습니다.');
                });
      }
      if (deactivateButton) {
        const userId = deactivateButton.dataset.userId;
        deactivateUser(userId);
      }
    });
  }

  /** * [헬퍼 함수 1] 공통 정보를 모달에 채웁니다. (Vanilla JS)
   */
  function populateBasicInfo(user) {
    document.getElementById('userId').value = user.userId;
    document.getElementById('userRoleType').value = getRoleName(user.userRole);
    document.getElementById('userStatus').value = user.userStatus;
    document.getElementById('userEmail').value = user.userEmail;
    document.getElementById('userPhone').value = user.userPhone;
  }

  /** * [헬퍼 함수 2] 권한별 정보를 모달에 동적으로 생성합니다. (Vanilla JS)
   */
  function populateRoleSpecificInfo(user) {
    const container = document.getElementById('roleSpecificContainer');
    // (중요) 이전에 열었던 내용을 모두 비웁니다.
    container.innerHTML = '';

    let html = ''; // HTML 문자열을 조립
    let title = '회원정보 조회';

    // 홑따옴표(')와 문자열 연결(+)을 사용하는 방식
    switch (user.userRole) {
      case 'COMPANY':
        const joinDate = new Date(user.userJoinDate);
        const expireDate = new Date(user.userJoinDate);
        expireDate.setFullYear(expireDate.getFullYear()+1);

        title = '거래처 회원정보 조회';
        html =
                '<div class="col-md-12">' +
                '<div class="form-group form-group-default">' +
                '<label>업체명</label>' +
                '<input type="text" class="form-control" value="' + user.userCompanyName + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>대표자명</label>' +
                '<input type="text" class="form-control" value="' + user.userName + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>사업자등록번호</label>' +
                '<input type="text" class="form-control" value="' + user.userCode + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>도로명주소</label>' +
                '<input type="text" class="form-control" value="' + user.userRoadAddr + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>상세주소</label>' +
                '<input type="text" class="form-control" value="' + user.userDetailAddr + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>계약체결일</label>' +
                '<input type="text" class="form-control" value="' + joinDate.toLocaleDateString("ko-KR") + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>계약만료일</label>' +
                '<input type="text" class="form-control" value="' + expireDate.toLocaleDateString("ko-KR") + '" readonly />' +
                '</div>' +
                '</div>';
        break;

      case 'MANAGER':
      case 'ADMIN':
        title = '관리자 회원정보 조회';
        html =
                '<div class="col-md-6 pe-0">' +
                '<div class="form-group form-group-default">' +
                '<label>회원명</label>' +
                '<input type="text" class="form-control" value="' + user.userName + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>사번</label>' +
                '<input type="text" class="form-control" value="' + user.userCode + '" readonly />' +
                '</div>' +
                '</div>';
        break;

      case 'DELIVERYMAN':
        title = '배송기사 회원정보 조회';
        html =
                '<div class="col-md-6 pe-0">' +
                '<div class="form-group form-group-default">' +
                '<label>회원명</label>' +
                '<input type="text" class="form-control" value="' + user.userName + '" readonly />' +
                '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="form-group form-group-default">' +
                '<label>사업자등록번호</label>' +
                '<input type="text" class="form-control" value="' + user.userCode + '" readonly />' +
                '</div>' +
                '</div>';
        break;
    }

    // 모달 제목 변경
    document.getElementById('modalTitle').textContent = title;

    // 권한별 정보 타이틀(Label)을 먼저 삽입
    const titleLabel = document.createElement('label');
    titleLabel.textContent = title;
    container.appendChild(titleLabel);

    // 생성된 HTML 문자열을 DOM에 삽입
    container.insertAdjacentHTML('beforeend', html);
  }

  function updateUserStatus(userId) {
    if (!confirm("현재 회원의 상태를 변경하시겠습니까?")) {
      return;
    }

    const newStatus = document.getElementById("userStatus").value;
    const payload = {
      userStatus: newStatus
    }

    axios.put('/members/list/' + userId, payload)
            .then(response => {
              alert("현재 회원의 상태를 변경합니다.");
              loadUserList();

              // 상태 변경 성공 시 모달창 닫기
              const infoModalElement = document.getElementById('infoModal');
              const infoModal = bootstrap.Modal.getInstance(infoModalElement);
              if (infoModal) {
                infoModal.hide();
              }
            })
            .catch(error => {
              alert("회원상태 변경 실패: " + error.message);
              console.error(error.message);
            });
  }

  function deactivateUser(userId) {
    if (!confirm("현재 회원을 휴면회원으로 전환시키겠습니까?")) {
      return;
    }
    axios.put('/members/list/' + userId + ":deactivate")
            .then(response => {
              alert("현재 회원을 휴면회원으로 전환합니다.");
              loadUserList();
            })
            .catch(error => {
              alert("휴면회원 전환 실패: " + error.message);
              console.error(error.message)
            });
  }
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
