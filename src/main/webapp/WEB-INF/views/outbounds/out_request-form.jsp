<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<div class="page-inner">
    <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
        <div>
            <h3 class="fw-bold mb-3">신규 출고 요청</h3>
            <h6 class="op-7 mb-2">출고할 품목을 추가하고 요청을 완료하세요.</h6>
        </div>
        <div class="ms-md-auto mt-2 mt-md-0">
            <a href="${pageContext.request.contextPath}/outbounds" class="btn btn-outline-secondary">
                <i class="fa fa-list"></i> 목록으로
            </a>
        </div>
    </div>

    <div class="row">
        <!-- 왼쪽: 재고 참고 목록만 표시 -->
        <div class="col-md-5">
            <div class="card">
                <div class="card-header"><h4 class="card-title">재고 목록 (참고)</h4></div>
                <div class="card-body" style="height: 560px; overflow-y:auto;">
                    <ul class="list-group list-group-flush">
                        <c:forEach items="${stockList}" var="stk">
                            <li class="list-group-item">
                                <strong>${stk.cfName}</strong>
                                <small class="text-muted"> (${stk.stkId})</small><br/>
                                <small class="text-muted">${stk.cfCategory} · ${stk.cfGrade} · ${stk.whName}</small>
                                <span class="badge bg-secondary float-end">${stk.stkQuantity}</span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty stockList}">
                            <li class="list-group-item text-muted">모델에서 stockList 미전달 — 직접 입력해도 됩니다.</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 오른쪽: 출고 요청 양식 -->
        <div class="col-md-7">
            <div class="card">
                <div class="card-header"><h4 class="card-title">요청 정보</h4></div>
                <div class="card-body">
                    <!-- 기본 정보 -->
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">거래처 ID (comId) <span class="text-danger">*</span></label>
                            <input type="text" id="comId" class="form-control"
                                   value="${presetComId}" <c:if test="${not empty presetComId}">readonly</c:if>
                                   placeholder="예: company_good">
                            <div class="form-text">companies 뷰의 userId</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">담당 관리자 ID (managerId) <span class="text-danger">*</span></label>
                            <select id="managerId" class="form-select" <c:if test="${not empty presetMgrId}">disabled</c:if>>
                                <c:if test="${empty presetMgrId}">
                                    <option value="" selected disabled>-- 선택 --</option>
                                    <c:forEach items="${managerList}" var="m">
                                        <option value="${m.managerId}">${m.managerName} (${m.managerId})</option>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${not empty presetMgrId}">
                                    <option value="${presetMgrId}" selected>${presetMgrId}</option>
                                </c:if>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">출고 희망일 (outDateWish) <span class="text-danger">*</span></label>
                            <input type="date" id="outDateWish" class="form-control">
                            <small id="date-help" class="form-text text-primary"></small>
                        </div>
                        <div class="col-md-12">
                            <div class="form-check mt-1">
                                <input class="form-check-input" type="checkbox" id="isTempo">
                                <label class="form-check-label" for="isTempo">임시 저장</label>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4"/>

                    <!-- 품목 테이블: 배송지 필수 -->
                    <div class="d-flex align-items-center mb-2">
                        <h5 class="mb-0">출고 품목</h5>
                        <button type="button" class="btn btn-sm btn-primary ms-auto" id="btnAddRow">
                            <i class="fa fa-plus"></i> 행 추가
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered align-middle" id="itemsTable">
                            <thead class="table-light">
                            <tr>
                                <th style="width:22%">재고ID</th>
                                <th style="width:16%">요청수량</th>
                                <!-- ★ 배송지에도 필수 표시(*) 추가 -->
                                <th>배송지 주소 <span class="text-danger">*</span></th>
                                <th style="width:8%"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td><input type="text" class="form-control stkIdInp" placeholder="예: STK001"></td>
                                <td><input type="number" min="1" class="form-control outQtyReq" placeholder="예: 10"></td>
                                <td><input type="text" class="form-control outOrderAddr" placeholder="예: 서울시 강남구 ..."></td>
                                <td class="text-center"><button class="btn btn-sm btn-outline-danger btnDelRow"><i class="fa fa-trash"></i></button></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex gap-2 mt-3">
                        <button class="btn btn-secondary" id="btnTempSave"><i class="fa fa-save"></i> 임시 저장</button>
                        <button class="btn btn-primary" id="btnSubmit"><i class="fa fa-paper-plane"></i> 출고 요청 제출</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 행 템플릿 -->
