<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<!-- 메인 컨텐츠 시작 -->
<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
  <div>
    <h3 class="fw-bold mb-3">입고 관리 목록</h3>
  </div>
  <!-- ... (버튼 등) ... -->
</div>

<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        <!-- 검색 폼 등 필터링 UI가 위치할 공간 -->
        <div class="d-flex align-items-center">
          <h4 class="card-title">입고 목록 필터</h4>
          <button class="btn btn-primary btn-round ms-auto" id="searchBtn">
            <i class="fa fa-search"></i>
            검색
          </button>
        </div>
        <div class="row mt-3">
          <div class="col-md-3">
            <div class="form-group">
              <label for="companyName">거래처명</label>
              <input type="text" class="form-control" id="companyName" placeholder="거래처명 입력">
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <label for="coffeeCategory">카테고리</label>
              <select class="form-select" id="coffeeCategory">
                <option value="">전체</option>
                <option value="원두">원두</option>
                <option value="생두">생두</option>
                <option value="DCF">디카페인</option>
              </select>
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <label for="inboundStatus">상태</label>
              <select class="form-select" id="inboundStatus">
                <option value="">전체</option>
                <option value="승인대기">승인대기</option>
                <option value="승인완료">승인완료</option>
                <option value="입고완료">입고완료</option>
                <option value="반려">반려</option>
              </select>
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <label for="sortBy">정렬 기준</label>
              <select class="form-select" id="sortBy">
                <option value="reqDate">요청일 (최신순)</option>
                <option value="companyName">거래처명 (가나다순)</option>
                <option value="quantity">요청수량 (많은순)</option>
              </select>
            </div>
          </div>
        </div>
        <%-- 검색 필터 마지막 --%>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped mt-3">
            <thead>
            <tr>
              <th>요청ID</th>
              <th>거래처</th>
              <th>품목</th>
              <th>카테고리</th>
              <th>요청수량</th>
              <th>입고수량</th>
              <th>상태</th>
              <th>요청일시</th>
              <th>승인일시</th>
              <th>임시저장</th>
            </tr>
            </thead>
            <tbody id="inbound-list-body">
            <%-- 이 공간은 JavaScript가 Axios로 데이터를 받아온 후 동적으로 채움. --%>

            </tbody>
          </table>
        </div>

        <!-- 페이지네이션 UI가 여기에 동적으로 채워집니다. -->
        <nav>
          <ul class="pagination justify-content-center" id="pagination-ul">
          </ul>
        </nav>
      </div>
    </div>
  </div>
</div>
<!-- 메인 컨텐츠 종료 -->


