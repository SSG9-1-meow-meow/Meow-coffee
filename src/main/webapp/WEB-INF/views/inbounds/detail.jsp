<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>입고 상세 처리</title>
  <!-- Bootstrap CSS
         - 테이블, 버튼, 모달 등을 예쁘게 꾸미기 위한 CSS 프레임워크
         - CDN 방식으로 불러온다. -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>

  <!-- 1. jQuery 라이브러리 (Bootstrap JS보다 먼저 와야 함) -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <!-- 2. Bootstrap JavaScript 번들 (모달 등의 기능을 위해 필요) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<h1>입고 상세 정보 (ID: ${inboundDetail.inReqItemsId})</h1>

<ul>
  <li><strong>거래처:</strong> ${inboundDetail.companyName}</li>
  <li><strong>품목:</strong> ${inboundDetail.coffeeName} (${inboundDetail.coffeeCategory})</li>
  <li><strong>요청 수량:</strong> ${inboundDetail.inQtyReq}</li>
  <li><strong>상태:</strong> ${inboundDetail.status.value}</li>
</ul>

<hr>

<h2>QR 코드 테스트</h2>

<!-- '입고완료' 상태일 때만 버튼을 보여줌 -->
<%--<c:if test="${inboundDetail.status.name() == 'RECEIVED'}">--%>
  <!-- 재고 ID(inReqItemsId)를 data-stock-id 속성에 담아 둠 -->
  <button class="btn btn-secondary qr-print-btn" data-inreqitems-id="${inboundDetail.inReqItemsId}">
    QR 출력
  </button>
<%--  <img src="/inbounds/qr/${inboundDetail.inReqItemsId}" alt="입고 QR 코드">--%>
<%--</c:if>--%>


<!-- QR 코드 표시를 위한 모달 (Bootstrap Modal 예시) -->
<div class="modal fade" id="qrModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">입고 QR 코드</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <!-- QR 이미지가 여기에 표시됨 -->
        <img id="qrCodeImage" src="" alt="QR Code">
        <p id="qrInReqItemsIdText" class="mt-2"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="printQrCode()">인쇄</button>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function() {
    // 'QR 출력' 버튼 클릭 이벤트
    $('.qr-print-btn').on('click', function() {
      const inReqItemsId = $(this).data('inreqitems-id'); // 버튼에서 입고 ID 가져오기; js에서는 소문자만

      if (inReqItemsId) {
        // <img> 태그의 src 속성에 QR 코드 API 엔드포인트 주소를 설정
        $('#qrCodeImage').attr('src', '/inbounds/qr/' + inReqItemsId);
        $('#qrInReqItemsIdText').text('입고 ID: ' + inReqItemsId);

        // 모달 창 띄우기
        new bootstrap.Modal($('#qrModal')).show();
      }
    });
  });

  // 인쇄 기능
  function printQrCode() {
    // 인쇄하고 싶은 영역만 가져오기
    const printContents = document.getElementById('qrCodeImage').outerHTML;
    const originalContents = document.body.innerHTML;
    // 현재 페이지 내용을 인쇄할 내용으로 잠시 교체
    document.body.innerHTML = printContents;
    window.print(); // 브라우저 인쇄 대화상자 호출
    document.body.innerHTML = originalContents; // 원래 내용으로 복원
    location.reload(); // 스타일 깨짐 방지를 위해 새로고침
  }
</script>


</body>
</html>
