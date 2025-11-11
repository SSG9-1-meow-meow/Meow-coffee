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
            <h4 class="card-title fs-3">재고 조회</h4>
          </div>

          <div class="card-body">
            <!-- 선택하게 체크 박스 둬야함 -->
            <div class="card">
              <div class="card-header">
                <div class="card-title fs-5">조회 기준을 선택해주세요.</div>
              </div>
              <div class="card-body">
                <div class="card-body">
                  <div class="type-checkbox d-flex justify-content-around align-items-center">

                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="type-stocklist" id="radioTotal" value="total" checked>
                      <label class="form-check-label" for="radioTotal">
                        전체
                      </label>
                    </div>

                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="type-stocklist" id="radioCategory" value="cfCategory">
                      <label class="form-check-label" for="radioCategory">
                        대분류별
                      </label>
                    </div>

                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="type-stocklist" id="radioType" value="cfType">
                      <label class="form-check-label" for="radioType">
                        중분류별
                      </label>
                    </div>

                    <div class="form-check">
                      <input class="form-check-input" type="radio" name="type-stocklist" id="radioGrade" value="cfGrade">
                      <label class="form-check-label" for="radioGrade">
                        소분류별
                      </label>
                    </div>

                  </div>

                  <select class="form-select select-filter mt-3 d-none" aria-label="Default select example" id="selectInputWrapper">
                  </select>

                  <div class="d-flex justify-content-end mt-3">
                    <button id="selectListBtn" onclick="submitListBtn()" class="btn btn-primary">조회</button>
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
                  <th>재고ID</th>
                  <th>커피상품명</th>
                  <th>대분류</th>
                  <th>창고 이름</th>
                  <th>보관위치(zone)</th>
                  <th>재고 수량</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
              </table>
            </div>
            <!-- <button class="btn btn-black">등록하기</button> -->
            <div class="d-flex justify-content-end align-items-center">
              <ul class="pagination pg-primary mb-0 d-none">
              </ul>
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
        { data: "stkId" },
        {data: "cfName",
          render: function (data, type, row) {
            // row 객체 안에 링크용 ID(stkId 등)가 포함돼있다고 가정
            return '<a href="/api/stocks/' + row.cfName + '" class="text-primary text-decoration-underline">' + data + '</a>';
          }},
        { data: "cfCategory" },
        { data: "whName" },
        { data: "zoneName" },
        { data: "stkQuantity" }
      ]
    });

    //데이터 가져오기
    const filterData = {
      cfCategory: ["[대분류] 식품", "[대분류] 가전", "[대분류] 의류"],
      cfType: ["[중분류] 과일", "[중분류] TV", "[중분류] 아우터"],
      cfGrade: ["[소분류] 사과", "[소분류] QLED", "[소분류] 패딩"]
    };

    // 1. name이 'type-stocklist'인 radio 버튼에 'change' 이벤트 리스너 추가
    $('input[name="type-stocklist"]').on('change', function() {
      console.log("대중소분류 선택하기");
      // 2. 선택된 radio 버튼의 'value' 값을 가져옴
      var selectedValue = $(this).val();
      var $selectBox = $('#selectInputWrapper'); // 검색창 div 캐싱

      // 3. 'value'가 'total'인지 확인
      if (selectedValue === 'total') {
        // 'total'이면 검색창을 숨김
        $selectBox.addClass('d-none');
        $selectBox.empty();

      } else {
        //대분류, 중분류, 소분류 리스트 저장해놓고 보여줘야함

        $selectBox.empty();

        $selectBox.append('<option selected disabled value="">-- 항목을 선택하세요 --</option>');

        const optionsList = filterData[selectedValue];

        if (optionsList) {
          $.each(optionsList, function(index, item) {
            // 예: <option value="[대분류] 식품">[대분류] 식품</option>
            $selectBox.append($('<option>', {
              value: item,
              text: item
            }));
          });
        }

        // 5. 셀렉트박스를 보여줍니다.
        $selectBox.removeClass('d-none');
      }
    });
  })

  // 조회 버튼 클릭 시 동작
  window.submitListBtn = function(page=1) {
    // 1. 선택된 라디오 버튼 확인
    const selectedType = $('input[name="type-stocklist"]:checked').val();
    const selectedValue = $('#selectInputWrapper').val();

    let url = "";

    // 2. 전체일 경우
    if (selectedType === "total") {
      url = "/api/stocks?pageNum=" + page + "&amount=10";

      // 3. 대분류, 중분류, 소분류는 필수 선택 검증
    } else {
      if (!selectedValue) {
        alert("항목을 선택해주세요.");
        return;
      }

      // 4. 선택된 기준에 따라 요청 URL 다르게 설정
      if (selectedType === "cfCategory") {
        url = "/api/stocks/category/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=10";
      } else if (selectedType === "cfType") {
        url = "/api/stocks/type/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=10";
      } else if (selectedType === "cfGrade") {
        url = "/api/stocks/grade/" + encodeURIComponent(selectedValue) + "?pageNum=" + page + "&amount=10";
      }
    }

    $.ajax({
      url: url,
      type: "GET",
      dataType: "json",
      success: function(response) {
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

  window.renderPagination = function(pageDTO){
    const $pagination = $(".pagination");

    // pageDTO가 없거나 total이 0이면 숨기기
    if (!pageDTO || pageDTO.total === 0) {
      $pagination.addClass("d-none");
      return;
    }

    $pagination.removeClass("d-none");
    $pagination.empty();

    const { startPage, endPage, prev, next, cri } = pageDTO;
    const currentPage = cri.pageNum;

    if (prev) {
      $pagination.append('<li class="page-item">'
              + '<a class="page-link" onclick="submitListBtn(' + (startPage - 1) + ')">&laquo;</a>'
              + '</li>'
      );
    }

    // 페이지 번호 버튼
    for (let i = startPage; i <= endPage; i++) {
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
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>
        
<%--</script>--%>
<%--<%@include file="/WEB-INF/views/includes/_footer.jsp"%>--%>
<%--  </div>--%>
<%--</div>--%>

<%--<script src="/resources/assets/js/core/jquery-3.7.1.min.js"></script>--%>
<%--<script src="/resources/assets/js/core/popper.min.js"></script>--%>
<%--<script src="/resources/assets/js/core/bootstrap.min.js"></script>--%>
<%--<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>--%>

<%--<script src="/resources/assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>--%>
<%--<script src="/resources/assets/js/kaiadmin.min.js"></script>--%>
<%--<script src="/resources/assets/js/setting-demo2.js"></script>--%>
<%--<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>--%>

<%--</body>--%>
<%--</html>--%>
