<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 컨텍스트 경로 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- 1) 현재 로그인한 아이디 가져오기 --%>
<%--    스프링 시큐리티 Principal 에서 name 꺼냄 (예: admin_master:ADMIN) --%>
<c:set var="rawUserId"
       value="${pageContext.request.userPrincipal ne null ? pageContext.request.userPrincipal.name : ''}" />

<%-- 2) 콜론(:) 앞부분만 사용 (admin_master:ADMIN -> admin_master) --%>
<c:set var="pureUserId" value="${rawUserId}" />
<c:if test="${not empty rawUserId and fn:contains(rawUserId, ':')}">
  <c:set var="pureUserId" value="${fn:substringBefore(rawUserId, ':')}" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>냥냥 커피 WMS 시스템</title>
  <meta content="width=device-width, initial-scale=1.0, shrink-to-fit=no" name="viewport"/>

  <link rel="icon" href="${ctx}/resources/assets/img/meow/favicon.ico" type="image/x-icon"/>

  <!-- FullCalendar CSS & JS : 관리자 입고관리를 위해 추가 (박기웅) -->
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
  <!-- flatpickr CSS & JS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

  <!-- Fonts and icons -->
  <script src="${ctx}/resources/assets/js/plugin/webfont/webfont.min.js"></script>
  <script>
    WebFont.load({
      google: {families: ["Public Sans:300,400,500,600,700"]},
      custom: {
        families: [
          "Font Awesome 5 Solid",
          "Font Awesome 5 Regular",
          "Font Awesome 5 Brands",
          "simple-line-icons",
        ],
        urls: ["${ctx}/resources/assets/css/fonts.min.css"],
      },
      active: function () {
        sessionStorage.fonts = true;
      },
    });
  </script>

  <!-- CSS Files -->
  <link rel="stylesheet" href="${ctx}/resources/assets/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${ctx}/resources/assets/css/plugins.min.css"/>
  <link rel="stylesheet" href="${ctx}/resources/assets/css/kaiadmin.min.css"/>

  <!-- CSS Just for demo purpose -->
  <link rel="stylesheet" href="${ctx}/resources/assets/css/demo.css"/>

  <style>
    .main-panel {
      width: 100%;
      margin-left: 0 !important;
    }

    .wrapper {
      padding-left: 0 !important;
    }

    .fc .fc-button {
      background-color: #1a2035;
      color: #ffffff;
      border: 1px solid #1a2035;
      border-radius: 50px;
      padding: 0.4rem 0.8rem;
      font-size: 1rem;
      text-transform: none;
      box-shadow: none !important;
    }

    .fc .fc-button:hover {
      background-color: #28304e;
      border-color: #28304e;
    }

    .fc .fc-button:active,
    .fc .fc-button:focus {
      background-color: #28304e;
      border-color: #28304e;
      box-shadow: none !important;
    }
  </style>
</head>
<body>

<!-- Offcanvas Sidebar (toggle로 확장 표시) -->
<div class="offcanvas offcanvas-start"
     tabindex="-1"
     id="offcanvasSidebar"
     aria-labelledby="offcanvasSidebarLabel"
     data-background-color="white">
  <div class="offcanvas-header">
    <h3 class="offcanvas-title" id="offcanvasSidebarLabel">메뉴</h3>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <ul class="nav flex-column">
      <li class="nav-item">
        <a class="nav-link"
           data-bs-toggle="collapse"
           href="#oc-dashboard"
           role="button"
           aria-expanded="false"
           aria-controls="oc-dashboard">
          <i class="fas fa-truck-loading"></i> 입/출고 관리
        </a>
        <div class="collapse" id="oc-dashboard">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="#">입/출고 현황</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/inbounds">입고 관리
                <span class="badge bg-success ms-1">4</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/outbounds">출고 관리
                <span class="badge bg-secondary ms-1">1</span></a>
            </li>
          </ul>
        </div>
      </li>

      <li class="nav-item mt-2">
        <a class="nav-link"
           data-bs-toggle="collapse"
           href="#oc-base"
           role="button"
           aria-expanded="false"
           aria-controls="oc-base">
          <i class="fas fa-warehouse"></i> 창고/재고 관리
        </a>
        <div class="collapse" id="oc-base">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/warehouses">창고 관리</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/stocks">재고 관리</a>
            </li>
          </ul>
        </div>
      </li>

      <li class="nav-item mt-2">
        <a class="nav-link"
           data-bs-toggle="collapse"
           href="#oc-sidebarLayouts"
           role="button"
           aria-expanded="false"
           aria-controls="oc-sidebarLayouts">
          <i class="fas fa-dollar-sign"></i> 재무 관리
        </a>
        <div class="collapse" id="oc-sidebarLayouts">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/finance/expense">지출 현황</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/finance/invoice">청구 현황</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/finance/revenue">매출 현황</a>
            </li>
          </ul>
        </div>
      </li>

      <li class="nav-item mt-2">
        <a class="nav-link"
           data-bs-toggle="collapse"
           href="#oc-forms"
           role="button"
           aria-expanded="false"
           aria-controls="oc-forms">
          <i class="fas fa-pen-square"></i> 입/출고 요청
        </a>
        <div class="collapse" id="oc-forms">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/inbounds/req">회원 입고 요청</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/outbounds/req">출고 입고 요청</a>
            </li>
          </ul>
        </div>
      </li>

      <li class="nav-item mt-2">
        <a class="nav-link"
           data-bs-toggle="collapse"
           href="#oc-maps"
           role="button"
           aria-expanded="false"
           aria-controls="oc-maps">
          <i class="fas fa-map-marker-alt"></i> 창고 위치
        </a>
        <div class="collapse" id="oc-maps">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="${ctx}/maps/googlemaps.html">카카오맵</a>
            </li>
          </ul>
        </div>
      </li>
    </ul>
  </div>
