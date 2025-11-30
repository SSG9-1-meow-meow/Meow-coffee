<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- 메인 컨텐츠 시작 -->
<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
  <div>
    <h3 class="fw-bold mb-3">출고 관리 목록</h3>
  </div>
  <div class="ms-md-auto mt-2 mt-md-0">
    <c:if test="${sessionRole eq 'COMPANY'}">
      <a href="${pageContext.request.contextPath}/outbounds/req" class="btn btn-primary">
        <i class="fa fa-plus"></i> 신규 출고 요청
      </a>
    </c:if>
  </div>
</div>

<div class="row">
  <div class="col-md-12">
    <div class="card">
      <div class="card-header">
        <!-- 검색/필터 UI -->
        <div class="d-flex align-items-center">
          <h4 class="card-title">출고 목록 필터</h4>
          <button class="btn btn-primary btn-round ms-auto" id="searchBtn">
            <i class="fa fa-search"></i> 검색
          </button>
        </div>

        <div class="row mt-3 gy-2">
          <div class="col-md-3">
            <div class="form-group">
              <label for="companyName">거래처명</label>
              <input type="text" class="form-control" id="companyName" placeholder="거래처명 입력">
            </div>
          </div>

          <div class="col-md-3">
            <div class="form-group">
              <label for="outStatus">상태</label>
              <select class="form-select" id="outStatus">
                <option value="">전체</option>
                <option value="REQUESTED">승인대기</option>
                <option value="APPROVED">승인완료</option>
                <option value="SHIPPED">출고완료</option>
                <option value="CANCELLED">반려</option>
              </select>
            </div>
          </div>

          <div class="col-md-2">
            <div class="form-group">
              <label for="dateFrom">시작일</label>
              <input type="date" class="form-control" id="dateFrom">
            </div>
          </div>

          <div class="col-md-2">
            <div class="form-group">
              <label for="dateTo">종료일</label>
              <input type="date" class="form-control" id="dateTo">
            </div>
          </div>

          <div class="col-md-2">
            <div class="form-group">
              <label for="sortBy">정렬 기준</label>
              <select class="form-select" id="sortBy">
                <option value="createdAt,DESC">요청일 (최신순)</option>
                <option value="comName,ASC">거래처 (가나다순)</option>
                <option value="outDateWish,ASC">희망일 (빠른순)</option>
              </select>
            </div>
          </div>
        </div>
        <%-- 필터 끝 --%>
      </div>

      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-striped mt-3">
            <thead>
            <tr>
              <th>요청ID</th>
              <th>거래처</th>
              <th>희망일</th>
              <th>상태</th>
              <th>승인일시</th>
              <th>요청일시</th>
              <th>임시</th>
              <th>삭제</th>
            </tr>
            </thead>
            <tbody id="outbound-list-body"><!-- JS로 채움 --></tbody>
          </table>
        </div>

        <!-- 페이지네이션 (단순형) -->
        <nav>
          <ul class="pagination justify-content-center" id="pagination-ul"></ul>
        </nav>
      </div>
    </div>
  </div>
</div>
<!-- 메인 컨텐츠 종료 -->

