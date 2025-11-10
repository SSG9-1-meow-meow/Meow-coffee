<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 헤더 포함 --%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<!-- 메인 컨텐츠 시작 -->
<div
        class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4"
>
  <div>
    <h3 class="fw-bold mb-3">Coffee WMS 대시보드</h3>
    <h6 class="op-7 mb-2">재고 및 입고/출고 현황 요약</h6>
  </div>
  <div class="ms-md-auto py-2 py-md-0">
    <a href="#" class="btn btn-label-info btn-round me-2">재고실사</a>
    <a href="#" class="btn btn-primary btn-round">입고 요청 등록</a>
  </div>
</div>
<div class="row">
  <div class="col-sm-6 col-md-3">
    <div class="card card-stats card-round">
      <div class="card-body">
        <!-- ... 카드 내용 ... -->
      </div>
    </div>
  </div>
  <!-- ... 나머지 Dashboard 카드 및 차트/테이블 내용 그대로 ... -->
</div>
<div class="row">
  <div class="col-md-8">
    <div class="card card-round">
      <!-- ... User Statistics 차트 내용 ... -->
    </div>
  </div>
  <div class="col-md-4">
    <!-- ... Daily Sales 차트 내용 ... -->
  </div>
</div>
<!-- ... 나머지 컨텐츠 섹션 ... -->
<div class="row">...</div>
<!-- 메인 컨텐츠 종료 -->

<%-- 푸터 포함 --%>
<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>