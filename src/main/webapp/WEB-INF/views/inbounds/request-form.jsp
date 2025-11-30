<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<!-- 메인 컨텐츠 시작 -->
<div class="page-inner">
  <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div>
      <h3 class="fw-bold mb-3">신규 입고 요청</h3>
      <h6 class="op-7 mb-2">입고를 원하는 품목을 추가하고 요청을 완료하세요.</h6>
    </div>
  </div>

  <div class="row">
    <!-- 왼쪽: 전체 커피 목록 -->
    <div class="col-md-5">
      <div class="card">
        <div class="card-header"><h4 class="card-title">전체 품목</h4></div>
        <div class="card-body" style="height: 600px; overflow-y: auto;">
          <ul class="list-group list-group-flush">
            <c:forEach items="${coffeeList}" var="coffee">
              <li class="list-group-item">
                <strong>${coffee.cfName}</strong> (${coffee.cfId}) &nbsp;<br>
                <small class="text-muted">${coffee.cfCategory} | ${coffee.cfGrade}</small>
              </li>
            </c:forEach>
          </ul>
        </div>
      </div>
    </div>

    <!-- 오른쪽: 입고 요청 양식 -->
    <div class="col-md-7">
      <div class="card">
        <div class="card-header"><h4 class="card-title">요청 품목</h4></div>
        <div class="card-body">
          <!-- 요청 항목들이 동적으로 추가될 컨테이너 -->
          <div id="request-items-container"></div>

          <!-- '추가하기' 버튼 -->
          <div class="d-grid gap-2 mt-3">
            <button class="btn btn-outline-primary" type="button" id="addItemBtn">
              <i class="fa fa-plus"></i> 품목 추가하기
            </button>
          </div>

          <hr>
          <!-- 희망 입고일 선택 -->
          <div class="form-group">
            <label for="inDateWish">희망 입고 날짜</label>
            <input type="date" class="form-control" id="inDateWish">
            <small id="date-info-text" class="form-text text-primary"></small>
          </div>
        </div>
        <div class="card-footer text-end">
          <!-- 최종 버튼 -->
          <button class="btn btn-secondary" id="saveDraftBtn">임시 저장</button>
          <button class="btn btn-primary" id="submitBtn">발주 신청</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 품목 박스 템플릿 (화면에는 보이지 않음) -->
<template id="request-item-template">
  <div class="request-item-box border p-3 mb-3 rounded position-relative">
    <%--  삭제 버튼--%>
      <button type="button" class="btn btn-link text-danger delete-item-btn position-absolute top-0 end-0 m-2" style="padding: 0.25rem 0.5rem;">
        <i class="fas fa-trash-alt"></i> <!-- Font Awesome 휴지통 아이콘 -->
      </button>
    <div class="row">
      <div class="col-md-8">
        <label class="form-label">품목 선택</label>
        <select class="form-select coffee-select">
          <option selected disabled value="">-- 커피를 선택하세요 --</option>
        </select>
      </div>
      <div class="col-md-4">
        <label class="form-label">수량</label>
        <select class="form-select quantity-select">
          <c:forEach var="i" begin="1" end="10">
            <option value="${i}">${i}</option>
          </c:forEach>
        </select>
      </div>
    </div>
  </div>
</template>

<script>
    // 컨트롤러가 전달한 JSON 데이터를 JavaScript 변수로 받음
    const coffeeList = JSON.parse('${coffeeListAsJson}');

    document.addEventListener('DOMContentLoaded', function() {
        const itemsContainer = document.getElementById('request-items-container');
        const addItemBtn = document.getElementById('addItemBtn');

        // ★★★ [수정/추가] 날짜 기본값 설정 및 유효성 검사 ★★★
        const inDateWishInput = document.getElementById('inDateWish');
        const dateInfoText = document.getElementById('date-info-text'); // 안내 문구 요소

        const today = new Date();
        // 14일 후 날짜 계산
        const twoWeeksLater = new Date(today.setDate(today.getDate() + 14));
        // YYYY-MM-DD 형식으로 변환
        const defaultValue = twoWeeksLater.toISOString().split('T')[0];

        // input 요소에 기본값 및 최소 선택 날짜 설정
        inDateWishInput.value = defaultValue;
        inDateWishInput.min = defaultValue;

        // 안내 문구를 한국어 형식으로 포맷팅하여 표시
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        dateInfoText.textContent = '희망 입고 날짜는 ' + twoWeeksLater.toLocaleDateString('ko-KR', options) + ' 부터 가능합니다.';


        // 품목 박스를 추가하는 함수
        function addItemBox() {
            const template = document.getElementById('request-item-template');
            const clone = template.content.cloneNode(true); // 템플릿 내용 복제
            const itemBox = clone.querySelector('.request-item-box');
            const coffeeSelect = clone.querySelector('.coffee-select');

            // 커피 드롭다운 메뉴 채우기
            coffeeList.forEach(coffee => {
                const option = document.createElement('option');
                option.value = coffee.cfId;
                option.textContent = coffee.cfName + ' (카테고리: ' + coffee.cfCategory + ' | 등급 : ' + coffee.cfGrade + ') ';
                coffeeSelect.appendChild(option);
            });

            // 'X' 삭제 버튼에 이벤트 리스너 추가
            clone.querySelector('.delete-item-btn').addEventListener('click', function() {
                itemBox.remove();
            });

            itemsContainer.appendChild(clone);
        }

        // '품목 추가하기' 버튼 클릭 이벤트
        addItemBtn.addEventListener('click', addItemBox);

        // 페이지 로드 시 기본으로 하나의 품목 박스를 추가
        addItemBox();

        // 요청 제출 함수 (isTempo: 0=발주신청, 1=임시저장)
        function submitRequest(isTempo) {
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

            // 선택된 날짜가 최소 날짜보다 이전인지 확인
            if (new Date(inDateWish) < new Date(defaultValue)) {
                alert('희망 입고 날짜는 오늘로부터 최소 2주 후여야 합니다.');
                inDateWishInput.focus();
                return;
            }

            // 서버로 보낼 데이터 객체
            const requestData = {
                _comId: '', // 컨트롤러단에서 스프링 시큐리티 적용된 아이디로 처리
                _inDateWish: inDateWish,
                _inItemsJson: JSON.stringify(items), // items or JSON.stringify(items) <= 문자열 안에 또 json이 있는 형태임.
                _isTempo: isTempo
            };

            console.log("서버로 전송할 데이터:", JSON.stringify(requestData, null, 2)); // 전송 직전 데이터 확인

            // Axios로 POST 요청
            axios.post('/inbounds/req', requestData)
                .then(function(response) {
                    alert('요청이 성공적으로 처리되었습니다.');
                    window.location.href = '/inbounds'; // 목록 페이지로 이동
                })
                .catch(function(error) {
                    console.error('요청 처리 중 오류 발생:', error);
                    alert('요청 처리 중 오류가 발생했습니다. 다시 시도해주세요.');
                });
        }

        // '발주 신청' 버튼 클릭 이벤트
        document.getElementById('submitBtn').addEventListener('click', function() {
            submitRequest(0);
        });

        // '임시 저장' 버튼 클릭 이벤트
        document.getElementById('saveDraftBtn').addEventListener('click', function() {
            submitRequest(1);
        });
    });
</script>


<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>