<template id="row-tpl">
    <tr>
        <td><input type="text" class="form-control stkIdInp" placeholder="예: STK001"></td>
        <td><input type="number" min="1" class="form-control outQtyReq" placeholder="예: 5"></td>
        <td><input type="text" class="form-control outOrderAddr" placeholder="예: 서울시 송파구 ..."></td>
        <td class="text-center"><button class="btn btn-sm btn-outline-danger btnDelRow"><i class="fa fa-trash"></i></button></td>
    </tr>
</template>

<script>
    const ctx = '${pageContext.request.contextPath}';
    const apiUrl = ctx + '/outbounds/api/req';

    function ymd(n){ return n.toISOString().split('T')[0]; }

    function initWishDate(){
        const inp = document.getElementById('outDateWish');
        const help = document.getElementById('date-help');
        const base = new Date();
        base.setDate(base.getDate() + 3);
        const v = ymd(base);
        inp.value = v;
        inp.min = v;
        help.textContent = '출고 희망일은 ' +
            base.toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric'}) +
            ' 이후로 선택 가능합니다.';
    }

    function addRow(){
        const tpl = document.getElementById('row-tpl');
        const row = tpl.content.firstElementChild.cloneNode(true);
        document.querySelector('#itemsTable tbody').appendChild(row);
    }

    // 배송지(outOrderAddr) 필수 검증
    // ➜ requireAddr 파라미터 추가
    function collectItems(requireAddr){
        const rows = document.querySelectorAll('#itemsTable tbody tr');
        const items = [];
        rows.forEach(r=>{
            const stkId        = r.querySelector('.stkIdInp').value.trim();
            const outQtyReq    = parseInt(r.querySelector('.outQtyReq').value || '0',10);
            const outOrderAddr = r.querySelector('.outOrderAddr').value.trim();

            // 완전 공백 행이면 무시
            if(!stkId && !outQtyReq && !outOrderAddr) return;

            if(!stkId)        throw new Error('재고ID(stkId)는 필수입니다.');
            if(!outQtyReq || outQtyReq < 1) throw new Error('요청수량은 1 이상이어야 합니다.');
            // ★ 임시저장이 아닐 때만 배송지 필수
            if(requireAddr && !outOrderAddr) throw new Error('배송지 주소는 필수입니다.');

            items.push({stkId, outQtyReq, outOrderAddr});
        });
        if(!items.length) throw new Error('최소 1개 이상의 품목을 입력하세요.');
        return items;
    }


    async function submit(isTempo){
        try{
            const comId = document.getElementById('comId').value.trim();
            const managerIdSel = document.getElementById('managerId');
            const managerId = managerIdSel.disabled ? managerIdSel.options[0].value : managerIdSel.value;
            const outDateWish = document.getElementById('outDateWish').value;
            const tempo = (isTempo ? 1 : (document.getElementById('isTempo').checked ? 1 : 0));

            // ★ 공통: comId 는 항상 필수
            if(!comId) throw new Error('거래처 ID는 필수입니다.');

            // ★ 임시저장이 아닐 때만 강제
            if(!isTempo && !managerId)   throw new Error('담당 관리자 ID는 필수입니다.');
            if(!isTempo && !outDateWish) throw new Error('출고 희망일은 필수입니다.');

            // ★ 임시저장일 때는 배송지 선택 안해도 통과
            const items = collectItems(!isTempo); // isTempo=false → 배송지 필수, true → 선택

            const payload = {
                comId,
                // managerId / outDateWish 는 없으면 null 로 보냄 (DB 컬럼이 NULL 허용)
                managerId:   managerId || null,
                outDateWish: outDateWish || null,
                isTempo: tempo,
                outItemsJson: JSON.stringify(items),
                outDttmReq: new Date().toISOString()
            };

            const res = await axios.post(apiUrl, payload, {headers:{'Content-Type':'application/json'}});
            alert(res.data || (isTempo ? '임시 저장이 완료되었습니다.' : '출고 요청이 생성되었습니다.'));
            location.href = ctx + '/outbounds';
        }catch(e){
            console.error(e);
            alert(e.response?.data || e.message || '요청 처리 중 오류가 발생했습니다.');
        }
    }


    document.addEventListener('DOMContentLoaded', ()=>{
        initWishDate();
        document.getElementById('btnAddRow').addEventListener('click', addRow);
        document.getElementById('itemsTable').addEventListener('click',(e)=>{
            if(e.target.closest('.btnDelRow')){
                const tr = e.target.closest('tr');
                const tbody = document.querySelector('#itemsTable tbody');
                if(tbody.querySelectorAll('tr').length>1) tr.remove();
                else tr.querySelectorAll('input').forEach(i=>i.value='');
            }
        });
        document.getElementById('btnTempSave').addEventListener('click',()=>submit(true));
        document.getElementById('btnSubmit').addEventListener('click',()=>submit(false));
    });
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>