<script>
    // 현재 검색 조건을 전역적으로 관리할 객체
    let currentCriteria = {
        page: 1,
        size: 10,
        sortBy: 'reqDate',
        sortOrder: 'DESC',
        companyName: '',
        coffeeCategory: '',
        inboundStatus: ''
    };

    // 페이지 로드 시 또는 특정 이벤트 발생 시 데이터를 가져와서 화면을 그리는 함수
    function loadInboundList(page) { // page 파라미터를 받도록 명시
        console.log("Loading list with criteria:", currentCriteria);
        console.log("loadInboundList called with page:", page);

        // 만약 page가 undefined, null, 0 등 유효하지 않은 값이라면 기본값 1로 설정
        const pageToLoad = page || 1;
        const baseUrl = '/inbounds/api';

        axios.get(baseUrl, {params: currentCriteria})
            .then(function (response) {
                renderTable(response.data.list);
                renderPagination(response.data.pageMaker);
                initializeTooltips(); // 툴팁 활성화
            })
            .catch(function (error) {
                console.error('데이터를 불러오는 중 오류 발: ', error);
            });
    };

    // 테이블 렌더링 함수
    function renderTable(list) {
        const tbody = document.getElementById('inbound-list-body');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            // 컬럼 개수를 지정해 데이터 없음 표시
            tbody.innerHTML = '<tr><td colspan="10" class="text-center">조회된 데이터가 없습니다.</td></tr>';
            return; // 데이터가 없으면 아래 페이지네이션 로직을 실행할 필요 없음
        }
        list.forEach(item => {
            try {
                // 서버에서 '2025-11-09T15:40:39' 와 같은 표준 문자열
                const formattedReqDttm = item.inDttmReq ? new Date(item.inDttmReq).toLocaleString('ko-KR') : '-';
                const formattedApprDttm = item.inDttmAppr ? new Date(item.inDttmAppr).toLocaleString('ko-KR') : '-';
                const actualQty = item.inQty !== null ? item.inQty : '0';

                // 임시저장 여부 표시
                let isTempoIcon = ''; // 기본값은 빈 문자열
                if (item.isTempo) {
                    // Bootstrap Icons의 'save' 아이콘과 tooltip 속성 추가
                    isTempoIcon = '<i class="fas fa-save text-primary" data-bs-toggle="tooltip" title="임시저장된 항목입니다."></i>';
                }


                // --- ★★★ [핵심 수정] 상태에 따라 클래스와 텍스트를 결정하는 로직 ★★★ ---
                let statusBadgeClass = 'bg-secondary'; // 기본값 (회색)
                let statusText = item.statusValue || item.status;

                switch (item.status) { // item.status는 'PENDING', 'APPROVED' 등의 영문 코드
                    case 'PENDING':
                        statusBadgeClass = 'bg-warning text-dark'; // 승인대기: 노란색
                        break;
                    case 'APPROVED':
                        statusBadgeClass = 'bg-primary'; // 승인완료: 파란색
                        break;
                    case 'RECEIVED':
                        statusBadgeClass = 'bg-success'; // 입고완료: 녹색
                        break;
                    case 'REJECTED':
                        statusBadgeClass = 'bg-danger'; // 반려: 빨간색
                        break;
                }

                // 아래 코드는 브라우저에 표시 안됨
                <%--              const row = `--%>
                <%--    <tr onclick="location.href='/inbounds/${item.inReqItemsId}'" style="cursor: pointer;">--%>
                <%--        <td>${item.inReqId}</td>--%>
                <%--        <td>${item.inReqItemsId}</td>--%>
                <%--        <td>${item.companyName}</td>--%>
                <%--        <td>${item.coffeeName}</td>--%>
                <%--        <td>${item.coffeeCategory}</td>--%>
                <%--        <td>${item.inQtyReq}</td>--%>
                <%--        <td>${actualQty}</td>--%>
                <%--        <td><span class="badge bg-primary">${statusValue}</span></td>--%>
                <%--        <td>${formattedReqDttm}</td>--%>
                <%--        <td>${formattedApprDttm}</td>--%>
                <%--    </tr>--%>
                <%--`;--%>
                const row =
                    '<tr onclick="location.href=\'/inbounds/' + item.inReqId + '\'" style="cursor: pointer;">' +
                    '<td>' + item.inReqId + '</td>' +
                    '<td>' + item.companyName + '</td>' +
                    '<td>' + item.coffeeName + '</td>' +
                    '<td>' + item.coffeeCategory + '</td>' +
                    '<td>' + item.inQtyReq + '</td>' +
                    '<td>' + actualQty + '</td>' +
                    '<td><span class="badge ' + statusBadgeClass + '">' + statusText + '</span></td>' +
                    '<td>' + formattedReqDttm + '</td>' +
                    '<td>' + formattedApprDttm + '</td>' +
                    '<td>' + isTempoIcon + '</td>' +
                    '</tr>';

                tbody.insertAdjacentHTML('beforeend', row);
            } catch (e) {
                // 만약 row를 만드는 과정에서 에러가 발생하면 여기서 잡힙니다.
                console.error("Error processing item:", item, e);
            }

        });
    }

    // 테이블 렌더링이 끝난 후 툴팁을 활성화하는 코드가 필요합니다.
    function initializeTooltips() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }

    function renderPagination(pageMaker) {
        const paginationUl = document.getElementById('pagination-ul');
        paginationUl.innerHTML = '';

        // 이전 버튼
        if (pageMaker.prev) {
            paginationUl.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:void(0);" onclick="goToPage(' + (pageMaker.startPage - 1) + ')">이전</a></li>';
        }
        for (let i = pageMaker.startPage; i <= pageMaker.endPage; i++) {
            const activeClass = (i === pageMaker.criteria.page) ? 'active' : '';
            paginationUl.innerHTML += '<li class="page-item ' + activeClass + '"><a class="page-link" href="javascript:void(0);" onclick="goToPage(' + i + ')">' + i + '</a></li>';
        }
        if (pageMaker.next) {
            paginationUl.innerHTML += '<li class="page-item"><a class="page-link" href="javascript:void(0);" onclick="goToPage(' + (pageMaker.endPage + 1) + ')">다음</a></li>';
        }
    }

    // 페이지 이동 함수
    function goToPage(page) {
        currentCriteria.page = page;
        loadInboundList();
    }

    // ★★★ 검색 조건 업데이트 및 API 호출 함수 ★★★
    function search() {
        // 현재 UI의 값들을 읽어서 currentCriteria 객체를 업데이트
        currentCriteria.page = 1; // 검색 시에는 항상 첫 페이지부터 조회
        currentCriteria.companyName = document.getElementById('companyName').value;
        currentCriteria.coffeeCategory = document.getElementById('coffeeCategory').value;
        currentCriteria.inboundStatus = document.getElementById('inboundStatus').value;

        // 정렬 기준 처리
        const sortByValue = document.getElementById('sortBy').value;
        currentCriteria.sortBy = sortByValue;
        if (sortByValue === 'quantity') {
            currentCriteria.sortOrder = 'DESC';
        } else if (sortByValue === 'companyName') {
            currentCriteria.sortOrder = 'ASC';
        } else {
            currentCriteria.sortOrder = 'DESC';
        }

        // 업데이트된 criteria로 데이터 로드
        loadInboundList();
    }

    // 문서가 처음 로드될 때 실행
    document.addEventListener('DOMContentLoaded', function () {
        // --- 이벤트 리스너 등록 ---
        // 1. '검색' 버튼 클릭 이벤트
        document.getElementById('searchBtn').addEventListener('click', search);

        // 2. 각 필터 변경 시 자동 검색 이벤트
        document.getElementById('companyName').addEventListener('keyup', function (event) {
            // Enter 키를 눌렀을 때만 검색 실행
            if (event.key === 'Enter') {
                search();
            }
        });


        document.getElementById('coffeeCategory').addEventListener('change', search);
        document.getElementById('inboundStatus').addEventListener('change', search);
        document.getElementById('sortBy').addEventListener('change', search);

        // 3. 페이지 최초 로드
        loadInboundList();
    });
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
