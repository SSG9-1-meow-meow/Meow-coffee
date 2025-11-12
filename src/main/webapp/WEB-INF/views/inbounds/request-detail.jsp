<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<div class="page-inner">
  <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div>
      <h3 class="fw-bold mb-3">입고 요청 상세</h3>
      <%-- 서버로부터 받은 inReqId를 사용 --%>
      <h6 class="op-7 mb-2">요청 번호: ${inReqId}</h6>
    </div>
  </div>

  <div class="row">
    <!-- 왼쪽: 커피 목록 (수정 모드에서만 보임) -->
    <div class="col-md-5" id="coffee-list-panel" style="display: none;">
      <div class="card">
        <div class="card-header"><h4 class="card-title">전체 품목</h4></div>
        <div class="card-body" style="height: 600px; overflow-y: auto;" id="coffee-list-container">
          <!-- JS로 채워짐 -->
        </div>
      </div>
    </div>

    <!-- 오른쪽: 입고 요청 양식 -->
    <div class="col-md-12" id="request-panel">
      <div class="card">
        <div class="card-header"><h4 class="card-title">요청 품목</h4></div>
        <div class="card-body">
          <div id="request-items-container">
            <!-- JS로 채워짐. 로딩 스피너 등을 여기에 표시할 수 있음 -->
            <p class="text-center">데이터를 불러오는 중...</p>
          </div>
          <div class="d-grid gap-2 mt-3 d-none" id="add-item-wrapper">
            <button class="btn btn-outline-primary" type="button" id="addItemBtn">
              <i class="fa fa-plus"></i> 품목 추가하기
            </button>
          </div>
          <hr>
          <div class="form-group">
            <label for="inDateWish">희망 입고 날짜</label>
            <input type="date" class="form-control" id="inDateWish" readonly>
            <small id="date-info-text" class="form-text text-primary"></small>
          </div>
        </div>
        <div class="card-footer text-end" id="button-group">
          <!-- JS로 채워짐 -->
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 품목 박스 템플릿 -->
<template id="request-item-template">...</template>

