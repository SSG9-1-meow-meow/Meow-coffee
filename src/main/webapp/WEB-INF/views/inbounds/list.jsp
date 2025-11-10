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
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped mt-3">
            <thead>
            <tr>
              <th>요청ID</th>
              <th>상세ID</th>
              <th>거래처</th>
              <th>품목</th>
              <th>카테고리</th>
              <th>요청수량</th>
              <th>입고수량</th>
              <th>상태</th>
              <th>요청일시</th>
              <th>승인일시</th>
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
    // 페이지 로드 시 또는 특정 이벤트 발생 시 데이터를 가져와서 화면을 그리는 함수
    function loadInboundList(page) { // page 파라미터를 받도록 명시

        // 함수가 어떤 페이지 번호로 호출되었는지 확인합니다.
        // 브라우저 F12 개발자 도구의 '콘솔(Console)' 탭에서 확인 가능합니다.
        console.log("loadInboundList called with page:", page);

        // 만약 page가 undefined, null, 0 등 유효하지 않은 값이라면 기본값 1로 설정
        const pageToLoad = page || 1;

        const baseUrl = '/inbounds/api';
        const params = {
            page: pageToLoad
            // 여기에 나중에 검색/정렬 파라미터를 추가할 수 있습니다.
            // sortBy: 'reqDate',
            // companyName: '메오커피'
        };

        axios.get(baseUrl, {params: params})
            .then(function (response) {
                const data = response.data;
                const list = data.list;
                const pageMaker = data.pageMaker;

                // 1. 테이블 본문(tbody) 렌더링
                const tbody = document.getElementById('inbound-list-body');
                tbody.innerHTML = '';

                if (!list || list.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center">조회된 데이터가 없습니다.</td></tr>';
                    // 데이터가 없을 때도 페이지네이션은 초기화
                    document.getElementById('pagination-ul').innerHTML = '';
                    return; // 데이터가 없으면 아래 페이지네이션 로직을 실행할 필요 없음
                }

                list.forEach(item => {

                    try{


                    // 서버에서 '2025-11-09T15:40:39' 와 같은 표준 문자열로 넘어올 것을 기대
                    const formattedReqDttm = item.inDttmReq ? new Date(item.inDttmReq).toLocaleString('ko-KR') : '-';
                    const formattedApprDttm = item.inDttmAppr ? new Date(item.inDttmAppr).toLocaleString('ko-KR') : '-';
                    const actualQty = item.inQty !== null ? item.inQty : '-';

                    // Postman 응답에 statusValue가 있으므로
                    const statusValue = item.statusValue || item.status; // statusValue가 없으면 status를 대신 사용

                    // console.log(item);
                    // console.log(formattedApprDttm)
                    // console.log(formattedReqDttm)
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
                            '<tr onclick="location.href=\'/inbounds/' + item.inReqItemsId + '\'" style="cursor: pointer;">' +
                            '<td>' + item.inReqId + '</td>' +
                            '<td>' + item.inReqItemsId + '</td>' +
                            '<td>' + item.companyName + '</td>' +
                            '<td>' + item.coffeeName + '</td>' +
                            '<td>' + item.coffeeCategory + '</td>' +
                            '<td>' + item.inQtyReq + '</td>' +
                            '<td>' + actualQty + '</td>' +
                            '<td><span class="badge bg-primary">' + statusValue + '</span></td>' +
                            '<td>' + formattedReqDttm + '</td>' +
                            '<td>' + formattedApprDttm + '</td>' +
                            '</tr>';

                    tbody.insertAdjacentHTML('beforeend', row);
                    } catch(e) {
                        // 만약 row를 만드는 과정에서 에러가 발생하면 여기서 잡힙니다.
                        console.error("Error processing item:", item, e);
                    }
                });

                // 2. 페이지네이션(ul) 렌더링
                const paginationUl = document.getElementById('pagination-ul');
                paginationUl.innerHTML = '';

                // 이전 버튼
                if (pageMaker.prev) {
                    // ★★★ onclick 핸들러에 정확한 페이지 번호 전달 ★★★
                    paginationUl.innerHTML += `
                        <li class="page-item">
                            <a class="page-link" href="javascript:void(0);" onclick="loadInboundList(${pageMaker.startPage - 1})">이전</a>
                        </li>
                    `;
                }
                // 페이지 번호 버튼
                for (let i = pageMaker.startPage; i <= pageMaker.endPage; i++) {
                    const activeClass = (i === pageMaker.criteria.page) ? 'active' : '';
                    // JavaScript 변수를 문자열 템플릿에 삽입
                    const pageItemHtml = `
                        <li class="page-item ${activeClass}">
                            <a class="page-link" href="javascript:void(0);" onclick="loadInboundList(${i})">${i}</a>
                        </li>
                    `;
                    paginationUl.innerHTML += pageItemHtml;
                }
                // 다음 버튼
                if (pageMaker.next) {
                    paginationUl.innerHTML += `
                        <li class="page-item">
                            <a class="page-link" href="javascript:void(0);" onclick="loadInboundList(${pageMaker.endPage + 1})">다음</a>
                        </li>
                    `;
                }

            })
            .catch(function (error) {
                console.error('데이터를 불러오는 중 오류 발생:', error);
                const tbody = document.getElementById('inbound-list-body');
                tbody.innerHTML = '<tr><td colspan="6" class="text-center text-danger">데이터를 불러오는 데 실패했습니다.</td></tr>';
            });
    }

    // 문서가 처음 로드될 때 첫 페이지 데이터를 명시적으로 '1'로 호출합니다.
    document.addEventListener('DOMContentLoaded', function () {
        loadInboundList(1);
    });
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>