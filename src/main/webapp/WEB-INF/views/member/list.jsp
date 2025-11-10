<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp"%>

<div class="page-header">
    <h3 class="fw-bold mb-3">회원관리</h3>
    <ul class="breadcrumbs mb-3">
        <li class="nav-home">
            <a href="#">
                <i class="icon-home"></i>
            </a>
        </li>
        <li class="separator">
            <i class="icon-arrow-right"></i>
        </li>
        <li class="nav-item">
            <a href="#">회원관리</a>
        </li>
        <li class="separator">
            <i class="icon-arrow-right"></i>
        </li>
        <li class="nav-item">
            <a href="#">회원리스트</a>
        </li>
    </ul>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="card-title">회원 검색 필터</div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6 col-lg-4">
                        <label class="mb-3"><b>회원유형/상태별 구분</b></label>
                        <div class="form-group form-group-default">
                            <label class="form-label">회원유형</label>
                            <div class="selectgroup w-100">
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="userRole"
                                            value="COMPANY"
                                            class="selectgroup-input"
                                            checked=""
                                    />
                                    <span class="selectgroup-button">거래처</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="userRole"
                                            value="MANAGER"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">창고관리자</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="userRole"
                                            value="ADMIN"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">총관리자</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="userRole"
                                            value="DELIVERYMAN"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">배송기사</span>
                                </label>
                            </div>
                        </div>
                        <div class="form-group form-group-default">
                            <label class="form-label">회원상태</label>
                            <div class="selectgroup w-100">
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="value"
                                            value="COMPANY"
                                            class="selectgroup-input"
                                            checked="checked"
                                    />
                                    <span class="selectgroup-button">승인대기</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="value"
                                            value="MANAGER"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">승인완료</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="value"
                                            value="ADMIN"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">휴면대기</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="radio"
                                            name="value"
                                            value="DELIVERYMAN"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">휴면상태</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <label class="mb-3"><b>키워드 검색</b></label>
                        <div class="form-group form-group-default">
                            <div>
                                <label class="form-label">키워드 검색 옵션</label>
                            </div>
                            <div class="selectgroup selectgroup-pills">
                                <label class="selectgroup-item">
                                    <input
                                            type="checkbox"
                                            name="value"
                                            value="name"
                                            class="selectgroup-input"
                                            checked=""
                                    />
                                    <span class="selectgroup-button">아이디</span>
                                </label>
                                <label class="selectgroup-item">
                                    <input
                                            type="checkbox"
                                            name="value"
                                            value="id"
                                            class="selectgroup-input"
                                    />
                                    <span class="selectgroup-button">이름</span>
                                </label>
                            </div>
                        </div>
                        <div class="form-group form-group-default">
                            <label>이름/아이디 검색</label>
                            <input
                                    id="Name"
                                    type="text"
                                    class="form-control"
                                    placeholder="검색할 키워드 입력"
                            />
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <label class="mb-3"><b>기간별 구분</b></label>
                        <div class="form-group form-group-default">
                            <label for="from">시작 날짜</label>
                            <input
                                    type="date"
                                    class="form-control form-control"
                                    id="from"
                                    placeholder="시작일"
                            />
                        </div>

                        <div class="form-group form-group-default">
                            <label for="to">마지막 날짜</label>
                            <input
                                    type="date"
                                    class="form-control form-control"
                                    id="to"
                                    placeholder="시작일"
                            />
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-action">
                <div class="d-flex align-items-center">
                    <button
                            class="btn btn-primary btn-round ms-auto"
                            type="submit"
                    >
                        검색
                    </button>
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center">
                    <h4 class="card-title">회원리스트</h4>
                    <button
                            class="btn btn-primary btn-round ms-auto"
                            data-bs-toggle="modal"
                            data-bs-target="#addRowModal"
                    >
                        Add
                    </button>
                </div>
            </div>
            <div class="card-body">
                <!-- Modal -->
                <div
                        class="modal fade"
                        id="addRowModal"
                        tabindex="-1"
                        role="dialog"
                        aria-hidden="true"
                >
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header border-0">
                                <h5 class="modal-title">
                                    <span class="fw-mediumbold"> New</span>
                                    <span class="fw-light"> Row </span>
                                </h5>
                                <button
                                        type="button"
                                        class="close"
                                        data-dismiss="modal"
                                        aria-label="Close"
                                >
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <p class="small">
                                    Create a new row using this form, make sure you
                                    fill them all
                                </p>
                                <form>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group form-group-default">
                                                <label>Name</label>
                                                <input
                                                        id="addName"
                                                        type="text"
                                                        class="form-control"
                                                        placeholder="fill name"
                                                />
                                            </div>
                                        </div>
                                        <div class="col-md-6 pe-0">
                                            <div class="form-group form-group-default">
                                                <label>Position</label>
                                                <input
                                                        id="addPosition"
                                                        type="text"
                                                        class="form-control"
                                                        placeholder="fill position"
                                                />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group form-group-default">
                                                <label>Office</label>
                                                <input
                                                        id="addOffice"
                                                        type="text"
                                                        class="form-control"
                                                        placeholder="fill office"
                                                />
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer border-0">
                                <button
                                        type="button"
                                        id="addRowButton"
                                        class="btn btn-primary"
                                >
                                    수정
                                </button>
                                <button
                                        type="button"
                                        class="btn btn-danger"
                                        data-dismiss="modal"
                                >
                                    닫기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table
                            id="add-row"
                            class="display table table-striped table-hover"
                    >
                        <thead>
                        <tr>
                            <th>아이디</th>
                            <th>회원유형</th>
                            <th>이름</th>
                            <th>회원상태</th>
                            <th>회원등록일</th>
                            <th>마지막 로그인</th>
                            <th style="width: 10%">회원상태 변경</th>
                        </tr>
                        </thead>
                        <tbody>
<%--                            <c:forEach items="${userList}" var="user">--%>
<%--                                <tr>--%>
<%--                                    <td><c:out value="${user.userId}"/></td>--%>
<%--                                    <td><c:out value="${user.userRole.getValue()}"/></td>--%>
<%--                                    <td><c:out value="${user.userName}"/></td>--%>
<%--                                    <td><c:out value="${user.userStatus.getValue()}"/></td>--%>
<%--                                    <td><c:out value="${user.userJoinDate == null ? '-' : user.userJoinDate}"/></td>--%>
<%--                                    <td><c:out value="${user.userLastLogin == null ? '-' : user.userLastLogin}"/></td>--%>
<%--                                    <td>--%>
<%--                                        <div class="form-button-action">--%>
<%--                                            <button--%>
<%--                                                    type="button"--%>
<%--                                                    data-bs-toggle="tooltip"--%>
<%--                                                    title=""--%>
<%--                                                    class="btn btn-link btn-primary btn-lg"--%>
<%--                                                    data-original-title="Edit Task"--%>
<%--                                            >--%>
<%--                                                <i class="fa fa-edit"></i>--%>
<%--                                            </button>--%>
<%--                                            <button--%>
<%--                                                    type="button"--%>
<%--                                                    data-bs-toggle="tooltip"--%>
<%--                                                    title=""--%>
<%--                                                    class="btn btn-link btn-danger"--%>
<%--                                                    data-original-title="Remove"--%>
<%--                                            >--%>
<%--                                                <i class="fa fa-times"></i>--%>
<%--                                            </button>--%>
<%--                                        </div>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                            </c:forEach>--%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>

</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp"%>