<script>
  var sessionRole   = '${sessionRole}';
  var sessionUserId = '${sessionUserId}';

  var ctx = '${pageContext.request.contextPath}';
  var apiUrl = ctx + '/outbounds/api';

  var currentCriteria = {
    page: 1,
    size: 10,
    comName: '',
    status: '',
    dateFrom: '',
    dateTo: '',
    sort: 'createdAt,DESC'
  };

  function toKDate(value, withTime){
    if(!value) return '-';
    try{
      var d;
      if (Object.prototype.toString.call(value) === '[object Array]'){
        var y=value[0], m=value[1], dd=value[2], hh=value[3]||0, mi=value[4]||0, ss=value[5]||0;
        d = new Date(y, m-1, dd, hh, mi, ss);
      } else {
        d = new Date(value);
      }
      return withTime ? d.toLocaleString('ko-KR') : d.toLocaleDateString('ko-KR');
    }catch(e){ return '-'; }
  }

  function statusBadge(code){
    switch(code){
      case 'REQUESTED':   return 'bg-warning text-dark';
      case 'APPROVED':    return 'bg-primary';
      case 'INSPECTING':  return 'bg-secondary';
      case 'SHIPPED':     return 'bg-success';
      case 'CANCELLED':   return 'bg-danger';
      default:            return 'bg-light text-dark';
    }
  }

  function renderTable(list){
    var tbody = document.getElementById('outbound-list-body');
    tbody.innerHTML = '';

    if (!list || list.length === 0){
      tbody.innerHTML = '<tr><td colspan="8" class="text-center">조회된 데이터가 없습니다.</td></tr>';
      return;
    }

    for (var i=0; i<list.length; i++){
      var item = list[i];

      // 🔸 거래처는 자기 출고건만 보이게 필터링
      if (sessionRole === 'COMPANY') {
        // 백엔드에서 내려주는 필드명에 맞춰서 comId 사용
        if (item.comId !== sessionUserId) {
          continue;   // 내 게 아니면 건너뛰기
        }
      }

      var id    = item.outReqId;
      var com   = (item.comName ? item.comName : (item.comId ? item.comId : '-'));
      var wish  = toKDate(item.outDateWish, false);
      var appr  = toKDate(item.outDttmAppr, true);
      var created = toKDate(item.createdAt, true);

      var code  = item.status ? item.status : 'REQUESTED';
      var badge = statusBadge(code);
      var statusValue = item.statusValue ? '<small class="ms-1 text-muted">'+ item.statusValue +'</small>' : '';

      var tempo = (item.isTempo ? '<i class="fas fa-save text-primary" data-bs-toggle="tooltip" title="임시저장"></i>' : '');
      var del   = (item.isDelete ? '<i class="fas fa-trash text-danger" data-bs-toggle="tooltip" title="삭제됨(소프트)"></i>' : '');

      var row  = '';
      row += '<tr onclick="location.href=\'' + ctx + '/outbounds/' + id + '\'" style="cursor:pointer;">';
      row +=   '<td>' + (id != null ? id : '-') + '</td>';
      row +=   '<td>' + com + '</td>';
      row +=   '<td>' + wish + '</td>';
      row +=   '<td><span class="badge ' + badge + '">' + code + '</span>' + statusValue + '</td>';
      row +=   '<td>' + appr + '</td>';
      row +=   '<td>' + created + '</td>';
      row +=   '<td>' + tempo + '</td>';
      row +=   '<td>' + del + '</td>';
      row += '</tr>';

      tbody.insertAdjacentHTML('beforeend', row);
    }

    try{
      var t = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
      t.map(function(el){ return new bootstrap.Tooltip(el); });
    }catch(e){}
  }

  function renderPagination(pm){
    var ul = document.getElementById('pagination-ul');
    ul.innerHTML = '';
    if(!pm) return;

    // 이전
    if (pm.prev) {
      ul.insertAdjacentHTML('beforeend',
              '<li class="page-item"><a class="page-link" href="javascript:void(0);" onclick="goToPage('+(pm.startPage-1)+')">이전</a></li>');
    }
    // 번호
    for (var p = pm.startPage; p <= pm.endPage; p++) {
      var active = (p === pm.criteria.page) ? ' active' : '';
      ul.insertAdjacentHTML('beforeend',
              '<li class="page-item'+active+'"><a class="page-link" href="javascript:void(0);" onclick="goToPage('+p+')">'+p+'</a></li>');
    }
    // 다음
    if (pm.next) {
      ul.insertAdjacentHTML('beforeend',
              '<li class="page-item"><a class="page-link" href="javascript:void(0);" onclick="goToPage('+(pm.endPage+1)+')">다음</a></li>');
    }
  }

  function goToPage(page){
    currentCriteria.page = page;
    loadOutboundList();
  }

  function loadOutboundList(){
    var params = {
      comName:  currentCriteria.comName,
      status:   currentCriteria.status,
      dateFrom: currentCriteria.dateFrom,
      dateTo:   currentCriteria.dateTo,
      page:     currentCriteria.page,                 // 추가
      size:     currentCriteria.size || 10,           //  추가
      sort:     currentCriteria.sort || 'createdAt,DESC' // 필요시
    };

    axios.get(apiUrl, { params })
            .then(function(res){
              // 응답이 { list: [...], pageMaker: {...} } 형태라고 가정
              var body = res.data;
              var list = body.list || [];
              renderTable(list);
              renderPagination(body.pageMaker);  //  pageMaker 사용
            })
            .catch(function(err){
              console.error(err);
              var tbody = document.getElementById('outbound-list-body');
              var http = (err && err.response && err.response.status) ? err.response.status : 500;
              tbody.innerHTML = '<tr><td colspan="8" class="text-danger">API 오류: HTTP ' + http + '</td></tr>';
            });
  }

  function search(){
    currentCriteria.comName  = document.getElementById('companyName').value || '';
    currentCriteria.status   = document.getElementById('outStatus').value || '';
    currentCriteria.dateFrom = document.getElementById('dateFrom').value || '';
    currentCriteria.dateTo   = document.getElementById('dateTo').value || '';
    currentCriteria.sort     = document.getElementById('sortBy').value || 'createdAt,DESC';
    currentCriteria.page     = 1;
    loadOutboundList();
  }

  document.addEventListener('DOMContentLoaded', function(){
    document.getElementById('searchBtn').addEventListener('click', search);
    document.getElementById('companyName').addEventListener('keyup', function(e){ if(e.key==='Enter') search(); });
    document.getElementById('outStatus').addEventListener('change', search);
    document.getElementById('dateFrom').addEventListener('change', search);
    document.getElementById('dateTo').addEventListener('change', search);
    document.getElementById('sortBy').addEventListener('change', search);
    loadOutboundList();
  });
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
