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
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<nav class="navbar navbar-expand-lg navbar-dark mb-4 py-2 custom-nav">
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
            <ul class="navbar-nav w-100 nav-justified mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/warehouses">창고 조회</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/warehouses/map">지도 보기</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title fs-3">창고 조회</h4>
            </div>

            <div class="card-body">
                <!-- 선택하게 체크 박스 둬야함 -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title fs-5">조회 기준을 선택해주세요.</div>
                    </div>
                    <div class="card-body">
                        <div class="card-body">
                            <div
                                    class="type-checkbox d-flex justify-content-around align-items-center"
                            >
                                <div class="form-check">
                                    <input
                                            class="form-check-input"
                                            type="radio"
                                            name="type-warehouselist"
                                            id="radioTotal"
                                            value="total"
                                            checked
                                    />
                                    <label class="form-check-label" for="radioTotal">
                                        전체
                                    </label>
                                </div>

                                <div class="form-check">
                                    <input
                                            class="form-check-input"
                                            type="radio"
                                            name="type-warehouselist"
                                            id="radioAddress"
                                            value="whAddress"
                                    />
                                    <label class="form-check-label" for="radioAddress">
                                        소재지별
                                    </label>
                                </div>

                                <div class="form-check">
                                    <input
                                            class="form-check-input"
                                            type="radio"
                                            name="type-warehouselist"
                                            id="radioGrade"
                                            value="whGrade"
                                    />
                                    <label class="form-check-label" for="radioGrade">
                                        창고등급별
                                    </label>
                                </div>

                                <div class="form-check">
                                    <input
                                            class="form-check-input"
                                            type="radio"
                                            name="type-warehouselist"
                                            id="radioName"
                                            value="whName"
                                    />
                                    <label class="form-check-label" for="radioName">
                                        창고명별
                                    </label>
                                </div>
                            </div>

                            <select
                                    class="form-select select-filter mt-3 d-none"
                                    aria-label="Default select example"
                                    id="selectInputWrapper"
                            ></select>

                            <div class="d-flex justify-content-end mt-3">
                                <button
                                        id="selectListBtn"
                                        onclick="submitListBtn()"
                                        class="btn btn-primary"
                                >
                                    조회
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-footer">
                <div class="table-responsive">
                    <table
                            id="basic-datatables"
                            class="display table table-striped table-hover"
                    >
                        <thead>
                        <tr>
                            <th>No</th>
                            <th>창고이름</th>
                            <th>창고코드</th>
                            <th>창고 등급</th>
                            <th>소재지</th>
                            <th>평수</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <button class="btn btn-black" id="registerBtn">등록하기</button>
                <div class="d-flex justify-content-end align-items-center">
                    <ul class="pagination pg-primary mb-0 d-none"></ul>
                </div>
            </div>
        </div>
        <!-- 등록 모달 -->
        <div class="modal fade" id="createWarehouseModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">창고 등록</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="createWarehouseForm">
                            <div class="mb-3">
                                <label for="createWhCode" class="form-label">창고코드</label>
                                <input type="text" class="form-control" id="createWhCode" name="whCode">
                            </div>
                            <div class="mb-3">
                                <label for="createWhName" class="form-label">창고명</label>
                                <input type="text" class="form-control" id="createWhName" name="whName">
                            </div>
                            <div class="mb-3">
                                <label for="createWhGrade" class="form-label">창고등급</label>
                                <select class="form-select" id="createWhGrade" name="whGrade">
                                    <option value="" selected disabled>창고 등급을 선택하세요</option>
                                    <option value="Main">MAIN</option>
                                    <option value="Sub">SUB</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="createWhAddress" class="form-label">소재지</label>
                                <div class="input-group mb-2">
                                    <input type="text" id="sample6_postcode" class="form-control" placeholder="우편번호" readonly>
                                    <button type="button" class="btn btn-outline-secondary" onclick="sample6_execDaumPostcode()">우편번호 찾기</button>
                                </div>
                                <input type="text" id="sample6_address" class="form-control mb-2" placeholder="기본주소" readonly>
                                <input type="text" id="sample6_detailAddress" class="form-control mb-2" placeholder="상세주소 입력">

                                <input type="hidden" id="createWhAddress" name="whAddress">
                            </div>
                            <div class="mb-3">
                                <label for="createWhField" class="form-label">평수</label>
                                <select class="form-select" id="createWhField" name="whField">
                                    <option value="" selected disabled>평수를 선택하세요</option>

                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="createWhTotalCapa" class="form-label">최대수용용량</label>
                                <input type="number" class="form-control" id="createWhTotalCapa" name="whTotalCapa" value="1000" step="100" min="300" >
                            </div>
                            <div class="mb-3">
                                <label for="createWhTelephone" class="form-label">창고 전화번호</label>
                                <input type="tel" class="form-control" id="createWhTelephone" name="whTelephone">
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-primary" id="saveCreateWarehouseBtn">등록</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 상세/수정 모달 -->
        <div class="modal fade" id="detailWarehouseModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">창고 상세조회</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="detailWarehouseForm">
                            <div class="mb-3">
                                <label for="detailWhName" class="form-label">창고명</label>
                                <input type="text" class="form-control" id="detailWhName" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhCode" class="form-label">창고코드</label>
                                <input type="text" class="form-control" id="detailWhCode" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhGrade" class="form-label">창고등급</label>
                                <input type="text" class="form-control" id="detailWhGrade" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhAddress" class="form-label">소재지</label>
                                <input type="text" class="form-control" id="detailWhAddress" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhField" class="form-label">평수</label>
                                <select class="form-select" id="detailWhField" disabled>
                                    <!-- <option value="" selected disabled>평수를 선택하세요</option>
                                    <option value="100">100평</option>
                                    <option value="200">200평</option>
                                    <option value="300">300평</option>
                                    <option value="500">500평 이상</option> -->
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhTelephone" class="form-label">창고 전화번호</label>
                                <input type="tel" class="form-control" id="detailWhTelephone" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhTotalCapa" class="form-label">최대수용용량</label>
                                <input type="text" class="form-control" id="detailWhTotalCapa" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="detailWhUseCapa" class="form-label">현재수용용량</label>
                                <input type="text" class="form-control" id="detailWhUseCapa" readonly>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="updateWarehouseBtn">수정</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    </div>
                </div>
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
{
data: null, // 실제 데이터가 없으므로 null
render: function (data, type, row, meta) {
return meta.row + 1; // 0부터 시작하므로 +1
},
},
{
data: 'whName',
render: function (data, type, row) {
// a 태그에 클래스나 data 속성으로 whName 저장
return (
'<a href="javascript:void(0);" class="wh-detail-link" data-whname="' +data +'">' +data +'</a>'
);
},
},
{ data: 'whCode' },
{ data: 'whGrade' },
{ data: 'whAddress' },
{ data: 'whField' },
],
});

