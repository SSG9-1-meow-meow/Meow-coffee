<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<div class="page-inner">
  <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div>
      <h3 class="fw-bold mb-3">입고 처리 및 위치 지정</h3>

      <%-- js 로 아래 해당하는 값 넣어주기     --%>
      <h5 class="op-7 mb-2"> 입고 요청 ID: <span id="inReqId-display"></span></h5>
      <h6 class="op-7 mb-2"> 입고 상세 아이템 항목 ID: ${inReqItemsId}</h6>
    </div>
  </div>

  <div class="row">

    <%-- ★★★ [추가] 회원 요청일 표시를 위한 CSS ★★★ --%>
    <style>
        .fc-day-today {
            background: inherit !important; /* FullCalendar의 기본 'today' 배경색 제거 */
        }

        .fc-day[data-date="${currentItemData.inDateWish}"] {
            /* 회원 요청일에 대한 스타일 (예: 테두리) - 이 부분은 JS에서 클래스로 제어 */
        }

        .wish-date-indicator {
            position: absolute;
            top: 5px;
            right: 5px;
            color: #0d6efd; /* Bootstrap primary color */
        }

        /* 날짜 숫자가 아이콘을 밀어내도록 패딩 추가 */
        .fc .fc-daygrid-day-top {
            position: relative; /* 자식 요소(아이콘)의 absolute 위치 기준점 */
            flex-direction: row !important; /* 내부 요소들을 가로로 배열 */
        }

        .fc .fc-daygrid-day-number {
            margin-left: 15px; /* ★★★ 별 아이콘이 들어갈 공간 확보 ★★★ */
        }

        /* ★★★ [추가] 달력 날짜 위에 마우스를 올리면 클릭 가능함을 표시 ★★★ */
        .fc-daygrid-day {
            cursor: pointer;
        }

        /* thead의 텍스트를 세로 중앙 정렬 */
        .table thead th {
            vertical-align: middle;
        }

        /* 각 창고 정보 블록의 위쪽에 구분선을 추가 (첫 번째 블록 제외) */
        #load-info-tbody > tr.warehouse-group-start:not(:first-child) {
            border-top: 2px solid #dee2e6; /* Bootstrap의 기본 테이블 테두리 색상 */
        }

        /* ★★★ [추가] 좌측 정보 카드를 위한 Sticky(고정) 스타일 ★★★ */
        .sticky-top-card {
            /*position: -webkit-sticky; !* Safari 브라우저 호환성 *!*/
            position: sticky;
            top: 20px; /* 화면 상단에서 20px 떨어진 위치에 고정 */
        }

    </style>

    <!-- 좌측: 요청 상세 정보 (30%) -->
    <%-- ★★★ [수정] 이 div에 sticky-top-card 클래스 추가 ★★★ --%>
    <div class="col-md-4 sticky-top-card">
      <div class="card">
        <div class="card-header"><h4 class="card-title">요청 정보</h4></div>
        <div class="card-body" id="item-info-card">
          <p class="text-center">로딩 중...</p>
        </div>
      </div>

      <!-- ★★★ [추가] 실물 입고 처리 카드 (초기에는 숨김) ★★★ -->
      <div class="card mt-4" id="physical-inbound-card" style="display: none;">
        <div class="card-header">
          <h4 class="card-title">입고 처리</h4>
        </div>
        <div class="card-body">
          <p>검수가 완료되었습니다. 실제 입고를 확정 처리합니다.</p>
          <div class="d-grid">
            <button class="btn btn-success" id="complete-inbound-btn">실물 입고 완료</button>
          </div>
        </div>
      </div>
    </div>


    <!-- 우측: 달력 및 부하 정보 (70%) -->
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <div class="d-flex justify-content-between align-items-center">
            <h4 class="card-title mb-0">입고 가능일 조회 및 선택</h4>
            <div id="calendar-legend">
              <span class="me-3"><i class="fas fa-star text-primary"></i> 회원 입고 희망일</span>
              <span class="me-3"><i class="far fa-square text-muted"></i> 예정 없음</span>
              <span class="me-2"><i class="fas fa-square text-success"></i> 안전</span>
              <span class="me-2"><i class="fas fa-square text-warning"></i> 경고</span>
              <span><i class="fas fa-square text-danger"></i> 위험</span>
            </div>
          </div>
        </div>
        <div class="card-body">
          <!-- FullCalendar가 렌더링될 영역 -->
          <div id="calendar"></div>
        </div>
      </div>


      <div class="card" id="load-info-panel" style="display: none;">
        <div class="card-header"><h5 class="card-title"><span id="selected-date-display"></span> 부하 정보</h5></div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered text-center align-middle table-hover">
              <thead class="table-light">
              <tr>
                <th style="width: 15%;">창고명</th>
                <th style="width: 10%;">구분</th>
                <th>수용 능력 (PLT)</th>
                <th>처리 부하 (PLT)</th>
                <th>인력 부하 (명)</th>
                <th>장비 부하 (대)</th>
              </tr>
              </thead>
              <tbody id="load-info-tbody">
              <!-- JS로 채워짐 -->
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="card" id="location-assignment-panel" style="display: none;">
        <div class="card-header"><h5 class="card-title">보관 위치 지정</h5></div>
        <div class="card-body">
          <%-- ★★★ [수정] 드롭다운 -> 테이블 구조로 변경 ★★★ --%>
          <div class="table-responsive">
            <table class="table table-hover table-bordered text-center align-middle">
              <thead class="table-light">
              <tr>
                <th>위치 ID</th>
                <th>창고 - Zone</th>
                <th>현재 재고</th>
                <th>입고예정</th>
                <th>출고예정</th>
                <th>최종 예상량</th>
                <th>추천</th>
              </tr>
              </thead>
              <tbody id="available-locations-tbody">
              <!-- JS로 채워짐 -->
              </tbody>
            </table>
          </div>
          <small class="form-text text-muted">
            각종 부하 및 보관 한도(20 PLT)를 초과하지 않는 위치만 표시됩니다.
          </small>
          <%-- 나중에 Rack, Cell 선택 UI가 여기에 추가될 수 있음 --%>
        </div>
      </div>

      <!-- ================================================================ -->
      <!--                관리자 최종 처리 섹션 (초기에는 숨김)                 -->
      <!-- ================================================================ -->
      <div class="card" id="final-process-panel" style="display: none;">
        <div class="card-header">
          <h5 class="card-title">최종 입고 처리</h5>
        </div>
        <div class="card-body">

          <!-- ★★★ [수정] 라디오 버튼 그룹으로 처리 방식 선택 ★★★ -->
          <div class="form-group">
            <label class="form-label"><strong>처리 방식 선택</strong></label>
            <div class="selectgroup w-100">
              <label class="selectgroup-item">
                <input type="radio" name="processType" value="APPROVE" class="selectgroup-input" checked>
                <span class="selectgroup-button">승인</span>
              </label>
              <label class="selectgroup-item">
                <input type="radio" name="processType" value="REJECT" class="selectgroup-input">
                <span class="selectgroup-button">반려</span>
              </label>
            </div>
          </div>

          <%-- '승인' 시에만 보이는 섹션 --%>
          <div id="approval-section">
            <div class="row">
              <div class="col-md-6 form-group">
                <label><strong>입고 예정일 (확정)</strong></label>
                <input type="text" class="form-control" id="confirmed-date" placeholder="날짜를 선택하세요">
              </div>
              <div class="col-md-6 form-group">
                <label for="location-select"><strong>보관 위치 (확정)</strong></label>
                <select class="form-select" id="location-select">
                  <!-- JS로 채워짐 -->
                </select>
              </div>
            </div>
          </div>
          <hr>


          <%-- '승인' 또는 '반려' 시 공통으로 보이는 섹션 --%>
          <div class="form-group">
            <label for="memo-code-select"><strong>관리자 메모 선택</strong></label>
            <select class="form-select" id="memo-code-select">
              <option selected disabled value="">-- 메모 사유를 선택하세요 --</option>
              <!-- JS로 채워짐 -->
            </select>
          </div>
          <div class="form-group mt-2">
            <textarea class="form-control" id="admin-memo-textarea" rows="3"
                      placeholder="선택한 메모가 여기에 표시됩니다. 직접 수정할 수도 있습니다.">
            </textarea>
          </div>
        </div>
        <div class="card-footer d-flex justify-content-between">
          <div>
            <button class="btn btn-primary" id="submit-final-btn">저장 및 회원 통보</button>
            <button class="btn btn-info" id="temp-save-btn">임시 저장</button>
          </div>
          <button class="btn btn-secondary" id="reset-btn">입력 내용 초기화</button>
        </div>
      </div>


    </div>
  </div>
  <!-- QR 코드 표시를 위한 Bootstrap Modal -->
  <div class="modal fade" id="qrCodeModal" tabindex="-1" aria-labelledby="qrCodeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="qrCodeModalLabel">재고 QR 코드</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body text-center">
          <!-- QR 코드 이미지가 여기에 표시됩니다 -->
          <a href="#" id="qr-code-link">
            <img id="qr-code-image" src="" alt="QR Code" class="img-fluid">
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
    const inReqItemsId = "${inReqItemsId}";
    let currentItemData = {}; // 좌측 카드에 표시할 아이템 데이터
    let flatpickrInstance = null; // 데이트 피커 인스턴스를 저장할 변수
    const memoCodes = JSON.parse('${memoCodesAsJson}');


    // --- [1] 데이터 렌더링 함수 (EL 충돌 해결) ---
    function renderItemInfoCard(item) {
        const cardBody = document.getElementById('item-info-card');
        let statusText, statusClass;

        switch (item.status) {
            case 'APPROVED':
                statusText = '승인 완료';
                statusClass = 'list-group-item-success';
                break;
            case 'RECEIVED':
                statusText = '입고 완료';
                statusClass = 'list-group-item-primary';
                break;
            case 'REJECTED':
                statusText = '반려';
                statusClass = 'list-group-item-danger';
                break;
            default:
                statusText = '승인 대기';
                statusClass = 'list-group-item-warning';
                break;
        }


        // 확정 정보 HTML 생성 (승인/입고 완료 시)
        let confirmedInfoHtml = '';
        let actionButtonsHtml = '';

        if ((item.status === 'APPROVED' || item.status === 'RECEIVED')) {
            if (item.inDttmSchd) {
                const locationText = item.warehouseName && item.zoneName && item.lpId
                    ? item.warehouseName + ' - ' + item.zoneName + ' (' + item.lpId + ')'
                    : (item.locationId || '미지정');

                confirmedInfoHtml =
                    '<li class="list-group-item"><strong>확정 입고일:</strong> ' + item.inDttmSchd.substring(0, 10) + '</li>' +
                    '<li class="list-group-item"><strong>확정 위치:</strong> ' + locationText + '</li>';
            }

            // ★★★ [수정] '입고 지시서 보기' 버튼을 기본으로 생성 ★★★
            actionButtonsHtml += '<a href="/inbounds/instruction/' + item.inReqItemsId + '" class="btn btn-primary" target="_blank">입고 지시서 보기</a>';
        }

        // ★★★ [추가] '입고완료' 상태일 때만 'QR 코드 보기' 버튼을 추가로 생성 ★★★
        if (item.status === 'RECEIVED') {
            // 버튼 사이에 간격을 주기 위해 'ms-2' 클래스 추가
            actionButtonsHtml += '<button type="button" class="btn btn-info ms-2" id="show-qr-btn">QR 코드 보기</button>';
        }

        // ★★★ [수정] 최종 버튼 HTML을 card-footer로 감싸서 생성 ★★★
        let finalButtonHtml = '';
        if(actionButtonsHtml) { // 버튼이 하나라도 생성되었을 경우에만 footer를 만듦
            finalButtonHtml =
                '<div class="card-footer text-center">' +
                actionButtonsHtml +
                '</div>';
        }

        cardBody.innerHTML =
            '<ul class="list-group list-group-flush">' +
            '<li class="list-group-item"><strong>거래처명:</strong> ' + item.companyName + '</li>' +
            '<li class="list-group-item"><strong>품목명:</strong> ' + item.cfName + '</li>' +
            '<li class="list-group-item"><strong>요청 수량:</strong> ' + item.inQtyReq + ' PLT</li>' +
            '<li class="list-group-item"><strong>희망 일자:</strong> ' + item.inDateWish + '</li>' +
            '<li class="list-group-item ' + statusClass + '"><strong>현재 상태:</strong> ' + statusText + '</li>' +
            confirmedInfoHtml +
            '</ul>' +
            finalButtonHtml;

        document.getElementById('inReqId-display').textContent = item.inReqId;
    }

    function renderLoadInfo(date, warehouseDataList) {
        document.getElementById('selected-date-display').textContent = date;
        const tbody = document.getElementById('load-info-tbody');
        tbody.innerHTML = '';

        const requestedLoad = currentItemData.inQtyReq;

        /**
         * 부하 상태에 따라 신호등 아이콘 HTML을 반환하는 헬퍼 함수
         */
        function getTrafficLightIcon(combined, max) {
            if (!max || max === 0) return '<i class="fas fa-minus-circle text-muted"></i>';
            const loadPercentage = (combined / max) * 100;
            if (loadPercentage > 100) return '<i class="fas fa-circle text-danger"></i>';
            if (loadPercentage >= 80) return '<i class="fas fa-circle text-warning"></i>';
            return '<i class="fas fa-circle text-success"></i>';
        }

        if (warehouseDataList && warehouseDataList.length > 0) {
            warehouseDataList.forEach(whData => {
                // --- 각 창고별 데이터 계산 ---
                // 수용 능력
                const storage_request = requestedLoad;
                const storage_assigned = whData.usedStorageCapacity || 0;
                const storage_max = whData.totalStorageCapacity || 0;
                const storage_icon = getTrafficLightIcon(storage_request + storage_assigned, storage_max);

                // 처리 부하
                const proc_request = requestedLoad;
                const proc_assigned = whData.usedProcessingCapacity || 0;
                const proc_max = whData.maxProcessingCapacity || 0;
                const proc_icon = getTrafficLightIcon(proc_request + proc_assigned, proc_max);

                // 인력 부하
                const staff_request = requestedLoad * 2;
                const staff_assigned = whData.staffAssigned || 0;
                const staff_max = whData.staffAvailable || 0;
                const staff_icon = getTrafficLightIcon(staff_request + staff_assigned, staff_max);

                // 장비 부하
                const equip_request = requestedLoad;
                const equip_assigned = whData.equipAssigned || 0;
                const equip_max = whData.equipAvailable || 0;
                const equip_icon = getTrafficLightIcon(equip_request + equip_assigned, equip_max);

                // --- HTML 문자열 생성 ---
                const warehouseRows =
                    // 1. 신청(Request) 행
                    '<tr class="warehouse-group-start">' +
                    // rowspan="4"를 사용하여 4개의 행을 병합
                    '<td rowspan="4"><strong>' + whData.warehouseName + '</strong></td>' +
                    '<th scope="row">신청</th>' +
                    '<td>' + storage_request + '</td>' +
                    '<td>' + proc_request + '</td>' +
                    '<td>' + staff_request + '</td>' +
                    '<td>' + equip_request + '</td>' +
                    '</tr>' +

                    // 2. 배정(Assigned) 행
                    '<tr>' +
                    // (창고명 셀은 rowspan으로 인해 여기에 없음)
                    '<th scope="row">배정</th>' +
                    '<td>' + storage_assigned + '</td>' +
                    '<td>' + proc_assigned + '</td>' +
                    '<td>' + staff_assigned + '</td>' +
                    '<td>' + equip_assigned + '</td>' +
                    '</tr>' +

                    // 3. 최대(Max) 행
                    '<tr>' +
                    '<th scope="row">최대</th>' +
                    '<td>' + storage_max + '</td>' +
                    '<td>' + proc_max + '</td>' +
                    '<td>' + staff_max + '</td>' +
                    '<td>' + equip_max + '</td>' +
                    '</tr>' +

                    // 4. 부하(Load) 행
                    '<tr>' +
                    '<th scope="row">부하</th>' +
                    '<td>' + storage_icon + '</td>' +
                    '<td>' + proc_icon + '</td>' +
                    '<td>' + staff_icon + '</td>' +
                    '<td>' + equip_icon + '</td>' +
                    '</tr>';

                tbody.insertAdjacentHTML('beforeend', warehouseRows);
            });
        } else {
            // 데이터가 없는 경우, colspan을 헤더 컬럼 수에 맞게 6으로 수정
            tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">해당 날짜에 예정된 부하 정보가 없습니다.</td></tr>';
        }

        document.getElementById('load-info-panel').style.display = 'block';
    }


    // --- [2] API 호출 및 데이터 처리 함수 : 특정 날짜의 부하/위치 정보를 API로 조회하고 화면을 업데이트하는 함수
    function updatePanelsForDate(date) {
        // 1. 부하 정보 패널 업데이트
        axios.get('/inbounds/api/load/' + date)
            .then(response => renderLoadInfo(date, response.data))
            .catch(error => console.error(date + ' 부하 정보 로딩 실패', error));

        // 2. 위치 지정 패널 업데이트
        const locationPanel = document.getElementById('location-assignment-panel');
        const tbody = document.getElementById('available-locations-tbody');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">선택 가능한 위치를 불러오는 중...</td></tr>';
        locationPanel.style.display = 'block';

        axios.get('/inbounds/api/available-locations', {
            params: {date: date, quantity: currentItemData.inQtyReq}
        })
            .then(response => {
                renderAvailableLocations(date, response.data); // 위치 '테이블' 렌더링
                updateLocationDropdown(response.data);    // 위치 '드롭다운' 업데이트
            })
            .catch(error => {
                console.error("할당 가능 위치 로딩 실패", error);
                tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">현재 할당 가능한 위치가 없습니다.</td></tr>';
                updateLocationDropdown([]); // 실패 시 드롭다운 비우기
            });
    }

    // --- [3] UI 컴포넌트 제어 함수
    function updateLocationDropdown(availableLocations) {
        const locationSelect = document.getElementById('location-select');
        locationSelect.innerHTML = ''; // 기존 옵션 모두 제거
        if (!availableLocations || availableLocations.length === 0) {
            locationSelect.add(new Option('선택 가능한 위치 없음', ''));
            locationSelect.disabled = true;
            document.getElementById('approve-btn').disabled = true; // 승인 버튼 비활성화
            return;
        }

        locationSelect.disabled = false;
        locationSelect.add(new Option('-- 보관 위치를 선택하세요 --', ''));
        availableLocations.forEach(loc => {
            const optionText = loc.warehouseName + ' - ' + loc.zoneName + ' (' + loc.lpId + ')';
            locationSelect.add(new Option(optionText, loc.lpId));
        });
    }


    // 'dateClick'에서 호출될, 위치 테이블을 렌더링하는 함수
    function renderAvailableLocations(date, availableLocations) {
        const tbody = document.getElementById('available-locations-tbody');

        tbody.innerHTML = '';

        if (!availableLocations || availableLocations.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">할당 가능한 위치가 없습니다.</td></tr>';
            return;
        }

        const requestedQty = currentItemData.inQtyReq;

        // --- ★★★ 추천 로직 시작 ★★★ ---
        let maxEfficiencyScore = -1;
        let minStabilityScore = 21; // 20보다 큰 값으로 초기화
        let efficiencyLeaders = [];
        let stabilityLeaders = [];

        // 1. 분석: 각 위치의 최종 예상량을 계산하고 최고/최저 점수 찾기
        availableLocations.forEach(loc => {

            const finalQty = loc.currentStock + loc.scheduledInbound - loc.scheduledOutbound + requestedQty;

            // 공간 효율성 (20에 가장 가까운 값)
            if (finalQty > maxEfficiencyScore) {
                maxEfficiencyScore = finalQty;
                efficiencyLeaders = [loc.lpId]; // 새로운 최고점, 리더 초기화
            } else if (finalQty === maxEfficiencyScore) {
                efficiencyLeaders.push(loc.lpId); // 공동 선두 추가
            }

            // 안정성 (0에 가장 가까운 값)
            if (finalQty < minStabilityScore) {
                minStabilityScore = finalQty;
                stabilityLeaders = [loc.lpId]; // 새로운 최저점, 리더 초기화
            } else if (finalQty === minStabilityScore) {
                stabilityLeaders.push(loc.lpId); // 공동 선두 추가
            }
        });

        // 2. 렌더링: 분석 결과를 바탕으로 테이블 생성
        availableLocations.forEach(loc => {
            const projectedStock = loc.currentStock + loc.scheduledInbound - loc.scheduledOutbound;
            const finalQty = projectedStock + requestedQty;

            let recommendationHtml = '';
            if (efficiencyLeaders.includes(loc.lpId)) {
                recommendationHtml += '<span class="badge bg-primary"><i class="far fa-star"></i> 공간효율성 최고</span>';
            }
            if (stabilityLeaders.includes(loc.lpId)) {
                recommendationHtml += '<span class="badge bg-success ms-1"><i class="far fa-star"></i> 안정성 최고</span>';
            }

            const row =
                '<tr>' +
                '<td><strong>' + loc.lpId + '</strong></td>' +
                '<td>' + loc.warehouseName + ' - ' + loc.zoneName + '</td>' +
                '<td>' + loc.currentStock + '</td>' +
                '<td>' + loc.scheduledInbound + '</td>' +
                '<td>' + loc.scheduledOutbound + '</td>' +
                '<td>' + finalQty + ' / 20</td>' +
                '<td>' + recommendationHtml + '</td>' +
                '</tr>';
            tbody.insertAdjacentHTML('beforeend', row);
        });
        // --- 추천 로직 종료 ---
    }

    /**
     * 라디오 버튼 변경에 따라 UI를 업데이트하는 함수
     * @param {string} selectedValue - 'APPROVE' 또는 'REJECT'
     */
    function handleProcessTypeChange(selectedValue) {
        const approvalSection = document.getElementById('approval-section');
        const memoSelect = document.getElementById('memo-code-select');
        const memoTextarea = document.getElementById('admin-memo-textarea');

        if (selectedValue === 'APPROVE') {
            approvalSection.style.display = 'block';
            memoSelect.value = 'APPROVED';
            memoTextarea.value = memoCodes['APPROVED']?.description || '승인되었습니다.';
        } else { // REJECT
            approvalSection.style.display = 'none';
            memoSelect.value = 'REJECTED';
            memoTextarea.value = memoCodes['REJECTED']?.description || '';
            memoTextarea.focus();
        }
    }

    // [4] 메인 컨트롤 함수
    function showFinalProcessPanel(mode, selectedDate) {
        const panel = document.getElementById('final-process-panel');
        const finalButtons = panel.querySelector('.card-footer');
        const processRadios = document.querySelectorAll('input[name="processType"]');

        // 이 함수 내에서만 사용할 UI 요소 변수들
        const memoSelect = document.getElementById('memo-code-select');
        const memoTextarea = document.getElementById('admin-memo-textarea');
        const locationSelect = document.getElementById('location-select');
        const confirmedDateInput = document.getElementById('confirmed-date');

        if (memoSelect.options.length <= 1) {
            for (const code in memoCodes) {
                memoSelect.add(new Option(memoCodes[code].codeName, code));
            }
        }

        // --- 모드에 따라 UI 분기 ---
        // 1. '승인대기' 상태에서 수정 가능 모드
        if (mode === 'EDIT') { // UI 요소 활성화
            finalButtons.classList.remove('d-none');
            processRadios.forEach(radio => radio.disabled = false);
            memoTextarea.readOnly = false;
            memoSelect.disabled = false;
            locationSelect.disabled = false;
            confirmedDateInput.readOnly = false; // flatpickr가 제어하지만, 명시적으로 설정

            document.querySelector('input[name="processType"][value="APPROVE"]').checked = true;
            handleProcessTypeChange('APPROVE'); // 함수 호출로 UI 초기화

            // ★★★ 데이트 피커 초기화 (수정 가능 모드에서만) ★★★
            if (flatpickrInstance) flatpickrInstance.destroy(); // 기존 인스턴스 파괴
            flatpickrInstance = flatpickr("#confirmed-date", {
                locale: "ko",
                dateFormat: "Y-m-d",
                defaultDate: selectedDate, // FullCalendar에서 클릭한 날짜를 기본값으로 설정
                onChange: (selectedDates, dateStr, instance) => updatePanelsForDate(dateStr)
            });

            if (currentItemData.inDttmSchd) { // 임시 저장 데이터 복원
                setTimeout(() => {
                    document.getElementById('location-select').value = currentItemData.locationId;
                }, 500);
                if (currentItemData.adminMemo) {
                    document.getElementById('admin-memo-textarea').value = currentItemData.adminMemo;
                }
            }
        } else { // 2. '승인완료', '입고완료', '반려' 등 이미 처리된 상태 (읽기 전용 모드) => UI 비활성화
            finalButtons.classList.add('d-none');
            processRadios.forEach(radio => radio.disabled = true);

            memoTextarea.readOnly = true;
            memoSelect.disabled = true;
            locationSelect.disabled = true;
            confirmedDateInput.readOnly = true;
            memoTextarea.value = currentItemData.adminMemo || '저장된 메모 없음';

            if (flatpickrInstance) flatpickrInstance.destroy();

            if (mode === 'APPROVED' || mode === 'RECEIVED') {
                document.querySelector('input[name="processType"][value="APPROVE"]').checked = true;
                confirmedDateInput.value = currentItemData.inDttmSchd ? currentItemData.inDttmSchd.substring(0, 10) : '';
                locationSelect.innerHTML = '';
                if (currentItemData.lpId) {
                    const locationText = currentItemData.warehouseName + ' - ' + currentItemData.zoneName + ' (' + currentItemData.lpId + ')';
                    locationSelect.add(new Option(locationText, currentItemData.lpId, true, true));
                } else {
                    locationSelect.add(new Option('(확정 위치 없음)', '', true, true));
                }
            } else { // REJECTED
                document.querySelector('input[name="processType"][value="REJECT"]').checked = true;
            }
            // UI를 읽기 전용 상태에 맞게 업데이트
            handleProcessTypeChange(document.querySelector('input[name="processType"]:checked').value);
        }

        panel.style.display = 'block';
        // panel.scrollIntoView({ behavior: 'smooth' });
    }


    // [5] DOM 초기화
    document.addEventListener('DOMContentLoaded', function () {
        // 이벤트 리스너 바인딩
        document.getElementById('submit-final-btn').addEventListener('click', () => submitFinalProcess(0));
        document.getElementById('temp-save-btn').addEventListener('click', () => submitFinalProcess(1));
        document.querySelectorAll('input[name="processType"]').forEach(radio => {
            radio.addEventListener('change', (event) => handleProcessTypeChange(event.target.value));
        });
        // 메모 드롭다운 변경 시 텍스트 에어리어 내용 자동 업데이트
        document.getElementById('memo-code-select').addEventListener('change', function () {
            const selectedCode = this.value;
            if (memoCodes[selectedCode]) {
                // 선택된 영문 코드에 해당하는 객체에서 description을 가져옴
                document.getElementById('admin-memo-textarea').value = memoCodes[selectedCode].description;
            }
        });
        // '입력 내용 초기화' 버튼 이벤트
        document.getElementById('reset-btn').addEventListener('click', function () {
            // mode에 따라 초기화 로직 구현 (예: 승인 모드면 날짜, 위치, 메모 모두 초기화)
            if (document.getElementById('approval-section').style.display === 'block') {
                document.getElementById('location-select').selectedIndex = 0;
            }
            document.getElementById('memo-code-select').selectedIndex = 0;
            document.getElementById('admin-memo-textarea').value = '';
        });


        // 1. 좌측 카드 정보 로딩
        axios.get(`/inbounds/api/items/${inReqItemsId}`)
            .then(response => {
                currentItemData = response.data;
                renderItemInfoCard(currentItemData);

                const showQrBtn = document.getElementById('show-qr-btn');
                if (showQrBtn) {
                    showQrBtn.addEventListener('click', function() {
                        const stockIdForQr = currentItemData.inReqItemsId;
                        const qrImageUrl = '/inbounds/qr/' + stockIdForQr;
                        document.getElementById('qr-code-image').src = qrImageUrl;

                        const detailPageUrl = '/inbounds/stock/detail/' + stockIdForQr;
                        document.getElementById('qr-code-link').href = detailPageUrl;

                        // ★★★ [핵심 수정] new bootstrap.Modal() 대신 아래 코드로 변경 ★★★
                        // 1. 모달 엘리먼트를 가져옵니다.
                        const qrModalEl = document.getElementById('qrCodeModal');
                        // 2. 이미 존재하는 bootstrap 인스턴스를 가져오거나, 없으면 새로 생성합니다.
                        //    이 방법은 중복 생성을 방지하여 충돌을 막아줍니다.
                        const qrModal = bootstrap.Modal.getOrCreateInstance(qrModalEl);
                        // 3. 모달을 보여줍니다.
                        qrModal.show();
                    });
                }

                // ★★★ [추가] '실물 입고 완료' 버튼 표시 조건 ★★★
                // 1. 상태가 '승인완료(APPROVED)'이고
                // 2. 검수시각(inDttmInsp)이 존재하며
                // 3. 실제 입고시각(inDttmRecv)은 아직 없을 때
                if (currentItemData.status === 'APPROVED' && currentItemData.inDttmInsp && !currentItemData.inDttmRecv) {
                    const physicalInboundCard = document.getElementById('physical-inbound-card');
                    physicalInboundCard.style.display = 'block';

                    // ★★★ [추가] 버튼에 클릭 이벤트 리스너 바인딩 ★★★
                    document.getElementById('complete-inbound-btn').addEventListener('click', function() {
                        if (confirm('실물 입고를 완료 처리하시겠습니까? 재고에 즉시 반영됩니다.')) {
                            axios.put('/inbounds/items/complete/' + inReqItemsId)
                                .then(res => {
                                    alert(res.data.message);
                                    // 성공 시 페이지를 새로고침하여 상태 변경(입고완료)을 확인
                                    window.location.reload();
                                })
                                .catch(err => {
                                    const errorMessage = err.response?.data?.message || "처리 중 오류가 발생했습니다.";
                                    alert(errorMessage);
                                });
                        }
                    });
                }

                // ★★★ 상태에 따른 분기 처리 ★★★
                if (currentItemData.status === 'PENDING') { // '승인대기' 상태일 때
                    // inDttmSchd 필드에 값이 있으면 임시 저장된 데이터가 있는 것으로 간주
                    if (currentItemData.inDttmSchd) {
                        console.log('imsi here!')
                        document.getElementById('calendar').parentElement.parentElement.style.display = 'none';
                        const tempSavedDate = currentItemData.inDttmSchd.substring(0, 10);
                        updatePanelsForDate(tempSavedDate);
                        showFinalProcessPanel('EDIT', tempSavedDate);

                    } else {
                        // 2. 임시 저장 데이터가 없으면 (최초 처리):
                        initializeCalendar(currentItemData.inDateWish);
                    }
                } else { // 'APPROVED', 'RECEIVED', 'REJECTED' 등 그 외 모든 상태일 경우,
                    // FullCalendar를 숨기고, '읽기 전용'으로 최종 처리 패널을 보여줍니다.
                    document.getElementById('calendar').parentElement.parentElement.style.display = 'none';
                    showFinalProcessPanel(currentItemData.status);
                }

            })
            .catch(error => {
                document.getElementById('item-info-card').innerHTML = '<p class="text-center text-danger">정보 로딩 실패</p>';
            });

    });

    /**
     * 최종 처리 데이터를 서버로 전송하는 함수
     * @param {number} isTempo - 0: 최종 저장, 1: 임시 저장
     */
    function submitFinalProcess(isTempo) {

        // ★★★ PENDING 상태가 아니면 실행을 막는 방어 코드 ★★★
        if (currentItemData.status !== 'PENDING') {
            alert('이미 처리가 완료된 요청입니다.');
            return;
        }

        // ★★★ [핵심 수정] 선택된 라디오 버튼 값으로 상태 결정 ★★★
        const selectedProcess = document.querySelector('input[name="processType"]:checked').value;
        let newStatus;

        if (isTempo === 1) {
            newStatus = 'PENDING';
        } else {
            if (selectedProcess === 'APPROVE') {
                newStatus = 'APPROVED';
            } else { // REJECT
                newStatus = 'REJECTED';
            }
        }

        // --- 유효성 검사 ---
        if (!newStatus && !isTempo) {
            alert("관리자 메모를 선택해주세요.");
            return;
        }

        // 최종 처리 데이터 객체 생성
        const processData = {
            managerId: 'manager01', // TODO: 실제 로그인한 관리자 ID로 변경
            newStatus: newStatus,
            adminMemo: document.getElementById('admin-memo-textarea').value,
            isTempo: isTempo
        };

        if (newStatus === 'APPROVED') {
            const confirmedDate = document.getElementById('confirmed-date').value;
            const lpId = document.getElementById('location-select').value;
            if (!confirmedDate || !lpId) {
                alert("입고 예정일과 보관 위치를 모두 선택해주세요.");
                return;
            }
            processData.confirmedDate = confirmedDate;
            processData.lpId = lpId;
        }

        if (isTempo === 1) {
            processData.confirmedDate = document.getElementById('confirmed-date').value || null;
            processData.lpId = document.getElementById('location-select').value || null;
        }


        console.log("Final process data to send:", processData);

        // Axios POST 요청
        axios.post('/inbounds/items/' + inReqItemsId, processData)
            .then(response => {
                alert(response.data.message);
                // 성공 시 목록 페이지 또는 요청 상세 페이지로 이동
                window.location.href = '/inbounds/' + currentItemData.inReqId;
            })
            .catch(error => {
                console.error("최종 처리 중 오류 발생:", error);
                alert("처리 중 오류가 발생했습니다.");
            });
    }


    function initializeCalendar(initialDate) {
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            initialDate: initialDate,
            locale: 'ko',
            // ★★★ [수정 1] 헤더 툴바: 'today' 제거, 커스텀 버튼 추가 ★★★
            headerToolbar: {
                left: 'prev,next wishDateButton', // 'today' 대신 'wishDateButton' 추가
                center: 'title',
                right: ''
            },
            // 커스텀 버튼 정의
            customButtons: {
                wishDateButton: {
                    text: '회원 입고 희망일',
                    click: function () {
                        // 클릭 시 initialDate(회원 희망일)로 달력 이동
                        calendar.gotoDate(initialDate);
                    }
                }
            },
            height: 'auto',
            timeZone: 'Asia/Seoul',

            // ★★★ dayCellDidMount: 날짜 셀이 렌더링된 후 호출되는 콜백 ★★★
            dayCellDidMount: function (arg) {
                // 현재 렌더링되는 날짜(arg.date)가 회원 희망일(initialDate)과 같은지 확인
                if (arg.date.toISOString().substring(0, 10) === initialDate) {
                    // 같다면, 날짜 셀의 숫자 옆에 별 아이콘 추가
                    let iconEl = document.createElement('i');
                    iconEl.className = 'fas fa-star wish-date-indicator'; // 위에서 정의한 CSS 클래스
                    arg.el.querySelector('.fc-daygrid-day-top').appendChild(iconEl);
                }
            },

            events: async function (fetchInfo) {
                try {
                    const startDate = fetchInfo.startStr.substring(0, 10);
                    const endDate = fetchInfo.endStr.substring(0, 10);

                    const response = await axios.get('/inbounds/api/capacity-events', {
                        params: {startDate, endDate}
                    });

                    // 사용자가 처리를 요청한 처리 용량 = 1PLT 단위
                    const requestedLoad = currentItemData.inQtyReq;

                    return response.data.map(eventData => {

                        // ★★★ [핵심 수정] API로부터 받은 값을 기준으로 동적 계산 ★★★
                        const totalScheduledLoad = eventData.totalUsedCapacity; // 모든 창고의 예정된 처리 부하 합계
                        const totalAvailableCapacity = eventData.totalAvailableCapacity; // 모든 창고의 남은 처리 능력 합계

                        const combinedLoad = requestedLoad + totalScheduledLoad;

                        let backgroundColor = '#28a745'; // 안전(녹색)

                        // 남은 처리 능력(totalAvailableCapacity)보다 신청 부하(requestedLoad)가 더 큰 경우 '위험'
                        if (requestedLoad > totalAvailableCapacity) {
                            backgroundColor = '#dc3545'; // 위험(빨강)
                        }
                            // (신청 부하 + 예정 부하)가 전체 최대 처리 능력의 80%를 넘는 경우 '경고'
                        // (최대 처리 능력 = 예정 부하 + 가용 부하)
                        else if (combinedLoad > (totalScheduledLoad + totalAvailableCapacity) * 0.8) {
                            backgroundColor = '#ffc107'; // 경고(노랑)
                        }

                        return {
                            start: eventData.date,
                            display: 'background',
                            backgroundColor: backgroundColor
                        };
                    });

                } catch (error) {
                    console.error("Capacity events loading failed", error);
                    throw error;
                }
            },

            dateClick: function (info) {
                const clickedDate = info.dateStr;
                // 1. 선택된 날짜의 정보로 패널들 업데이트
                updatePanelsForDate(clickedDate);
                // 2. 최종 처리 패널을 '수정 가능' 모드로 표시
                showFinalProcessPanel('EDIT', clickedDate);
            }
        });

        calendar.render();
    }
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>