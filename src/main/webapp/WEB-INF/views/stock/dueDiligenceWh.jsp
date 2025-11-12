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
                <h4 class="card-title">재고 실사 상세 조회</h4>
            </div>
            <div class="card-body">
                <div id="ddDetail" class="mx-auto" style="width: 40rem;">
                    <div class="mb-3">
                        <label class="form-label">재고 ID</label>
                        <input type="text" class="form-control" id="stkId" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">창고 코드</label>
                        <input type="text" class="form-control" id="whCode" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">보관 위치</label>
                        <input type="text" class="form-control" id="location" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">시스템 재고</label>
                        <input type="number" class="form-control" id="stkQuantity" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">실제 재고</label>
                        <input type="text" class="form-control" id="realStkQuantity" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">실사 일자</label>
                        <input type="text" class="form-control" id="ddDate" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">담당자</label>
                        <input type="text" class="form-control" id="maId" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">특이사항</label>
                        <input type="text" class="form-control" id="ddLog" readonly>
                    </div>
                </div>

            </div>

            <div class="card-footer d-flex justify-content-center align-items-center">
                <!-- 창고관리자 -->
                <button class="btn btn-outline-primary me-2" id="btnEdit">수정하기</button>
                <button class="btn btn-outline-danger me-2" id="btnDelete">삭제하기</button>
                <!-- 총관리자 -->
                <!-- <button class="btn btn-outline-success me-2" id="btnApprove">승인하기</button>
                <button class="btn btn-outline-warning me-2" id="btnReject">거부하기</button> -->
                <!-- 공통 -->
                <button class="btn btn-outline-dark" id="btnList">리스트로</button>

            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/includes/_footerHead.jsp"%>
document.addEventListener("DOMContentLoaded", async () => {
const ddId =  window.location.pathname.split("/").pop(); // URL에서 ddId 추출
const btnEdit = document.getElementById("btnEdit");
const btnList = document.getElementById("btnList");
const btnDelete = document.getElementById("btnDelete");
const btnApprove = document.getElementById("btnApprove");
const btnReject = document.getElementById("btnReject");

function formatDate(data) {
if (!data || !Array.isArray(data)) return '-';
const yyyy = data[0];
const mm = ('0' + data[1]).slice(-2);
const dd = ('0' + data[2]).slice(-2);
const hh = ('0' + data[3]).slice(-2);
const mi = ('0' + data[4]).slice(-2);
const ss = ('0' + data[5]).slice(-2);
return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi + ':' + ss;
}


try {
const response1 = await axios.get("/api/dueDiligences/"+ddId);
const dto1 = response1.data;

document.getElementById("stkId").value = dto1.stkId || "-";
document.getElementById("whCode").value = dto1.whCode || "-";
document.getElementById("location").value =
(dto1.zoneName + "존 " + dto1.rackName + "렉 " + dto1.cellName + "셀") || "-";
document.getElementById("stkQuantity").value = dto1.stkQuantity || "-";
document.getElementById("realStkQuantity").value = dto1.realStkQuantity || "-";
document.getElementById("ddDate").value = formatDate(dto1.ddDate) || "-";
document.getElementById("maId").value = dto1.maId || "-";
document.getElementById("ddLog").value = dto1.ddLog || "-";

}catch(error) {
console.error(error);
alert("실사 정보를 불러오지 못했습니다.");
// window.location.href = "/dueDiligences";
}

//수정하기 버튼
btnEdit.addEventListener("click", async () => {
try{
const response2 = await axios.get("/api/dueDiligences/"+ddId+"/update");
const dto2 = response2.data;

document.getElementById("stkId").value = dto2.stkId || "-";
document.getElementById("whCode").value = dto2.whCode || "-";
document.getElementById("location").value =
(dto2.zoneName + "존 " + dto2.rackName + "렉 " + dto2.cellName + "셀") || "-";
document.getElementById("stkQuantity").value = dto2.stkQuantity || "-";
document.getElementById("realStkQuantity").value = dto2.realStkQuantity || "-";
document.getElementById("ddDate").value = formatDate(dto2.ddDate) || "-";
document.getElementById("maId").value = dto2.maId || "-";
document.getElementById("ddLog").value = dto2.ddLog || "-";
}catch(error){
console.error(error);
alert("수정하려는 정보를 불러오지 못했습니다.");
//  window.location.href = "/dueDiligences/"+ddId;
}


document.getElementById("realStkQuantity").removeAttribute("readonly");
document.getElementById("ddLog").removeAttribute("readonly");

// 수정 버튼 숨기기
btnEdit.style.display = "none";
btnDelete.style.display = "none";

// 확인 버튼 추가
const btnConfirm = document.createElement("button");
btnConfirm.textContent = "확인";
btnConfirm.className = "btn btn-outline-success me-2";
btnConfirm.id = "btnConfirm";

btnEdit.parentNode.insertBefore(btnConfirm, btnList);


// 확인 버튼 클릭 이벤트
btnConfirm.addEventListener("click", async() => {
const rsq = document.getElementById("realStkQuantity").value;
if( rsq === ""){
    alert("실제 재고를 입력해주셔야 합니다.");
    return;
}else if( Number(rsq) < 0) {
    alert("실제 재고는 0 이하일 수 없습니다.");
    return;
}

const updatedData = {
stkQuantity: document.getElementById("stkQuantity").value,
realStkQuantity: document.getElementById("realStkQuantity").value,
ddLog: document.getElementById("ddLog").value,
whCode: document.getElementById("whCode").value,
maId : "manager_kim"
//로그인한 아이디 바꿔주면서 test
};



try {
const resp = await axios.put("/api/dueDiligences/"+ddId+"/update", updatedData);
    if(resp.data === -1){alert("권한이 없습니다."); return;}
    alert("수정이 완료되었습니다.");
    location.reload();
} catch (error) {
    console.error(error);
    alert("수정 중 오류가 발생했습니다.");
}
});
});

//삭제하기 버튼
btnDelete.addEventListener("click", async () => {
if (confirm("정말 삭제하시겠습니까?")) {
const deleteData = {
maId : "manager_kim"
// maId : (현재 로그인한 아이디처리)
};

try {
const resp = await axios.put("/api/dueDiligences/"+ddId, deleteData);
if(resp.data === -1){alert("권한이 없습니다."); return;}
alert("삭제가 완료되었습니다.");
window.location.href = "/dueDiligences";
} catch (error) {
console.error(error);
alert("삭제 중 오류가 발생했습니다.");
}
}
});

// ⚫ 리스트로 버튼
btnList.addEventListener("click", () => {
window.location.href = "/dueDiligences";
});

});
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>