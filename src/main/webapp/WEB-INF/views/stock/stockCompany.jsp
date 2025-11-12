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
                <h4 class="card-title">거래처 현황</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table
                            id="basic-datatables"
                            class="display table table-striped table-hover"
                    >
                        <thead>
                        <tr>
                            <th>거래처명</th>
                            <th>사업자등록번호</th>
                            <th>이메일</th>
                            <th>연락처</th>
                            <th>계약시작일</th>
                            <th>계약종료일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- 여기에 db에서 가져온 data 뿌림 -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- 페이지네이션 -->
            <div
                    class="card-footer d-flex justify-content-end align-items-center"
            >
                <!-- <button class="btn btn-black">등록하기</button> -->

                <ul class="pagination pg-primary mb-0"></ul>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/includes/_footerHead.jsp"%>
let table;

$(document).ready(function () {
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
{ data: 'comName' },
{ data: 'comCode' },
{ data: 'comEmail' },
{ data: 'comPhone' },
{ data: 'comStartDate' ,
render: function(data, type, row) {
if(!data) return '';
const date = new Date(data);
const yyyy = date.getFullYear();
const mm = ('0' + (date.getMonth() + 1)).slice(-2);
const dd = ('0' + date.getDate()).slice(-2);
return yyyy+"-"+mm+"-"+dd;
}},
{ data: 'comExpiredDate',
render: function(data, type, row) {
if(!data) return '';
const date = new Date(data);
const yyyy = date.getFullYear();
const mm = ('0' + (date.getMonth() + 1)).slice(-2);
const dd = ('0' + date.getDate()).slice(-2);
return yyyy+"-"+mm+"-"+dd;
}},
],
});
clickPageNum(1); //첫페이지 자동 로드
});

window.clickPageNum = function (page = 1) {
const myUrl = '/api/stocks/company?pageNum=' + page + '&amount=10';
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
};
}
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>