<script>
    // 전역 변수 선언
    let coffeeList = [];
    let requestItems = [];
    let isEditMode = false;
    const inReqId = "${inReqId}";
    // ★★★ [추가] 컨트롤러가 전달한 사용자 권한 정보를 JS 변수로 받음 ★★★
    const currentUserRole = "${currentUserRole}";

    /**
     * 오늘로부터 특정 일수(days) 후의 날짜를 'YYYY-MM-DD' 형식의 문자열로 반환합니다.
     * @param {number} days - 오늘로부터 더할 일수
     * @returns {string} 'YYYY-MM-DD' 형식의 날짜 문자열
     */
    function getDateStringAfterDays(days) {
        const today = new Date();
        const futureDate = new Date(today.setDate(today.getDate() + days));
        return futureDate.toISOString().split('T')[0];
    }

    // --- UI 렌더링 함수들 ---
    function renderRequestItems() {
        const container = document.getElementById('request-items-container');
        container.innerHTML = '';

        // ★★★ requestDetail.items.forEach -> requestItems.forEach 로 변경 ★★★
        requestItems.forEach(item => {
            container.innerHTML += createItemBoxHtml(item);
        });
        updateUI();
    }

    // createItemBoxHtml 함수 수정 (coffeeName 직접 사용)
    function createItemBoxHtml(item = null) {
        let selectedCfId = item ? item.cfId : '';
        let selectedQty = item ? item.inQtyReq : 1;
        let coffeeName = item ? item.cfName : '품목을 선택하세요';

        if (isEditMode) {
            // 수정 모드
            let options = '<option disabled value="">-- 커피 선택 --</option>';
            coffeeList.forEach(coffee => {
                // 'selected' 속성을 조건부로 추가
                const selectedAttr = (coffee.cfId === selectedCfId) ? 'selected' : '';
                options += '<option value="' + coffee.cfId + '" ' + selectedAttr + '>' + coffee.cfName + '</option>';
            });

            let qtyOptions = '';
            for (let i = 1; i <= 10; i++) {
                const selectedAttr = (i === selectedQty) ? 'selected' : '';
                qtyOptions += '<option value="' + i + '" ' + selectedAttr + '>' + i + '</option>';
            }
            return '<div class="request-item-box border p-3 mb-3 rounded position-relative">' +
                '<button type="button" class="btn btn-link text-danger delete-item-btn position-absolute top-0 end-0 m-2"><i class="fa fa-trash-alt"></i></button>' +
                '<div class="row">' +
                '<div class="col-8"><select class="form-select coffee-select">' + options + '</select></div>' +
                '<div class="col-4"><select class="form-select quantity-select">' + qtyOptions + '</select></div>' +
                '</div>' +
                '</div>';
        } else {
            // 읽기 모드 로직
            // '처리하기' 버튼을 조건부로 생성
            let processButtonHtml = '';
            if (currentUserRole === 'MANAGER' && item.status === 'PENDING') {
                processButtonHtml =
                    '<a href="/inbounds/items/' + item.inReqItemsId + '" class="btn btn-sm btn-outline-primary ms-3">' +
                    '처리하기 <i class="fas fa-arrow-right"></i>' +
                    '</a>';
            }

            // 상태 배지 클래스 결정
            let statusBadgeClass = 'bg-secondary';
            if (item.status === 'PENDING') statusBadgeClass = 'bg-warning text-dark';
            if (item.status === 'APPROVED') statusBadgeClass = 'bg-primary';
            if (item.status === 'RECEIVED') statusBadgeClass = 'bg-success';
            if (item.status === 'REJECTED') statusBadgeClass = 'bg-danger';

            return (
                '<div class="request-item-box border p-3 mb-3 rounded">' +
                '<div class="d-flex w-100 justify-content-between align-items-center">' +
                '<div>' +
                '<strong>' + coffeeName + '</strong> (' + item.cfId + ')&nbsp;' +
                '<small class="text-muted">카테고리: ' + item.cfCategory + ' / 등급 : ' + item.cfGrade + '</small><br>' +
                '<p class="mb-0 mt-1">신청 수량: <strong>' + selectedQty + '</strong> PLT</p>' +
                '</div>' +
                // 상태 배지와 처리하기 버튼을 함께 묶음
                '<div class="d-flex align-items-center">' +
                '<span class="badge ' + statusBadgeClass + ' fs-6">' + item.statusValue + '</span>' +
                processButtonHtml + // 조건에 따라 버튼 HTML이 여기에 추가됨
                '</div>' +
                '</div>' +
                '</div>'
            );


        }
    }

    // ... (updateUI, renderButtons 등 다른 UI 함수는 대부분 동일)
    function updateUI() {
        // UI 요소 업데이트 로직... (버튼, readonly 속성, 패널 표시/숨김 등)
        const requestPanel = document.getElementById('request-panel');
        const coffeeListPanel = document.getElementById('coffee-list-panel');
        const addItemWrapper = document.getElementById('add-item-wrapper');
        const inDateWishInput = document.getElementById('inDateWish');



        if (isEditMode) {
            // 수정폼으로 전환되면 사용
            const dateInfoText = document.getElementById('date-info-text'); // 안내 문구 요소

            // 현재의 14일 후 날짜 계산
            const twoWeeksLater = new Date(getDateStringAfterDays(14));

            // 안내 문구를 한국어 형식으로 포맷팅하여 표시
            const options = { year: 'numeric', month: 'long', day: 'numeric' };
            dateInfoText.textContent = '희망 입고 날짜는 ' + twoWeeksLater.toLocaleDateString('ko-KR', options) + ' 부터 가능합니다.';

            requestPanel.className = 'col-md-7';
            coffeeListPanel.style.display = 'block';
            // [수정] 'd-none' 클래스를 제거하여 요소를 보이게 함
            addItemWrapper.classList.remove('d-none');
            inDateWishInput.readOnly = false;
            renderButtonsForEdit();
        } else {
            requestPanel.className = 'col-md-12';
            coffeeListPanel.style.display = 'none';
            addItemWrapper.classList.add('d-none');
            inDateWishInput.readOnly = true;
            renderButtonsForRead();
        }
    }

    function renderButtonsForRead() {
        document.getElementById('button-group').innerHTML = `
            <button class="btn btn-primary" id="editBtn">발주 수정</button>
            <button class="btn btn-danger" id="cancelBtn">요청 취소</button>
        `;
        document.getElementById('editBtn').addEventListener('click', toggleEditMode);
        document.getElementById('cancelBtn').addEventListener('click', cancelRequest);
    }

    function renderButtonsForEdit() {
        document.getElementById('button-group').innerHTML = `
            <button class="btn btn-secondary" id="cancelEditBtn">수정 취소</button>
            <button class="btn btn-info" id="saveDraftBtn">임시 저장</button>
            <button class="btn btn-success" id="submitUpdateBtn">수정 완료</button>
        `;
        document.getElementById('cancelEditBtn').addEventListener('click', toggleEditMode);
        document.getElementById('saveDraftBtn').addEventListener('click', () => submitUpdateRequest(1));
        document.getElementById('submitUpdateBtn').addEventListener('click', () => submitUpdateRequest(0));
    }

    function toggleEditMode() {
        isEditMode = !isEditMode;
        renderRequestItems(); // UI 다시 그리기
    }

    // --- 이벤트 핸들러 함수들 ---
    function cancelRequest() {
        if (!confirm('정말로 이 요청을 취소하시겠습니까?')) return;
        axios.delete(`/inbounds/${inReqId}`) // DELETE 요청
            .then(res => {
                alert('요청이 취소되었습니다.');
                window.location.href = '/inbounds';
            }).catch(err => alert('취소 처리 중 오류가 발생했습니다.'));
    }

    // 수정 요청 제출 함수 (isTempo: 0=발주신청, 1=임시저장)
    function submitUpdateRequest(isTempo) {
        const items = [];
        document.querySelectorAll('.request-item-box').forEach(box => {
            const cfId = box.querySelector('.coffee-select').value;
            const inQtyReq = box.querySelector('.quantity-select').value;
            if (cfId) { // 커피가 선택된 항목만 추가
                items.push({ cfId: cfId, inQtyReq: parseInt(inQtyReq) });
            }
        });

        if (items.length === 0) {
            alert('하나 이상의 품목을 선택해주세요.');
            return;
        }

        const inDateWish = document.getElementById('inDateWish').value;
        if (!inDateWish) {
            alert('희망 입고 날짜를 선택해주세요.');
            return;
        }

        const today = new Date();
        // 현재의 14일 후 날짜 계산
        const twoWeeksLater = new Date(today.setDate(today.getDate() + 14));
        const defaultValue = twoWeeksLater.toISOString().split('T')[0];

        // 선택된 날짜가 최소 날짜보다 이전인지 확인
        if (new Date(inDateWish) < new Date(defaultValue)) {
            alert('희망 입고 날짜는 오늘로부터 최소 2주 후여야 합니다.');
            inDateWish.focus();
            return;
        }

        // 서버로 보낼 데이터 객체
        const requestData = {
            _comId: 'coffeebiz01', // TODO: 실제 로그인한 사용자 ID로 변경해야 함
            _inDateWish: inDateWish,
            _inItemsJson: JSON.stringify(items), // items or JSON.stringify(items) <= 문자열 안에 또 json이 있는 형태임.
            _isTempo: isTempo
        };

        console.log("서버로 전송할 데이터:", JSON.stringify(requestData, null, 2)); // 전송 직전 데이터 확인

        // Axios로 PUT 요청
        axios.put(`/inbounds/${inReqId}`, requestData)
            .then(function(response) {
                alert('요청이 성공적으로 처리되었습니다.');
                window.location.href = '/inbounds'; // 목록 페이지로 이동
            })
            .catch(function(error) {
                console.error('요청 처리 중 오류 발생:', error);
                alert('요청 처리 중 오류가 발생했습니다. 다시 시도해주세요.');
            });
    }


    // --- 데이터 로딩 및 초기화 ---
    document.addEventListener('DOMContentLoaded', function () {
        axios.get(`/inbounds/api/${inReqId}`)
            .then(function (response) {
                const data = response.data;

                // 전역 변수에 데이터 할당
                coffeeList = data.coffeeList;
                requestItems = data.requestItems; // requestItems 리스트를 받음 => 데이터 확인

                // 데이터 로딩 후 UI 초기화
                initializePage();
            })
            .catch(function (error) { /* ... */
            });
    });

    // 데이터 로딩이 완료된 후 페이지를 초기화하는 함수
    function initializePage() {

        const inDateWishInput = document.getElementById('inDateWish');
        const dateInfoText = document.getElementById('date-info-text');

        // ★★★ 헬퍼 함수를 사용하여 최소 선택 가능 날짜 계산 ★★★
        const minSelectableDate = getDateStringAfterDays(14);

        // input 요소에 최소 선택 날짜 설정
        inDateWishInput.min = minSelectableDate;
        //  리스트의 첫 번째 항목에서 공통 정보를 가져와서 사용
        if (requestItems && requestItems.length > 0 && requestItems[0].inDateWish) {
            inDateWishInput.value = requestItems[0].inDateWish;
        } else {
            inDateWishInput.value = minSelectableDate;
        }

        // 왼쪽 커피 목록 렌더링 (이전과 동일)
        const coffeeListContainer = document.getElementById('coffee-list-container');
        let coffeeListHtml = '<ul class="list-group list-group-flush">';
        coffeeList.forEach(c => {
            coffeeListHtml +=
                '<li class="list-group-item">' +
                '<strong>' + c.cfName + '</strong> (' + c.cfId + ')<br>' +
                '<small class="text-muted">' + c.cfCategory + ' | ' + c.cfGrade + '</small>' +
                '</li>';
        });
        coffeeListHtml += '</ul>';
        coffeeListContainer.innerHTML = coffeeListHtml;

        // 초기 UI 상태(읽기 모드) 렌더링
        renderRequestItems();

        // 이벤트 리스너 등록
        // 동적으로 추가되는 버튼들에 대한 이벤트 리스너 등록
        document.getElementById('request-items-container').addEventListener('click', function (e) {
            // 삭제 버튼('.delete-item-btn')이 클릭되었을 때만 동작
            if (e.target.closest('.delete-item-btn')) {
                // 클릭된 버튼의 가장 가까운 '.request-item-box' 부모 요소를 찾아서 제거
                e.target.closest('.request-item-box').remove();
            }
        });

        document.getElementById('addItemBtn').addEventListener('click', function () {
            // 새 아이템 박스를 생성하고 컨테이너에 추가
            const newItemHtml = createItemBoxHtml(null); // 비어있는 새 박스 생성
            document.getElementById('request-items-container').insertAdjacentHTML('beforeend', newItemHtml);
        });


    }
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>