<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Footer 영역 시작 -->
</div>
</div>

<footer class="footer">
  <div class="container-fluid d-flex justify-content-between">
    <nav class="pull-left">
      <ul class="nav">
        <li class="nav-item">
          <a class="nav-link" href="#"> 회사소개 </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"> 고객센터 </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"> 라이선스 </a>
        </li>
      </ul>
    </nav>
    <div class="copyright">
      2025, Meow Coffee WMS made by SSG 1st TEAM
    </div>
    <div>Distributed by <a href="#">MeowCoffee WMS</a>.</div>
  </div>
</footer>
</div>

<!-- ... Custom Template 내용 그대로 ... -->
<div class="custom-template">
  <div class="title">Settings</div>
  <div class="custom-content">
    <div class="switcher">
      <div class="switch-block">
        <h4>헤더 색상 변경</h4>
        <div class="btnSwitch">
          <button
              type="button"
              class="changeTopBarColor"
              data-color="dark"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="blue"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="purple"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="light-blue"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="green"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="orange"
          ></button>
          <button
              type="button"
              class="changeTopBarColor"
              data-color="red"
          ></button>
          <button
              type="button"
              class="selected changeTopBarColor"
              data-color="white"
          ></button>
          <br/>
        </div>
      </div>

      <div class="switch-block">
        <h4>하단 네비게이션 색상 변경</h4>
        <div class="btnSwitch">
          <button
              type="button"
              class="selected changeNavBarColor"
              data-color="dark"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="blue"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="purple"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="light-blue"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="green"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="orange"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="red"
          ></button>
          <button
              type="button"
              class="changeNavBarColor"
              data-color="white"
          ></button>
          <br/>
        </div>
      </div>

      <%--      kwp add--%>
      <div class="switch-block">
        <h4>하단 네비 폰트 크기 변경</h4>
        <div class="btnSwitch">
          <button
              type="button"
              class="changeNavBarFontSize"
              data-font="xlarge"
          ></button>
          <button
              type="button"
              class="changeNavBarFontSize"
              data-font="large"
          ></button>
          <button
              type="button"
              class="selected changeNavBarFontSize"
              data-font="normal"
          ></button>
        </div>
      </div>


      <div class="switch-block">
        <h4>메뉴 사이드바 색상 변경</h4>
        <div class="btnSwitch">
          <button
              type="button"
              class="selected changeOffCanvasColor"
              data-color="white"
          ></button>
          <button
              type="button"
              class="changeOffCanvasColor"
              data-color="dark"
          ></button>
        </div>
      </div>
    </div>
  </div>


  <div class="custom-toggle">
    <i class="icon-settings"></i>
  </div>
</div>

</div>
<!-- End Custom template --><!-- Core JS Files -->
<script src="/resources/assets/js/core/jquery-3.7.1.min.js"></script>
<script src="/resources/assets/js/core/popper.min.js"></script>
<script src="/resources/assets/js/core/bootstrap.min.js"></script>

<!-- Axios (비동기 HTTP 요청 라이브러리) ★★★ 추가됨 ★★★ -->
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<!-- jQuery Scrollbar -->
<script src="/resources/assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>

<!-- Chart JS -->
<script src="/resources/assets/js/plugin/chart.js/chart.min.js"></script>

<!-- jQuery Sparkline -->
<script src="/resources/assets/js/plugin/jquery.sparkline/jquery.sparkline.min.js"></script>

<!-- Chart Circle -->
<script src="/resources/assets/js/plugin/chart-circle/circles.min.js"></script>

<!-- Datatables -->
<script src="/resources/assets/js/plugin/datatables/datatables.min.js"></script>

<!-- Bootstrap Notify -->
<script src="/resources/assets/js/plugin/bootstrap-notify/bootstrap-notify.min.js"></script>

<!-- jQuery Vector Maps -->
<script src="/resources/assets/js/plugin/jsvectormap/jsvectormap.min.js"></script>
<script src="/resources/assets/js/plugin/jsvectormap/world.js"></script>

<!-- Sweet Alert -->
<script src="/resources/assets/js/plugin/sweetalert/sweetalert.min.js"></script>

<!-- Kaiadmin JS -->
<script src="/resources/assets/js/kaiadmin.min.js"></script>

<!-- Kaiadmin DEMO methods, don't include it in your project! -->
<script src="/resources/assets/js/setting-demo.js"></script>
<%--<script src="/resources/assets/js/demo.js"></script>--%>
<!-- ... 인라인 스크립트 그대로 유지 ... -->
<script>
    $("#lineChart").sparkline([102, 109, 120, 99, 110, 105, 115], {
        type: "line",
        height: "70",
        width: "100%",
        lineWidth: "2",
        lineColor: "#177dff",
        fillColor: "rgba(23, 125, 255, 0.14)",
    });

    // ... 나머지 인라인 스크립트 ...
</script>
</body>
</html>
<!-- _footer.jsp 종료 -->