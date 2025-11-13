<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>재고 상세 정보</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <h1 class="mb-4">재고 상세 정보</h1>
  <table class="table table-bordered align-middle">
    <thead class="table-light">
    <tr>
      <th style="width: 25%;">항목</th>
      <th>내용</th>
    </tr>
    </thead>
    <tbody>
    <tr><th>고유 재고 ID (LPN ID)</th><td>${stkId}</td></tr>
    <tr><th>입고 지시 번호</th><td>INB-${stock.inReqItemsId}</td></tr>
    <tr><th>요청 회원사명 (화주)</th><td>${stock.companyName}</td></tr>
    <tr><th>요청 커피명</th><td>${stock.cfName}</td></tr>
    <tr><th>상품의 구체적인 명칭</th><td>${stock.cfName} G2 (샘플)</td></tr>
    <tr><th>커피 카테고리</th><td>${stock.cfCategory}</td></tr>
    <tr><th>최종 수량 (파레트/포대)</th><td><strong>${stock.inQty} PLT</strong></td></tr>
    <tr><th>입고 처리 일자</th><td><fmt:formatDate value="${receivedDateAsDate}" pattern="yyyy-MM-dd"/></td></tr>
    <tr><th>현재 적치 위치 (Zone)</th><td>${stock.zoneName}</td></tr>
    <tr><th>현재 적치 위치 (Detail)</th><td>${stock.lpId} (샘플)</td></tr>
    <tr><th>지정 적치 위치 (최적)</th><td>A-4-1 (샘플)</td></tr>
    <tr><th>요청 보관 조건</th><td>온도 20℃, 습도 60% (샘플)</td></tr>
    <tr><th>재고 상태</th><td>가용 재고 (샘플)</td></tr>
    <tr><th>다음 예정 작업</th><td>출고 대기 (샘플)</td></tr>
    </tbody>
  </table>
  <div class="text-end">
    <a href="javascript:history.back()" class="btn btn-secondary">뒤로 가기</a>
  </div>
</div>
</body>
</html>