getOptionList();
});

let filterData = {};

window.getOptionList = async function () {
try {
const response = await axios.get('/api/warehouses/search');

if(!response.data){
    alert("관리자만 접근 가능한 페이지입니다.");
    window.location.href="/";
}

filterData.whAddress = response.data.addressList;
filterData.whName = response.data.nameList;
filterData.whGrade = response.data.gradeList;

console.log('가져온 데이터: ', filterData);
} catch (error) {
console.error('데이터 조회 실패:', error);
alert('데이터를 불러오는 중 오류가 발생했습니다.');
}
};


$('input[name="type-warehouselist"]').on('change', function () {
// 2. 선택된 radio 버튼의 'value' 값을 가져옴
var selectedValue = $(this).val();
var $selectBox = $('#selectInputWrapper'); // 검색창 div 캐싱

// 3. 'value'가 'total'인지 확인
if (selectedValue === 'total') {
// 'total'이면 검색창을 숨김
$selectBox.addClass('d-none');
$selectBox.empty();
} else {
//소재지, 창고등급, 창고명 보여줘야함

$selectBox.empty();

$selectBox.append(
'<option selected disabled value="">-- 항목을 선택하세요 --</option>'
);

const optionsList = filterData[selectedValue];

if (optionsList) {
$.each(optionsList, function (index, item) {
let value = '';
if(selectedValue==='whAddress') {value = item.whAddress}
else if(selectedValue==='whGrade') {value = item.whGrade}
else if(selectedValue==='whName') {value = item.whName}

$selectBox.append(
$('<option>', {
value: value,
text: value,
})
);
});
}

$selectBox.removeClass('d-none');
}
});

