<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>냥냥 커피 WMS 시스템</title>
  <meta
      content="width=device-width, initial-scale=1.0, shrink-to-fit=no"
      name="viewport"
  />
  <link
      rel="icon"
      href="/resources/assets/img/meow/favicon.ico"
      type="image/x-icon"
  />

  <!-- Fonts and icons -->
  <script src="/resources/assets/js/plugin/webfont/webfont.min.js"></script>
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
              urls: ["/resources/assets/css/fonts.min.css"],
          },
          active: function () {
              sessionStorage.fonts = true;
          },
      });
  </script>

  <!-- CSS Files -->
  <link rel="stylesheet" href="/resources/assets/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="/resources/assets/css/plugins.min.css"/>
  <link rel="stylesheet" href="/resources/assets/css/kaiadmin.min.css"/>

  <!-- CSS Just for demo purpose -->
  <link rel="stylesheet" href="/resources/assets/css/demo.css" />

  <style>
      /* Sidebar 제거에 따른 전체 폭 사용 */
      .main-panel {
          width: 100%;
          margin-left: 0 !important;
      }

      .wrapper {
          padding-left: 0 !important;
      }
  </style>
</head>
<body>
<!-- Offcanvas Sidebar (toggle로 확장 표시) -->
<div
    class="offcanvas offcanvas-start"
    tabindex="-1"
    id="offcanvasSidebar"
    aria-labelledby="offcanvasSidebarLabel"
    data-background-color="white"
