<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<c:set var="outReqId" value="${outReqId}" />
<c:set var="sessionUserId" value="${sessionUserId}" />
<c:set var="sessionRole" value="${sessionRole}" />

<div class="page-inner">
    <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
        <div>
            <h3 class="fw-bold mb-1">출고 요청 상세</h3>
            <h6 class="op-7 mb-2">요청 번호: <c:out value="${outReqId}" default="-" /></h6>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12" id="request-panel">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="card-title mb-0">요청 정보</h4>
                    <span id="status-badge" class="badge bg-secondary">-</span>
                </div>

                <div class="card-body">
                    <div id="loading" class="text-center py-4">
                        <div class="spinner-border" role="status"></div>
                        <p class="mt-2 mb-0 small text-muted">데이터를 불러오는 중…</p>
                    </div>
                    <div id="error" class="alert alert-danger d-none"></div>

                    <div id="header-section" class="row d-none">
                        <div class="col-md-6">
                            <div class="mb-2"><small class="text-muted">거래처(ID)</small><div id="h-comId" class="fw-semibold">-</div></div>
                            <div class="mb-2"><small class="text-muted">거래처명</small><div id="h-comName" class="fw-semibold">-</div></div>
                            <div class="mb-2"><small class="text-muted">요청일시</small><div id="h-outDttmReq" class="fw-semibold">-</div></div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-2"><small class="text-muted">승인일시</small><div id="h-outDttmAppr" class="fw-semibold">-</div></div>
                            <div class="mb-2"><small class="text-muted">희망 출고일</small><div id="h-outDateWish" class="fw-semibold">-</div></div>
                            <div class="mb-2"><small class="text-muted">임시저장</small><div id="h-isTempo" class="fw-semibold">-</div></div>
                        </div>
                    </div>

                    <hr class="my-4 d-none" id="items-sep"/>

                    <div id="items-section" class="d-none">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="mb-0">요청 품목</h5>
                        </div>
                        <div id="items-container"></div>
                    </div>
                </div>

                <div class="card-footer d-flex flex-wrap gap-2 justify-content-end" id="actions">
                    <!-- 버튼들 동적 렌더 -->
                </div>
            </div>
        </div>
    </div>
</div>

<template id="item-row-tpl">
    <div class="border rounded p-3 mb-2">
        <div class="d-flex justify-content-between align-items-start">
            <div class="me-3">
                <div class="fw-semibold" data-field="cfName">-</div>
                <div class="small text-muted">
                    <span data-field="cfId">-</span> ·
                    <span data-field="cfCategory">-</span> ·
                    <span data-field="cfGrade">-</span>
                </div>
                <div class="small text-muted mt-1">
                    재고ID: <span data-field="stkId">-</span>
                </div>
                <div class="mt-1">신청 수량: <b data-field="outQtyReq">-</b> PLT</div>
                <div class="small mt-1">배송지: <span data-field="outOrderAddr">-</span></div>
            </div>
            <div class="text-end">
                <span class="badge bg-secondary mb-2" data-field="statusValue">-</span>
                <div class="small">배차 차량: <b data-field="vehicleId">-</b></div>
            </div>
        </div>
    </div>