// 조회 버튼 클릭 시 동작
function submitListBtn(page = 1) {
// 1. 선택된 라디오 버튼 확인
const selectedType = $('input[name="type-warehouselist"]:checked').val();
const selectedValue = $('#selectInputWrapper').val();

let url = '';

//전체일 경우
if (selectedType === 'total') {
url = "/api/warehouses?pageNum="+page+"&amount=5";

//대분류, 중분류, 소분류는 필수 선택 검증
} else {
if (!selectedValue) {
alert('항목을 선택해주세요.');
return;
}

//선택된 기준에 따라 요청 URL 다르게 설정
if (selectedType === 'whAddress') {
url = "/api/warehouses/address/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=5";
} else if (selectedType === 'whGrade') {
url = "/api/warehouses/grade/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=5";
} else if (selectedType === 'whName') {
url = "/api/warehouses/name/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=5";
}
}

$.ajax({
url: url,
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
}

function renderPagination(pageDTO) {
const $pagination = $('.pagination');

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
+ '<a class="page-link" onclick="submitListBtn(' + (startPage - 1) + ')">&laquo;</a>'
+ '</li>');
}

// 페이지 번호 버튼
for (let i = startPage; i <= endPage; i++) {
const activeClass = (i === currentPage) ? "active" : "";
$pagination.append('<li class="page-item ' + activeClass + '">'
+ '<a class="page-link" onclick="submitListBtn(' + i + ')">' + i + '</a>'
+ '</li>');
}

// Next 버튼
if (next) {
$pagination.append(
'<li class="page-item">'
+ '<a class="page-link" onclick="submitListBtn(' + (endPage + 1) + ')">&raquo;</a>'
+ '</li>'
);
}
}

// 등록하기 버튼 클릭
$(document).on("click", "#registerBtn", function () {
$("#createWarehouseForm")[0].reset();
$("#createWarehouseModal").modal("show");
});

$(document).on("click", "#saveCreateWarehouseBtn", function() {
const data = {
whName: $("#createWhName").val(),
whCode: $("#createWhCode").val(),
whGrade: $("#createWhGrade").val(),
whAddress: $("#createWhAddress").val(),
whField: $("#createWhField").val(),
whTotalCapa: $("#createWhTotalCapa").val(),
whTelephone: $("#createWhTelephone").val()
};

if(data.whName === '' || data.whName === null) {
alert("창고이름은 필수 입력입니다.");
return;
}
if(data.whCode === '' || data.whCode === null) {
alert("창고코드는 필수 입력입니다.");
return;
}
if(data.whGrade === '' || data.whGrade === null) {
alert("창고 등급을 선택해주세요.");
return;
}
if(data.whAddress === '' || data.whAddress === null) {
alert("창고주소는 필수 입력입니다.");
return;
}
if(data.whField === '' || data.whField === null) {
alert("창고 평수를 선택해주세요.");
return;
}
if(data.whTotalCapa === '' || data.whTotalCapa === null) {
alert("창고 최대수용용량을 선택해주세요.");
return;
}

const whTotalCapa = Number(data.whTotalCapa);

// whGrade 기준 유효성 검사
if (data.whGrade === 'Main' && whTotalCapa < 1000) {
alert("메인 창고의 최대수용용량은 1000 이상이어야 합니다.");
return;
}

if (data.whGrade === 'Sub' && whTotalCapa < 300) {
alert("서브 창고의 최대수용용량은 300 이상이어야 합니다.");
return;
}

axios.post("/api/warehouse", data).then(
(response) => {
if(response.data === -1) {
    alert("창고 등록 권한이 없습니다.");
    return;
}

alert("창고가 등록되었습니다.");
$("#createWarehouseModal").modal("hide");
window.location.href = "/warehouses";
})
.catch(error => {
console.log("등록 실패: ", error);
alert("창고 등록 중 오류가 발생했습니다.");
});
});

// 창고명 클릭 시 상세 모달 열기
$(document).on("click", ".wh-detail-link", function () {
const whName = $(this).data("whname");

axios.get("/api/warehouses/" + encodeURIComponent(whName))
.then(response => {
const data = response.data;
$("#detailWhName").val(data.whName);
$("#detailWhCode").val(data.whCode);
$("#detailWhGrade").val(data.whGrade);
$("#detailWhAddress").val(data.whAddress);
$("#detailWhTotalCapa").val(data.whTotalCapa);
$("#detailWhUseCapa").val(data.whUseCapa);
$("#detailWhTelephone").val(data.whTelephone);

const $fieldSelect = $("#detailWhField");
$fieldSelect.empty(); // 기존 옵션 제거
$fieldSelect.append(
'<option value="' + data.whField + '" selected>' + data.whField + '평</option>'
);

$("#detailWarehouseModal").modal("show");
})
.catch(error => {
console.error("상세 조회 실패:", error);
alert("창고 정보를 불러오지 못했습니다.");
});
});