>
  <div class="offcanvas-header">
    <h3 class="offcanvas-title" id="offcanvasSidebarLabel">메뉴</h3>
    <button
        type="button"
        class="btn-close"
        data-bs-dismiss="offcanvas"
        aria-label="Close"
    ></button>
  </div>
  <div class="offcanvas-body">
    <ul class="nav flex-column">
      <li class="nav-item">
        <a
            class="nav-link"
            data-bs-toggle="collapse"
            href="#oc-dashboard"
            role="button"
            aria-expanded="false"
            aria-controls="oc-dashboard"
        >
          <i class="fas fa-truck-loading"></i> 입/출고 관리
        </a>
        <div class="collapse" id="oc-dashboard">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="#">입/출고 현황</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">입고 관리<span class="badge bg-success ms-1">4</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">출고 관리<span class="badge bg-secondary ms-1">1</span></a>
            </li>
          </ul>
        </div>
      </li>
      <li class="nav-item mt-2">
        <a
            class="nav-link"
            data-bs-toggle="collapse"
            href="#oc-base"
            role="button"
            aria-expanded="false"
            aria-controls="oc-base"
        >
          <i class="fas fa-warehouse"></i> 창고/재고 관리
        </a>
        <div class="collapse" id="oc-base">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="#">창고 관리</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">재고 관리</a>
            </li>
          </ul>
        </div>
      </li>
      <li class="nav-item mt-2">
        <a
            class="nav-link"
            data-bs-toggle="collapse"
            href="#oc-sidebarLayouts"
            role="button"
            aria-expanded="false"
            aria-controls="oc-sidebarLayouts"
        >
          <i class="fas fa-dollar-sign"></i> 재무 관리
        </a>
        <div class="collapse" id="oc-sidebarLayouts">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="#">매출 현황</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">지출 현황</a>
            </li>
          </ul>
        </div>
      </li>
      <li class="nav-item mt-2">
        <a
            class="nav-link"
            data-bs-toggle="collapse"
            href="#oc-forms"
            role="button"
            aria-expanded="false"
            aria-controls="oc-forms"
        >
          <i class="fas fa-pen-square"></i> 입/출고 요청
        </a>
        <div class="collapse" id="oc-forms">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="#">회원 입고 요청</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">출고 입고 요청</a>
            </li>
          </ul>
        </div>
      </li>
      <li class="nav-item mt-2">
        <a
            class="nav-link"
            data-bs-toggle="collapse"
            href="#oc-maps"
            role="button"
            aria-expanded="false"
            aria-controls="oc-maps"
        >
          <i class="fas fa-map-marker-alt"></i> 창고 위치
        </a>
        <div class="collapse" id="oc-maps">
          <ul class="nav flex-column ms-3">
            <li class="nav-item">
              <a class="nav-link" href="maps/googlemaps.html">카카오맵</a>
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
        <!-- logo-header 이거 날리면 안됨 먼가 구조 무너짐 -->
        <div class="logo-header" data-background-color="dark">
          <div class="nav-toggle">
            <button
                class="btn btn-toggle"
                type="button"
                data-bs-toggle="offcanvas"
                data-bs-target="#offcanvasSidebar"
                aria-controls="offcanvasSidebar"
            >
              <i class="gg-menu-left"></i>
            </button>
          </div>
          <button class="topbar-toggler more">
            <i class="gg-more-vertical-alt"></i>
          </button>
        </div>
        <!-- End Logo Header -->
      </div>
      <!-- Navbar Header -->
      <nav
          class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom"
      >
        <div class="container-fluid">
          <!-- 검색 폼 -->
          <nav
              class="navbar navbar-header-left navbar-expand-lg navbar-form nav-search p-0 d-none d-lg-flex me-auto"
          >
            <div class="input-group">
              <div class="input-group-prepend">
                <button type="submit" class="btn btn-search pe-1">
                  <i class="fa fa-search search-icon"></i>
                </button>
              </div>
              <input
                  type="text"
                  placeholder="Search ..."
                  class="form-control"
              />
            </div>
          </nav>

          <!-- 2. Center: 페이지 제목 -->
          <a href="/" class="navbar-brand">
            <img src="/resources/assets/img/meow/meowCoffeeLogo2.png" alt="Meow Coffee Logo"
                 style="height: 5rem; width: auto; margin-right: 8px;"> Meow 커피 창고 관리 시스템
          </a>

          <!-- Topbar 오른쪽 아이콘 및 사용자 메뉴 -->
          <ul class="navbar-nav topbar-nav ms-md-auto align-items-center">
            <!-- ... 메시지, 알림, 퀵액션, 사용자 메뉴 등 기존 내용 그대로 ... -->
            <li
                class="nav-item topbar-icon dropdown hidden-caret d-flex d-lg-none"
            >
              <a
                  class="nav-link dropdown-toggle"
                  data-bs-toggle="dropdown"
                  href="#"
                  role="button"
                  aria-expanded="false"
                  aria-haspopup="true"
              >
                <i class="fa fa-search"></i>
              </a>
              <ul class="dropdown-menu dropdown-search animated fadeIn">
                <form class="navbar-left navbar-form nav-search">
                  <div class="input-group">
                    <input
                        type="text"
                        placeholder="Search ..."
                        class="form-control"
                    />
                  </div>
                </form>
              </ul>
            </li>
            <li class="nav-item topbar-icon dropdown hidden-caret">
              <%--  우상단 편지 아이콘  --%>
              <a
                  class="nav-link dropdown-toggle"
                  href="#"
                  id="messageDropdown"
                  role="button"
                  data-bs-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
              >
                <i class="fa fa-envelope"></i>
              </a>
              <ul
                  class="dropdown-menu messages-notif-box animated fadeIn"
                  aria-labelledby="messageDropdown"
              >
                <li>
                  <div
                      class="dropdown-title d-flex justify-content-between align-items-center"
                  >
                    메시지
                    <a href="#" class="small">모두 읽음 처리</a>
                  </div>
                </li>
                <li>
                  <div class="message-notif-scroll scrollbar-outer">
                    <div class="notif-center">
                      <a href="#">
                        <div class="notif-img">
                          <img
                              src="/resources/assets/img/jm_denis.jpg"
                              alt="Img Profile"
                          />
                        </div>
                        <div class="notif-content">
                          <span class="subject">총 관리자</span>
                          <span class="block"> 스타벅스 삼성역점 입고 처리 확인 필요! </span>
                          <span class="time">10 minutes ago</span>
                        </div>
                      </a>
                      <a href="#">
                        <div class="notif-img">
                          <img
                              src="/resources/assets/img/chadengle.jpg"
                              alt="Img Profile"
                          />
                        </div>
                        <div class="notif-content">
                          <span class="subject">곤지암 창고 관리자</span>
                          <span class="block"> 브라질 산토스 원두 10PLT 공급 바람 </span>
                          <span class="time"> 20 minutes ago</span>
                        </div>
                      </a>
                      <a href="#">
                        <div class="notif-img">
                          <img
                              src="/resources/assets/img/mlane.jpg"
                              alt="Img Profile"
                          />
                        </div>
                        <div class="notif-content">
                          <span class="subject">부산 창고 관리자</span>
                          <span class="block">
                                케냐 AA 생두 100PLT 금일 도착!
                              </span>
                          <span class="time">60 minutes ago</span>
                        </div>
                      </a>
                    </div>
                  </div>
                </li>
                <li>
                  <a class="see-all" href="javascript:void(0);"
                  >모든 메시지 보기<i class="fa fa-angle-right"></i>
                  </a>
                </li>
              </ul>
            </li>
            <%-- 우측상단 알람 아이콘  --%>
            <li class="nav-item topbar-icon dropdown hidden-caret">
              <a
                  class="nav-link dropdown-toggle"
                  href="#"
                  id="notifDropdown"
                  role="button"
                  data-bs-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
              >
                <i class="fa fa-bell"></i>
                <span class="notification">3</span>
              </a>
              <ul
                  class="dropdown-menu notif-box animated fadeIn"
                  aria-labelledby="notifDropdown"
              >
                <li>
                  <div class="dropdown-title">
                    You have 3 new notification
                  </div>
                </li>
                <li>
                  <div class="notif-scroll scrollbar-outer">
                    <div class="notif-center">
                      <a href="#">
                        <div class="notif-icon notif-primary">
                          <i class="fa fa-user-plus"></i>
                        </div>
                        <div class="notif-content">
                          <span class="block"> 새로운 회원 등록 요청 </span>
                          <span class="time">5 minutes ago</span>
                        </div>
                      </a>
                      <a href="#">
                        <div class="notif-icon notif-success">
                          <i class="fa fa-comment"></i>
                        </div>
                        <div class="notif-content">
                              <span class="block">
                                대덕 창고 관리자 의견 피드백
                              </span>
                          <span class="time">12 minutes ago</span>
                        </div>
                      </a>
                      <a href="#">
                        <div class="notif-icon notif-danger">
                          <i class="fa fa-heart"></i>
                        </div>
                        <div class="notif-content">
                          <span class="block"> 투썸 회원 입고 요청 확인 </span>
                          <span class="time">36 minutes ago</span>
                        </div>
                      </a>
                    </div>
                  </div>
                </li>
                <li>
                  <a class="see-all" href="javascript:void(0);"
                  >모든 알림 보러가기<i class="fa fa-angle-right"></i>
                  </a>
                </li>
              </ul>
            </li>
            <li class="nav-item topbar-icon dropdown hidden-caret">
              <a
                  class="nav-link"
                  data-bs-toggle="dropdown"
                  href="#"
                  aria-expanded="false"
              >
                <i class="fas fa-layer-group"></i>
              </a>
              <div class="dropdown-menu quick-actions animated fadeIn">
                <div class="quick-actions-header">
                  <span class="title mb-1">퀵 액션</span>
                  <span class="subtitle op-7">바로가기</span>
                </div>
                <div class="quick-actions-scroll scrollbar-outer">
                  <div class="quick-actions-items">
                    <div class="row m-0">
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div class="avatar-item bg-danger rounded-circle">
                            <i class="far fa-calendar-alt"></i>
                          </div>
                          <span class="text">작업현황</span>
                        </div>
                      </a>
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div
                              class="avatar-item bg-warning rounded-circle"
                          >
                            <i class="fas fa-map"></i>
                          </div>
                          <span class="text">창고현황</span>
                        </div>
                      </a>
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div class="avatar-item bg-info rounded-circle">
                            <i class="fas fa-file-excel"></i>
                          </div>
                          <span class="text">재무현황</span>
                        </div>
                      </a>
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div
                              class="avatar-item bg-success rounded-circle"
                          >
                            <i class="fas fa-envelope"></i>
                          </div>
                          <span class="text">이메일</span>
                        </div>
                      </a>
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div
                              class="avatar-item bg-primary rounded-circle"
                          >
                            <i class="fas fa-file-invoice-dollar"></i>
                          </div>
                          <span class="text">거래명세서</span>
                        </div>
                      </a>
                      <a class="col-6 col-md-4 p-0" href="#">
                        <div class="quick-actions-item">
                          <div
                              class="avatar-item bg-secondary rounded-circle"
                          >
                            <i class="fas fa-credit-card"></i>
                          </div>
                          <span class="text">결제대금</span>
                        </div>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </li>

            <%--  우측상단 프로필 --%>
            <li class="nav-item topbar-user dropdown hidden-caret">
              <a
                  class="dropdown-toggle profile-pic"
                  data-bs-toggle="dropdown"
                  href="#"
                  aria-expanded="false"
              >
                <div class="avatar-sm">
                  <img
                      src="/resources/assets/img/meow/sampleProfile.png"
                      alt="..."
                      class="avatar-img rounded-circle"
                  />
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
                        <img
                            src="/resources/assets/img/meow/meowCoffeeLogo1.png"
                            alt="image profile"
                            class="avatar-img rounded"
                        />
                      </div>
                      <div class="u-text">
                        <h4>야옹님</h4>
                        <p class="text-muted">meowCoffee@meow.com</p>
                        <a
                            href="#"
                            class="btn btn-xs btn-secondary btn-sm"
                        >프로필 보러가기</a
                        >
                      </div>
                    </div>
                  </li>
                  <li>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="#">로그 아웃</a>
                  </li>
                </div>
              </ul>
            </li>
          </ul>
        </div>
      </nav>
      <!-- End Navbar Header -->

      <!-- Header 하단 가로 네비게이션 -->
      <nav
          class="navbar navbar-expand-lg navbar-bottom border-bottom"
          data-background-color="dark"
      >
        <div class="container-fluid">
          <button
              class="navbar-toggler"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#headerSubnav"
              aria-controls="headerSubnav"
              aria-expanded="false"
              aria-label="Toggle navigation"
          >
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="headerSubnav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item dropdown">
                <a
                    class="nav-link dropdown-toggle"
                    href="#"
                    id="navDashboard"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                >
                  <i class="fas fa-truck-monster"></i>&nbsp; 입/출고 관리
                </a>
                <ul class="dropdown-menu" aria-labelledby="navDashboard" style="left: 0;">
                  <li><a class="dropdown-item" href="#">입/출고 현황</a></li>
                  <li><a class="dropdown-item" href="#">입고 관리<span class="badge bg-success ms-1">4</span></a></li>
                  <li><a class="dropdown-item" href="#">출고 관리<span class="badge bg-secondary ms-1">1</span></a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a
                    class="nav-link dropdown-toggle"
                    href="#"
                    id="navBase"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                >
                  <i class="fas fa-warehouse"></i> &nbsp; 창고/재고 관리
                </a>
                <ul class="dropdown-menu" aria-labelledby="navBase">
                  <li><a class="dropdown-item" href="#">창고 관리</a></li>
                  <li><a class="dropdown-item" href="#">재고 관리</a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a
                    class="nav-link dropdown-toggle"
                    href="#"
                    id="navSidebarLayouts"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                >
                  <i class="fas fa-money-bill"></i> &nbsp; 재무 관리
                </a>
                <ul
                    class="dropdown-menu"
                    aria-labelledby="navSidebarLayouts">
                  <li><a class="dropdown-item" href="#">매출 현황</a></li>
                  <li><a class="dropdown-item" href="#">지출 현황</a></li>
                </ul>
              </li>
            </ul>

            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
              <li class="nav-item me-2">
                <a
                    class="btn btn-outline-light btn-sm"
                    href="#"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#offcanvasSidebar"
                    aria-controls="offcanvasSidebar"
                >
                  <i class="fas fa-bars"></i>
                  <span class="d-none d-md-inline ms-1">메뉴</span>
                </a>
              </li>

              <li class="nav-item dropdown me-2">
                <a
                    class="nav-link dropdown-toggle"
                    href="#"
                    id="navQuick"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                >
                  <i class="fas fa-bolt"></i>
                  <span class="d-none d-md-inline ms-1">Quick</span>
                </a>
                <ul
                    class="dropdown-menu dropdown-menu-end"
                    aria-labelledby="navQuick"
                >
                  <li><a class="dropdown-item" href="#">입고 요청</a></li>
                  <li><a class="dropdown-item" href="#">출고 요청</a></li>
                  <li>
                    <hr class="dropdown-divider"/>
                  </li>
                  <li><a class="dropdown-item" href="#">많이 조회하는거</a></li>
                </ul>
              </li>

              <li class="nav-item dropdown">
                <a
                    class="nav-link dropdown-toggle d-flex align-items-center"
                    href="#"
                    id="navUser"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                >
                  <i class="fas fa-user-circle me-1"></i>
                  <span class="d-none d-md-inline">계정</span>
                </a>
                <ul
                    class="dropdown-menu dropdown-menu-end"
                    aria-labelledby="navUser"
                >
                  <li><a class="dropdown-item" href="/members/profile/${userId}">내 프로필</a></li>
                  <%-- 관리자 전용 메뉴 --%>
                  <li><a class="dropdown-item" href="/members/list">회원리스트 조회</a></li>
                  <li>
                    <hr class="dropdown-divider"/>
                  </li>
                  <li><a class="dropdown-item" href="#">로그아웃</a></li>
                </ul>
              </li>

            </ul>
          </div>
        </div>
      </nav>
    </div>

    <!-- 여기부터 각 JSP 파일의 메인 컨텐츠가 시작됩니다. -->
    <div class="container">
      <div class="page-inner">
        <!-- _header.jsp 종료 -->