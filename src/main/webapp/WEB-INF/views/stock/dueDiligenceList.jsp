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
                <h4 class="card-title">재고 실사 현황</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table
                            id="basic-datatables"
                            class="display table table-striped table-hover"
                    >
                        <thead>
                        <tr>
                            <th>실사ID</th>
                            <th>창고코드</th>
                            <th>재고ID</th>
                            <th>일치여부</th>
                            <th>승인여부</th>
                            <th>실사일자</th>
                            <th>수정일자</th>
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
                <button class="btn btn-outline-dark" onclick = "addDueDiligence()">등록하기</button>

                <ul class="pagination pg-primary mb-0">

                </ul>
            </div>
        </div>
        <div class="modal fade" id="dueDiligenceModal" tabindex="-1" aria-labelledby="dueDiligenceModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="dueDiligenceModalLabel">재고 실사 등록</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <form id="dueDiligenceForm">
                            <div class="mb-3">
                                <label class="form-label">창고코드</label>
                                <select class="form-select" id="whCode">
                                    <!-- 여기서 창고코드 axios로 가져와야함 -->
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">재고ID</label>
                                <div class="d-flex">
                                    <input type="text" class="form-control me-2" id="stkId" placeholder="Enter Input">
                                    <button type="button" class="btn btn-outline-secondary" id="btnCheckStock">시스템 재고 조회</button>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">시스템 재고</label>
                                <input type="text" class="form-control" id="systemStock" placeholder="조회 시 재고가 표시됩니다" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">실제 재고</label>
                                <input type="number" class="form-control" id="realStock" placeholder="Enter Input" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">특이사항</label>
                                <input type="text" class="form-control" id="ddLog" placeholder="Enter Input" readonly>
                            </div>
                        </form>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="btnRegister">등록하기</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
    </div>
