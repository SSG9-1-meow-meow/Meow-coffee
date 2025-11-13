<%--
  Created by IntelliJ IDEA.
  User: a
  Date: 2025-11-11
  Time: 오전 11:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                        href="/auth/register-select"
                        role="button"
                        aria-expanded="false"
                        aria-controls="oc-dashboard"
                >
                    <i class="fas fa-user-plus"></i> 회원가입
                </a>
            </li>
            <li class="nav-item mt-2">
                <a
                        class="nav-link"
                        href="#"
                        role="button"
                        aria-expanded="false"
                        aria-controls="oc-base"
                >
                    <i class="fas fa-id-card"></i> 아이디 찾기
                </a>
            </li>
            <li class="nav-item mt-2">
                <a
                        class="nav-link"
                        data-bs-toggle="collapse"
                        href="#"
                        role="button"
                        aria-expanded="false"
                        aria-controls="oc-sidebarLayouts"
                >
                    <i class="fas fa-key"></i> 비밀번호 찾기
                </a>
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
                    <!-- Center: 페이지 제목 -->
                    <a href="/" class="navbar-brand mx-auto w-66">
                        <img src="/resources/assets/img/meow/meowCoffeeLogo2.png" alt="Meow Coffee Logo"
                             style="height: 5rem; width: auto; margin-center: 8px;">
                        <span class="">Meow 커피 창고 관리 시스템</span>
                    </a>

                    <!-- Topbar 오른쪽 아이콘 및 사용자 메뉴 -->
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

                        </ul>
                    </div>
                </div>
            </nav>
        </div>