</template>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script>
    const outReqId = '<c:out value="${outReqId}" default=""/>';
    const sessionRole = '<c:out value="${sessionRole}" default=""/>';
    const sessionUserId = '<c:out value="${sessionUserId}" default=""/>';
    const apiBase = '/outbounds/api/' + encodeURIComponent(outReqId);

    // ---- [핵심 수정] 날짜 헬퍼: 배열/문자열/Date 모두 대응 ----
    function toKDate(value, withTime){
        if (value == null || value === '') return '-';
        try{
            let d;
            if (Array.isArray(value)) {
                // [yyyy, mm, dd, hh?, mi?, ss?]
                const y=value[0], m=value[1], dd=value[2], hh=value[3]||0, mi=value[4]||0, ss=value[5]||0;
                d = new Date(y, m-1, dd, hh, mi, ss);
            } else if (typeof value === 'string') {
                // '2025-11-13T12:34:56' 또는 '2025-11-13'
                d = new Date(value);
            } else if (value instanceof Date) {
                d = value;
            } else {
                // 혹시 모를 케이스: 그대로 문자열화
                return String(value);
            }
            return withTime ? d.toLocaleString('ko-KR') : d.toLocaleDateString('ko-KR');
        }catch(e){ return '-'; }
    }
    // 상세 화면에서 쓰는 포맷 함수들 → 목록과 동일한 로직을 사용
    const fmtDate = (v) => toKDate(v, false);
    const fmtDT   = (v) => toKDate(v, true);

    function yn(v){
        // 0/1, '0'/'1', true/false 모두 대응
        return (v === 1 || v === '1' || v === true) ? '예' : '아니오';
    }

    function statusBadgeClass(code) {
        switch((code||'').toUpperCase()){
            case 'PENDING':   return 'bg-warning text-dark';
            case 'APPROVED':  return 'bg-primary';
            case 'SHIPPED':   return 'bg-success';
            case 'REJECTED':  return 'bg-danger';
            default:          return 'bg-secondary';
        }
    }

    function show(el){ el.classList.remove('d-none'); }
    function hide(el){ el.classList.add('d-none'); }
    function text(el, v){ el.textContent = (v ?? '-') + ''; }

    function renderHeader(header){
        const h = header || {};
        const badge = document.getElementById('status-badge');

        const codeForBadge = (h.status || 'PENDING').toUpperCase();
        badge.className = 'badge ' + statusBadgeClass(codeForBadge);
        badge.textContent = h.statusValue || '-';

        text(document.getElementById('h-comId'), h.comId);
        text(document.getElementById('h-comName'), h.comName);
        text(document.getElementById('h-outDttmReq'), fmtDT(h.outDttmReq));
        text(document.getElementById('h-outDttmAppr'), fmtDT(h.outDttmAppr));
        text(document.getElementById('h-outDateWish'), fmtDate(h.outDateWish));
        text(document.getElementById('h-isTempo'), yn(h.isTempo));

        show(document.getElementById('header-section'));
    }

    function renderItems(items){
        const list = Array.isArray(items) ? items : [];
        const wrap = document.getElementById('items-section');
        const sep  = document.getElementById('items-sep');
        const box  = document.getElementById('items-container');
        box.innerHTML = '';

        if(list.length === 0){
            box.innerHTML = '<div class="text-muted small">등록된 품목이 없습니다.</div>';
        }else{
            const tpl = document.getElementById('item-row-tpl');
            list.forEach(it => {
                const node = tpl.content.cloneNode(true);
                node.querySelector('[data-field="cfName"]').textContent = it.cfName ?? '-';
                node.querySelector('[data-field="cfId"]').textContent = it.cfId ?? '-';
                node.querySelector('[data-field="cfCategory"]').textContent = it.cfCategory ?? '-';
                node.querySelector('[data-field="cfGrade"]').textContent = it.cfGrade ?? '-';
                node.querySelector('[data-field="stkId"]').textContent = it.stkId ?? '-';
                node.querySelector('[data-field="outQtyReq"]').textContent = it.outQtyReq ?? '-';
                node.querySelector('[data-field="outOrderAddr"]').textContent = it.outOrderAddr ?? '-';

                const code = (it.status || 'PENDING').toUpperCase();
                node.querySelector('[data-field="statusValue"]').textContent = it.statusValue ?? it.status ?? '-';
                node.querySelector('[data-field="statusValue"]').className = 'badge ' + statusBadgeClass(code);

                node.querySelector('[data-field="vehicleId"]').textContent = it.vehicleId ?? '-';
                box.appendChild(node);
            });
        }
        show(wrap); show(sep);
    }

    function renderActions(header, session){
        const role = (session?.role || sessionRole || '').toUpperCase();
        const code = (header?.status || 'PENDING').toUpperCase();
        const area = document.getElementById('actions');
        area.innerHTML = '';

        area.appendChild(btn('새로고침', 'btn-outline-secondary', loadDetail));

        if (role === 'MANAGER' || role === 'ADMIN'){
            if (code === 'PENDING'){
                area.appendChild(btn('배차 등록', 'btn-outline-primary', openDispatch));
                area.appendChild(btn('출고지시서 생성', 'btn-outline-info', () => post(apiBase + '/order')));
                area.appendChild(btn('관리자 승인', 'btn-primary', approve));
            }
        }
        if (role === 'COMPANY'){
            if (code === 'PENDING'){
                area.appendChild(btn('요청 취소', 'btn-danger', softDelete));
            }
        }
        if (code === 'APPROVED'){
            area.appendChild(btn('운송장 생성', 'btn-outline-dark', () => post(apiBase + '/waybill')));
            area.appendChild(btn('출고 완료 처리', 'btn-success', () => post(apiBase + ':received', { redirect: '/outbounds' })));
        }
    }

    function btn(label, klass, handler){
        const b = document.createElement('button');
        b.type = 'button';
        b.className = 'btn ' + klass;
        b.textContent = label;
        b.addEventListener('click', handler);
        return b;
    }

    async function approve(){
        const managerId = prompt('승인할 관리자 ID를 입력하세요:', sessionUserId || '');
        if(!managerId) return;
        await post(apiBase + ':approve?managerId=' + encodeURIComponent(managerId));
    }

    async function openDispatch(){
        const vehicleId = prompt('배차할 차량 ID를 입력하세요:');
        if(!vehicleId) return;
        await post(apiBase + '/dispatch?vehicleId=' + encodeURIComponent(vehicleId));
    }

    async function softDelete(){
        if(!confirm('이 출고 요청을 취소하시겠습니까?')) return;
        const comId = prompt('거래처 ID 확인 입력:', '');
        if(!comId) return;
        await post(apiBase + ':delete?comId=' + encodeURIComponent(comId));
    }

    async function get(url){
        try{
            const res = await axios.get(url);
            return res.data;
        }catch(e){
            showError(e);
            throw e;
        }
    }

    async function post(url, opts = {}) {
        try{
            const res = await axios.post(url);
            alert((res.data && (res.data.message || res.data)) || '처리되었습니다.');
            if (opts.redirect) {
                window.location.href = opts.redirect;
                return;
            }
            await loadDetail();
        }catch(e){
            showError(e);
        }
    }

    function showError(e){
        const box = document.getElementById('error');
        const msg = e?.response?.data ? (typeof e.response.data === 'string' ? e.response.data : JSON.stringify(e.response.data)) : (e?.message || '요청 중 오류가 발생했습니다.');
        box.textContent = msg;
        box.classList.remove('d-none');
    }

    async function loadDetail(){
        hide(document.getElementById('error'));
        const loading = document.getElementById('loading');
        const headerSec = document.getElementById('header-section');
        const itemsSec = document.getElementById('items-section');
        hide(headerSec); hide(itemsSec); show(loading);

        // 단일 DTO(헤더) → 아이템은 별도 호출
        const header = await get(apiBase);
        renderHeader(header);

        const items = await get(apiBase + '/items');
        renderItems(items);

        renderActions(header, { role: sessionRole, userId: sessionUserId });
        hide(loading);
    }

    document.addEventListener('DOMContentLoaded', loadDetail);
</script>


<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