</div>
<%@include file="/WEB-INF/views/includes/_footerHead.jsp"%>
        let table;

        $(document).ready(function () {
        table = $("#basic-datatables").DataTable({
        paging: false,         // 페이지 넘김 유지할 거면 true
        lengthChange: false,  // "Show entries" 제거
        searching: false,     // "Search" 제거
        info: false,          // "Showing 1 to N of N entries" 제거
        ordering: true,       // 정렬 기능 유지 (원하면 false)

        language: {
        emptyTable: "", // "No data available in table" 문구 제거
        zeroRecords: "",
        },

        columns: [
        { data: "ddId",
        render: function (data, type, row) {
        return '<a href="/dueDiligences/' + row.ddId + '" class="text-primary text-decoration-underline">' + data + '</a>';
        }},
        {data: "whCode"},
        { data: "stkId" },
        { data: "ddStatus" },
        { data: "ddApproval" },
        { data: "ddDate",
        render: function (data) {
        if (!data || !Array.isArray(data)) return '-';
        const yyyy = data[0];
        const mm = ('0' + data[1]).slice(-2);
        const dd = ('0' + data[2]).slice(-2);
        const hh = ('0' + data[3]).slice(-2);
        const mi = ('0' + data[4]).slice(-2);
        const ss = ('0' + data[5]).slice(-2);
        return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi + ':' + ss;
        } },
        { data: "ddUpdateDate" ,
        render: function (data) {
        if (!data || !Array.isArray(data)) return '-';
        const yyyy = data[0];
        const mm = ('0' + data[1]).slice(-2);
        const dd = ('0' + data[2]).slice(-2);
        const hh = ('0' + data[3]).slice(-2);
        const mi = ('0' + data[4]).slice(-2);
        const ss = ('0' + data[5]).slice(-2);
        return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi + ':' + ss;
        }}
        ]
        });
        clickPageNum(1); //첫페이지 자동 로드
        });

        window.clickPageNum = function (page = 1){
        $.ajax({
        url: '/api/dueDiligences?pageNum='+page+'&amount=10',
        type: "GET",
        dataType: "json",
        success: function(response) {

        if(response.authorized === false) {
        alert("관리자만 접근 가능한 페이지입니다.");
        window.location.href="/stocks";
        return;
        }

        table.clear();

        table.rows.add(response.list);
        table.draw();

        renderPagination(response.pageDTO);

        },
        error: function (xhr, status, error) {
        console.error("데이터 조회 실패:", error);
        alert("데이터를 불러오는 중 오류가 발생했습니다.");
        },
        })
        }

        window.renderPagination = function(pageDTO) {
        const $pagination = $(".pagination");

        // pageDTO가 없거나 total이 0이면 숨기기
        if (!pageDTO || pageDTO.total <= pageDTO.cri.amount) {
        $pagination.addClass("d-none");
        return;
        }

        $pagination.removeClass("d-none");
        $pagination.empty();

        const { startPage, endPage, prev, next, cri } = pageDTO;
        const currentPage = cri.pageNum;

        if (prev) {
        $pagination.append(
        '<li class="page-item">'
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

        window.addDueDiligence = function() {
        axios.get("/api/dueDiligence").then(
        response => {
        if(response.data === null) {
            alert("재고 실사 등록은 일반관리자만 가능합니다.");
            return;
        }

        console.log(response.data);
        const whCodeList = response.data;

        const selectWhCode = document.getElementById("whCode");

        selectWhCode.innerHTML = "";

        const defaultOption = document.createElement("option");  //선택하기 default
        defaultOption.value = "";
        defaultOption.textContent = "선택하세요."
        selectWhCode.appendChild(defaultOption);

        whCodeList.forEach(wh => {
        const option = document.createElement("option");

        option.value = wh;
        option.textContent = wh;
        selectWhCode.appendChild(option);
        });

        const modal = new bootstrap.Modal(document.getElementById("dueDiligenceModal"));
        modal.show();
        }
        ).catch(error => {
        console.error("창고코드 불러오기 실패!: "+ error);
        alert("창고 목록을 불러오지 못했습니다.");
        })
        };

        // 시스템 재고 조회 버튼 클릭
        $(document).on("click", "#btnCheckStock", function() {
        const stkId = $("#stkId").val();
        const whCode = $("#whCode").val();

        if(!whCode) {
        alert("창고 코드를 선택해주세요.");
        return;
        }

        if (!stkId) {
        alert("재고ID를 입력하세요.");
        return;
        }

        $.ajax({
        url: '/api/stocks/'+stkId+'/warehouse/'+ whCode,
        type: "GET",
        dataType: "json",
        success: function(res) {
        $("#systemStock").val(res.stkQuantity);
        document.getElementById("whCode").setAttribute("disabled", true);
        document.getElementById("stkId").setAttribute("readonly", true);
        document.getElementById("realStock").removeAttribute("readonly");
        document.getElementById("ddLog").removeAttribute("readonly");
        },
        error: function() {
        alert("해당 창고에는 재고가 존재하지 않습니다.");
        }
        });
        });

        // 등록하기 버튼 클릭
        $(document).on("click", "#btnRegister", function() {
        const data = {
        whCode: $("#whCode").val(),
        stkId: $("#stkId").val(),
        realStkQuantity: $("#realStock").val(),
        ddLog: $("#ddLog").val(),
        maId: "manager_lee"
        };

        if (!data.realStkQuantity) {
        alert("실제 재고는 입력해주셔야합니다.");
        return;
        }

        $.ajax({
        url: "/api/dueDiligence",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(response) {
            if(response.data === -1) {alert("권한이 없습니다.")}
            alert("등록 성공!");
        $("#dueDiligenceModal").modal("hide");
        clickPageNum(1); // 새로고침
        },
        error: function() {
        alert("등록 실패!");
        }
        });
        });

        // 모달 닫힐 때 입력 필드 초기화
        $("#dueDiligenceModal").on("hidden.bs.modal", function () {
        // 입력 필드 초기화
        $("#dueDiligenceForm")[0].reset();

        // 비활성화된 필드 다시 활성화
        $("#whCode").prop("disabled", false);
        $("#stkId").prop("readonly", false);
        $("#realStock").prop("readonly", true);
        $("#ddLog").prop("readonly", true);
        });
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>