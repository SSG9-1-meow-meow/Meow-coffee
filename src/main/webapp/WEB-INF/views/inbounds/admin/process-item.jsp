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
    <!-- 좌측: 요청 상세 정보 (30%) -->
    <div class="col-md-4">
      <div class="card">
        <div class="card-header"><h4 class="card-title">요청 정보</h4></div>
        <div class="card-body" id="item-info-card">
          <p class="text-center">로딩 중...</p>
        </div>
      </div>
    </div>

    <!-- 우측: 달력 및 부하 정보 (70%) -->
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <div class="d-flex justify-content-between align-items-center">
            <h4 class="card-title mb-0">입고 가능일 조회</h4>
            <div id="calendar-legend">
              <span class="me-3"><i class="far fa-star text-primary"></i> 회원 입고 희망일</span>
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
      </style>

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



    </div>
  </div>
</div>

<script>
    const inReqItemsId = "${inReqItemsId}";
    let currentItemData = {}; // 좌측 카드에 표시할 아이템 데이터


    // --- 데이터 렌더링 함수 (EL 충돌 해결) ---
    function renderItemInfoCard(item) {
        const cardBody = document.getElementById('item-info-card');
        cardBody.innerHTML =
            '<ul class="list-group list-group-flush">' +
            '<li class="list-group-item"><strong>거래처명:</strong> ' + item.companyName + '</li>' +
            '<li class="list-group-item"><strong>품목명:</strong> ' + item.cfName + '</li>' +
            '<li class="list-group-item"><strong>카테고리:</strong> ' + item.cfCategory + '</li>' +
            '<li class="list-group-item"><strong>요청 수량:</strong> ' + item.inQtyReq + ' PLT</li>' +
            '<li class="list-group-item"><strong>요청 일자:</strong> ' + new Date(item.inDttmReq).toLocaleDateString('ko-KR') + '</li>' +
            '<li class="list-group-item"><strong>희망 일자:</strong> ' + item.inDateWish + '</li>' +
            '</ul>';

        // ★★★ [추가] 입고 요청 ID를 제목 영역에 동적으로 삽입 ★★★
        document.getElementById('inReqId-display').textContent = item.inReqId;
    }

    // ★★★ [수정] renderLoadInfo 함수 전체를 rowspan 렌더링 로직으로 교체 ★★★
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

    // --- 초기화 ---
    document.addEventListener('DOMContentLoaded', function () {
        // 1. 좌측 카드 정보 로딩
        axios.get(`/inbounds/api/items/${inReqItemsId}`)
            .then(response => {
                currentItemData = response.data;
                renderItemInfoCard(currentItemData);
                initializeCalendar(currentItemData.inDateWish);
            })
            .catch(error => {
                document.getElementById('item-info-card').innerHTML = '<p class="text-center text-danger">정보 로딩 실패</p>';
            });
    });

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

            // ★★★ [수정 2] dayCellDidMount: 날짜 셀이 렌더링된 후 호출되는 콜백 ★★★
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
                axios.get('/inbounds/api/load/' + clickedDate)
                    .then(response => {
                        renderLoadInfo(clickedDate, response.data);
                    })
                    .catch(error => {
                        console.error(clickedDate + ' 부하 정보 로딩 실패', error);
                    });

                const locationPanel = document.getElementById('location-assignment-panel');
                const tbody = document.getElementById('available-locations-tbody');

                tbody.innerHTML = '<tr><td colspan="7" class="text-center">선택 가능한 위치를 불러오는 중...</td></tr>';
                locationPanel.style.display = 'block';

                axios.get('/inbounds/api/available-locations', {
                    params: {
                        date: clickedDate,
                        quantity: currentItemData.inQtyReq
                    }
                })
                    .then(response => {
                        const availableLocations = response.data;
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

                    })
                    .catch(error => {
                        console.error("할당 가능 위치 로딩 실패", error);
                        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">오류 발생</td></tr>';
                    });
            }
        });


        calendar.render();
    }
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>