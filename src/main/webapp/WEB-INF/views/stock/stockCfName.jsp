<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
.select-filter {
width: 50%;
margin: 1rem auto;
}

.custom-nav {
border-bottom: 2px solid #000; /* 전체 하단 검은 선 */
padding-bottom: 0;
}

.custom-nav .nav-link {
color: #111;
font-size: 1.1rem;
font-weight: 500;
padding: 0.8rem 2rem;
position: relative;
text-align: center;
}

.custom-nav .nav-link:hover {
color: #000;
}

.custom-nav .nav-link.active {
font-weight: 600;
}

.custom-nav .nav-link.active::after {
content: "";
position: absolute;
bottom: -2px;
left: 0;
right: 0;
height: 3px;
background-color: #000;
}
<%@include file="/WEB-INF/views/includes/_headerNav.jsp"%>
<nav
        class="navbar navbar-expand-lg navbar-dark mb-4 py-2 custom-nav"
>
    <div class="container-fluid">
        <button
                class="navbar-toggler ms-auto"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#newNavbar"
                aria-controls="newNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation"
        >
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="newNavbar">
            <ul
                    class="navbar-nav w-100 nav-justified mb-2 mb-lg-0"
            >
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/stocks">재고 조회</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/stocks/warehouse">창고 현황</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/stocks/company">거래처 현황</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/dueDiligences">재고 실사</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title"  id="pageTitle"></h4>
                <!-- 여기서 커피이름 가져와야함 -->
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-end"><button class="btn btn-black" onclick="showCoffeeDetail()">커피 상세 정보</button></div>
                <div class="table-responsive">
                    <table
                            id="basic-datatables"
                            class="display table table-striped table-hover"
                    >
                        <thead>
                        <tr>
                            <th>재고ID</th>
                            <th>창고코드</th>
                            <th>창고이름</th>
                            <th>보관위치</th>
                            <th>수량</th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- 여기에 db에서 가져온 data 뿌림 -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- 페이지네이션 -->
            <div class="card-footer d-flex justify-content-between align-items-center">
                <button class="btn btn-primary" onclick = "returnToBack()">이전으로</button>

                <ul class="pagination pg-primary mb-0">

                </ul>
            </div>
        </div>
    </div>
</div>
<!-- 커피 상세 정보 모달 -->
<div class="modal fade" id="coffeeDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="coffeeTitle"></h5>
                <!-- 여기도 cfName 들어가야함 -->
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>

            <div class="modal-body">
                <table class="table table-bordered">
                    <tbody>
                    <tr>
                        <th style="width: 25%">커피ID</th>
                        <td id="coffeeId"></td>
                    </tr>
                    <tr>
                        <th>원산지</th>
                        <td id="coffeeAddress"></td>
                    </tr>
                    <tr>
                        <th>카테고리</th>
                        <td id="coffeeCategory"></td>
                    </tr>
                    <tr>
                        <th>등급</th>
                        <td id="coffeeGrade"></td>
                    </tr>
                    <tr>
                        <th>품종</th>
                        <td id="coffeeType"></td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/includes/_footerHead.jsp"%>
let table;

$(document).ready(function () {
const cfName = decodeURIComponent(
window.location.pathname.split('/').pop()
);
$('#pageTitle').text(cfName + ' 재고 조회');

table = $('#basic-datatables').DataTable({
paging: false, // 페이지 넘김 유지할 거면 true
lengthChange: false, // "Show entries" 제거
searching: false, // "Search" 제거
info: false, // "Showing 1 to N of N entries" 제거
ordering: true, // 정렬 기능 유지 (원하면 false)

language: {
emptyTable: '', // "No data available in table" 문구 제거
zeroRecords: '',
},

columns: [
{ data: 'stkId' },
{ data: 'whCode' },
{ data: 'whName' },
{
data: null,
render: function (data) {
const { zoneName, rackName, cellName } = data;
return zoneName + '존 ' + rackName + '렉 ' + cellName + '셀';
},
},
{ data: 'stkQuantity' },
],
});
clickPageNum(1); //첫페이지 자동 로드
});

window.clickPageNum = function (page = 1) {
const cfName = decodeURIComponent(
window.location.pathname.split('/').pop()
);

const myUrl = "/api/stocks/"+cfName+"/?pageNum=" + page + "&amount=10"
$.ajax({
url: myUrl,
type: 'GET',
dataType: 'json',
success: function (response) {
table.clear();

table.rows.add(response.list);
table.draw();

renderPagination(response.pageDTO);
},
error: function (xhr, status, error) {
console.error('데이터 조회 실패:', error);
alert('데이터를 불러오는 중 오류가 발생했습니다.');
},
});
};

window.renderPagination = function (pageDTO) {
const $pagination = $('.pagination');

// pageDTO가 없거나 total이 0이면 숨기기
if (!pageDTO || pageDTO.total <= pageDTO.cri.amount) {
$pagination.addClass('d-none');
return;
}

$pagination.removeClass('d-none');
$pagination.empty();

const { startPage, endPage, prev, next, cri } = pageDTO;
const currentPage = cri.pageNum;

if (prev) {
$pagination.append('<li class="page-item">'
+ '<a class="page-link" onclick="clickPageNum(' + (startPage - 1) + ')">&laquo;</a>'
+ '</li>'
);
}

// 페이지 번호 버튼
for (let i = startPage; i <= endPage; i++) {
const activeClass = (i === currentPage) ? "active" : "";
$pagination.append('<li class="page-item ' + activeClass + '">'
+ '<a class="page-link" onclick="clickPageNum(' + i + ')">' + i + '</a>'
+ '</li>');
}

// Next 버튼
if (next) {
$pagination.append(
'<li class="page-item">'
+ '<a class="page-link" onclick="clickPageNum(' + (endPage + 1) + ')">&raquo;</a>'
+ '</li>'
);
}
}

window.showCoffeeDetail = function () {
const cfName = decodeURIComponent(
window.location.pathname.split('/').pop()
);

$.ajax({
url: '/api/stocks/coffee/'+ cfName,
type: 'GET',
dataType: 'json',
success: function (coffeeDTO) {
// 모달에 데이터 채우기
$('#coffeeTitle').text(coffeeDTO.cfName || '-');
$('#coffeeId').text(coffeeDTO.cfId || '-');
$('#coffeeAddress').text(coffeeDTO.cfOrigin || '-');
$('#coffeeCategory').text(coffeeDTO.cfCategory || '-');
$('#coffeeGrade').text(coffeeDTO.cfGrade || '-');
$('#coffeeType').text(coffeeDTO.cfType || '-');

// 모달 표시
const modal = new bootstrap.Modal(
document.getElementById('coffeeDetailModal')
);
modal.show();
},
error: function (xhr, status, error) {
console.error('커피 상세정보 불러오기 실패:', error);
alert('커피 상세정보를 불러오는 중 오류가 발생했습니다.');
},
});
};

window.returnToBack = function () {
window.location.href = '/stocks';
};

<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>