</div>

<div class="wrapper">
  <div class="main-panel">
    <div class="main-header">
      <div class="main-header-logo">
        <div class="logo-header" data-background-color="dark">
          <div class="nav-toggle">
            <button class="btn btn-toggle"
                    type="button"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#offcanvasSidebar"
                    aria-controls="offcanvasSidebar">
              <i class="gg-menu-left"></i>
            </button>
          </div>
          <button class="topbar-toggler more">
            <i class="gg-more-vertical-alt"></i>
          </button>
        </div>
      </div>

      <!-- Navbar Header -->
      <nav class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom">
        <div class="container-fluid">

          <!-- 검색 폼 -->
          <nav class="navbar navbar-header-left navbar-expand-lg navbar-form nav-search p-0 d-none d-lg-flex me-auto">
            <div class="input-group">
              <div class="input-group-prepend">
                <button type="submit" class="btn btn-search pe-1">
                  <i class="fa fa-search search-icon"></i>
                </button>
              </div>
              <input type="text" placeholder="Search ..." class="form-control"/>
            </div>
          </nav>

          <!-- 가운데 로고 -->
          <a href="${ctx}/" class="navbar-brand">
            <img src="${ctx}/resources/assets/img/meow/meowCoffeeLogo2.png"
                 alt="Meow Coffee Logo"
                 style="height: 5rem; width: auto; margin-right: 8px;">
            Meow 커피 창고 관리 시스템
          </a>

          <!-- Topbar 오른쪽 -->
          <ul class="navbar-nav topbar-nav ms-md-auto align-items-center">

            <%-- 우측 상단 프로필 (아바타) --%>
            <li class="nav-item topbar-user dropdown hidden-caret">
              <a class="dropdown-toggle profile-pic"
                 data-bs-toggle="dropdown"
                 href="#"
                 aria-expanded="false">
                <div class="avatar-sm">
                  <img src="${ctx}/resources/assets/img/meow/sampleProfile.png"
                       alt="..."
                       class="avatar-img rounded-circle"/>
                </div>
                <span class="profile-username">
                                    <span class="op-7">Hi,</span>
                                    <span class="fw-bold">야옹</span>
                                </span>
              </a>
              <ul class="dropdown-menu dropdown-user animated fadeIn">
                <div class="dropdown-user-scroll scrollbar-outer">
                  <li>
                    <div class="user-box">
                      <div class="avatar-lg">
                        <img src="${ctx}/resources/assets/img/meow/meowCoffeeLogo1.png"
                             alt="image profile"
                             class="avatar-img rounded"/>
                      </div>
                      <div class="u-text">
                        <h4>야옹님</h4>
                        <p class="text-muted">meowCoffee@meow.com</p>

                        <%-- 여기! 로그인 아이디 있을 때만 프로필 버튼 노출 --%>
                        <c:if test="${not empty pureUserId}">
                          <a href="${ctx}/members/profile/${pureUserId}"
                             class="btn btn-xs btn-secondary btn-sm">
                            프로필 보러가기
                          </a>
                        </c:if>
                      </div>
                    </div>
                  </li>
                  <li>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${ctx}/auth/logout">로그 아웃</a>
                  </li>
                </div>
              </ul>
            </li>
          </ul>
        </div>
      </nav>
      <!-- End Navbar Header -->

      <!-- Header 하단 가로 네비게이션 -->
      <nav class="navbar navbar-expand-lg navbar-bottom border-bottom"
           data-background-color="dark">
        <div class="container-fluid">
          <button class="navbar-toggler"
                  type="button"
                  data-bs-toggle="collapse"
                  data-bs-target="#headerSubnav"
                  aria-controls="headerSubnav"
                  aria-expanded="false"
                  aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="headerSubnav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle"
                   href="#"
                   id="navDashboard"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false">
                  <i class="fas fa-truck-monster"></i>&nbsp; 입/출고 관리
                </a>
                <ul class="dropdown-menu" aria-labelledby="navDashboard" style="left: 0;">
                  <li><a class="dropdown-item" href="#">입/출고 현황</a></li>
                  <li><a class="dropdown-item" href="${ctx}/inbounds">입고 관리
                    <span class="badge bg-success ms-1">4</span></a></li>
                  <li><a class="dropdown-item" href="${ctx}/outbounds">출고 관리
                    <span class="badge bg-secondary ms-1">1</span></a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle"
                   href="#"
                   id="navBase"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false">
                  <i class="fas fa-warehouse"></i> &nbsp; 창고/재고 관리
                </a>
                <ul class="dropdown-menu" aria-labelledby="navBase">
                  <li><a class="dropdown-item" href="${ctx}/warehouses">창고 관리</a></li>
                  <li><a class="dropdown-item" href="${ctx}/stocks">재고 관리</a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle"
                   href="#"
                   id="navSidebarLayouts"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false">
                  <i class="fas fa-money-bill"></i> &nbsp; 재무 관리
                </a>
                <ul class="dropdown-menu" aria-labelledby="navSidebarLayouts">
                  <li><a class="dropdown-item" href="${ctx}/finance/expense">지출 현황</a></li>
                  <li><a class="dropdown-item" href="${ctx}/finance/invoice">청구 현황</a></li>
                  <li><a class="dropdown-item" href="${ctx}/finance/revenue">매출 현황</a></li>
                </ul>
              </li>
            </ul>

            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
              <li class="nav-item me-2">
                <a class="btn btn-outline-light btn-sm"
                   href="#"
                   data-bs-toggle="offcanvas"
                   data-bs-target="#offcanvasSidebar"
                   aria-controls="offcanvasSidebar">
                  <i class="fas fa-bars"></i>
                  <span class="d-none d-md-inline ms-1">메뉴</span>
                </a>
              </li>

              <li class="nav-item dropdown me-2">
                <a class="nav-link dropdown-toggle"
                   href="#"
                   id="navQuick"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false">
                  <i class="fas fa-bolt"></i>
                  <span class="d-none d-md-inline ms-1">Quick</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navQuick">
                  <li><a class="dropdown-item" href="${ctx}/inbounds/req">입고 요청</a></li>
                  <li><a class="dropdown-item" href="#">출고 요청</a></li>
                  <li><hr class="dropdown-divider"/></li>
                  <li><a class="dropdown-item" href="#">많이 조회하는거</a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle d-flex align-items-center"
                   href="#"
                   id="navUser"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false">
                  <i class="fas fa-user-circle me-1"></i>
                  <span class="d-none d-md-inline">계정</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navUser">
                  <%-- 여기! 내 프로필 링크 --%>
                  <c:if test="${not empty pureUserId}">
                    <li>
                      <a class="dropdown-item"
                         href="${ctx}/members/profile/${pureUserId}">
                        내 프로필
                      </a>
                    </li>
                  </c:if>

                  <%-- 관리자 전용 메뉴 --%>
                  <li><a class="dropdown-item" href="${ctx}/members/list">회원리스트 조회</a></li>
                  <li><hr class="dropdown-divider"/></li>
                  <li><a class="dropdown-item" href="${ctx}/auth/logout">로그아웃</a></li>
                </ul>
              </li>

            </ul>
          </div>
        </div>
      </nav>
    </div>

    <!-- 여기부터 각 JSP 파일의 메인 컨텐츠 시작 -->
    <div class="container">
      <div class="page-inner">
        <%-- _header.jsp 끝 --%>