// 수정 버튼 클릭
$(document).on("click", "#updateWarehouseBtn", function () {
document.getElementById("detailWhName").removeAttribute("readonly");
document.getElementById("detailWhTelephone").removeAttribute("readonly");
document.getElementById("detailWhField").removeAttribute("disabled");

const updateBtn = document.getElementById("updateWarehouseBtn");
updateBtn.style.display = "none";

const btnClose = document.getElementById("closeBtn");
// 확인 버튼 추가
const btnConfirm = document.createElement("button");
btnConfirm.textContent = "확인";
btnConfirm.className = "btn btn-outline-success me-2";
btnConfirm.id = "btnConfirm";

updateBtn.parentNode.insertBefore(btnConfirm, btnClose);

const selectWhField = document.getElementById("detailWhField");
selectWhField.innerHTML="";

const defaultOption = document.createElement("option");  //선택하기 default
defaultOption.value = "";
defaultOption.textContent = "평수를 선택하세요."
selectWhField.appendChild(defaultOption);

const whFieldList = [3000,5000,8000];
// 데이터 채워넣기

whFieldList.forEach(wh => {
const option = document.createElement("option");

option.value = wh;
option.textContent = wh;
selectWhField.appendChild(option);
});

btnConfirm.addEventListener("click", async() => {
const updateData = {
whName: $("#detailWhName").val(),
whField: $("#detailWhField").val(),
whTelephone: $("#detailWhTelephone").val()
};
const getWhCode = document.getElementById("detailWhCode").value;

if(updateData.whName === '' || updateData.whName === null) {
alert("창고이름은 필수 입력입니다.");
return;
}
if(updateData.whField==='' || updateData.whField===null){
alert("창고평수는 필수 선택입니다.");
return;
}

try{
const response = await axios.put("/api/warehouses/" + getWhCode+"/update", updateData);

if(response.data === -1) {alert("수정 권한이 없습니다."); return;}
alert("창고 정보가 수정되었습니다.");
$("#detailWarehouseModal").modal("hide");
location.reload();

}catch(error) {
console.error("수정 실패:", error);
alert("수정 중 오류가 발생했습니다.");
location.reload();
}
});
});

// 창고등급 선택 시 평수 옵션 자동 변경
$(document).on("change", "#createWhGrade", function() {
const selectedGrade = $(this).val();
const $fieldSelect = $("#createWhField");

// 기존 옵션 초기화
$fieldSelect.empty();

// 기본 안내 option 추가
$fieldSelect.append('<option value="" selected disabled>평수를 선택하세요</option>');

let fieldOptions = [];

if (selectedGrade === "Main") {
fieldOptions = [3000, 5000, 8000];
} else if (selectedGrade === "Sub") {
fieldOptions = [1000, 2000, 3000];
}

// 옵션 채우기
fieldOptions.forEach(field => {
$fieldSelect.append(
$("<option>", {
value: field,
text: field + "평"
})
);
});
});

//도로명 주소 api
window.sample6_execDaumPostcode = function (){
new daum.Postcode({
oncomplete: function(data) {
var addr = ''; // 주소
if (data.userSelectedType === 'R') {
addr = data.roadAddress;
} else {
addr = data.jibunAddress;
}

// 기본 주소 입력
document.getElementById('sample6_address').value = addr;
document.getElementById('sample6_detailAddress').focus();

// 기본 주소만 먼저 createWhAddress에 넣기
document.getElementById('createWhAddress').value = addr;
}
}).open();

}

// 상세주소 입력 후 전체 주소 자동 결합
document.getElementById('sample6_detailAddress').addEventListener('input', function() {
const baseAddr = document.getElementById('sample6_address').value;
const detail = this.value;
const full = baseAddr + (detail ? ' ' + detail : '');
document.getElementById('createWhAddress').value = full;
});

// 상세 모달 닫힐 때 초기화
$("#detailWarehouseModal").on("hidden.bs.modal", function () {
// 1. 모든 입력 필드 다시 readonly / disabled 처리
$("#detailWhName").attr("readonly", true);
$("#detailWhTelephone").attr("readonly", true);
$("#detailWhField").attr("disabled", true);

// 2. "확인" 버튼 제거 (존재할 경우)
$("#btnConfirm").remove();

// 3. "수정" 버튼 다시 표시
$("#updateWarehouseBtn").show();

// 4. 선택 박스 초기화
const $fieldSelect = $("#detailWhField");
$fieldSelect.empty();
$fieldSelect.append('<option value="" selected disabled>평수를 선택하세요</option>');
});
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>

