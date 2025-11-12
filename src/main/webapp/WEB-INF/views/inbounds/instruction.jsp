<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>입고 지시서</title>
  <!-- Bootstrap CSS (또는 프로젝트 공통 CSS) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- PDF 생성을 위한 라이브러리 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <script src="https://unpkg.com/axios/dist/axios.min.js"></script>

  <style>
      body { background-color: #f8f9fa; }
      .container { max-width: 800px; background-color: #fff; padding: 40px; margin-top: 20px; border: 1px solid #dee2e6; }
      .signature-box { border-top: 1px solid #000; margin-top: 40px; padding-top: 10px; text-align: right; }
      @media print { /* 인쇄 시 버튼 숨김 */
          .no-print { display: none; }
      }
  </style>
</head>
<body>

<div class="container" id="instruction-content">
  <h1 class="text-center mb-4">입고 지시서</h1>
  <p class="text-end">발행일: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd"/></p>

  <table class="table table-bordered">
    <tbody>
    <tr>
      <th style="width: 25%;">문서 번호</th>
      <td>INB-${instruction.inReqItemsId}</td>
    </tr>
    <tr>
      <th>거래처명</th>
      <td>${instruction.companyName}</td>
    </tr>
    <tr>
      <th>품목명</th>
      <td>${instruction.cfName} (${instruction.cfCategory})</td>
    </tr>
    <tr>
      <th>입고 요청 수량</th>
      <td><strong>${instruction.inQtyReq} PLT</strong></td>
    </tr>
    <tr>
      <th>입고 예정일</th>
      <td><fmt:formatDate value="${scheduledDateAsDate}" pattern="yyyy-MM-dd"/></td>
    </tr>
    <tr>
      <th>보관 위치</th>
      <td>${instruction.warehouseName} - ${instruction.zoneName} (${instruction.lpId})</td>
    </tr>
    </tbody>
  </table>

  <div class="mt-5">
    <h5 class="mb-3">검수 및 서명</h5>

    <!-- 검수 시작 버튼 -->
    <div class="d-grid gap-2 mb-4">
      <button id="start-inspection-btn" class="btn btn-warning <c:if test="${not empty instruction.inDttmInsp}">disabled</c:if>">
        <c:choose>
          <c:when test="${not empty instruction.inDttmInsp}">
            ${inspectionDateAsDate}
            검수 완료 (<fmt:formatDate value="${inspectionDateAsDate}" pattern="yyyy-MM-dd HH:mm"/>)
          </c:when>
          <c:otherwise>
            검수 시작
          </c:otherwise>
        </c:choose>
      </button>
    </div>

    <div class="row">
      <div class="col-6">
        <p>입고 작업자</p>
        <div class="signature-box">
          <span>(서명)</span>
        </div>
      </div>
      <div class="col-6">
        <p>검수 책임자</p>
        <div class="signature-box">
          <span>(서명)</span>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container text-center mt-3 no-print">
  <button id="print-pdf-btn" class="btn btn-secondary">PDF로 출력</button>
</div>

<script>
    const inReqItemsId = "${instruction.inReqItemsId}";

    // PDF 출력 버튼 이벤트
    document.getElementById('print-pdf-btn').addEventListener('click', function() {
        const { jsPDF } = window.jspdf;
        const content = document.getElementById('instruction-content');

        html2canvas(content).then(canvas => {
            const imgData = canvas.toDataURL('image/png');
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgWidth = 210; // A4 width
            const pageHeight = 295; // A4 height
            const imgHeight = canvas.height * imgWidth / canvas.width;
            let heightLeft = imgHeight;
            let position = 0;

            pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                pdf.addPage();
                pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }
            pdf.save(`입고지시서_${inReqItemsId}.pdf`);
        });
    });

    // 검수 시작 버튼 이벤트
    document.getElementById('start-inspection-btn').addEventListener('click', function() {
        if (this.classList.contains('disabled')) {
            alert('이미 검수가 시작/완료된 항목입니다.');
            return;
        }

        if (confirm('검수를 시작하시겠습니까? 검수 시작 시각이 기록됩니다.')) {
            axios.put('/inbounds/items/inspect/' + inReqItemsId)
                .then(response => {
                    alert(response.data.message);
                    // 성공 시 페이지 새로고침하여 버튼 상태 업데이트
                    window.location.reload();
                })
                .catch(error => {
                    console.error("검수 시작 처리 중 오류:", error);
                    alert("처리 중 오류가 발생했습니다.");
                });
        }
    });
</script>

</body>
</html>