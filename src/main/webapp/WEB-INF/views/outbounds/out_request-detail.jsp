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
            <h6 class="op-7 mb-2">요청 번호: <c:out value="${outReqId}" /></h6>
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
                            <div class="mb-2">
                                <small class="text-muted">거래처(ID)</small>
                                <div id="h-comId" class="fw-semibold">-</div>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">거래처명</small>
                                <div id="h-comName" class="fw-semibold">-</div>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">요청일시</small>
                                <div id="h-outDttmReq" class="fw-semibold">-</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-2">
                                <small class="text-muted">승인일시</small>
                                <div id="h-outDttmAppr" class="fw-semibold">-</div>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">희망 출고일</small>
                                <div id="h-outDateWish" class="fw-semibold">-</div>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">임시저장</small>
                                <div id="h-isTempo" class="fw-semibold">-</div>
                            </div>
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

                <!-- 액션 바 -->
                <div class="card-footer d-flex flex-wrap gap-2 justify-content-between align-items-center">
                    <!-- 좌측: 배차/승인 -->
                    <div class="d-flex align-items-center gap-2 flex-wrap" id="mgr-actions">
                        <!-- 드롭다운: 차량 선택 -->
                        <select id="vehicleSelect" class="form-select form-select-sm" style="min-width:240px">
                            <option value="" selected disabled>배차할 차량을 선택하세요</option>
                        </select>
                        <button type="button" class="btn btn-outline-primary btn-sm" id="btnDispatch">배차 등록</button>
                        <button type="button" class="btn btn-primary btn-sm" id="btnApprove">출고 승인</button>
                    </div>

                    <!-- 우측: 출고완료/새로고침 (운송장 생성 제거) -->
                    <div class="d-flex align-items-center gap-2 flex-wrap" id="mgr-actions-2">
                        <button type="button" class="btn btn-success btn-sm d-none" id="btnReceived">출고 완료 처리</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="btnReload">새로고침</button>
                    </div>
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
                <div class="small text-muted mt-1">재고ID: <span data-field="stkId">-</span></div>
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
<script>
    const outReqId      = '<c:out value="${outReqId}" default=""/>';
    const sessionRole   = '<c:out value="${sessionRole}" default=""/>';
    const sessionUserId = '<c:out value="${sessionUserId}" default=""/>';
    const apiBase       = '/outbounds/api/' + encodeURIComponent(outReqId);

    // 날짜 도우미
    function toKDate(value, withTime){
        if (value == null || value === '') return '-';
        try{
            let d;
            if (Array.isArray(value)) {
                const y=value[0], m=value[1], dd=value[2], hh=value[3]||0, mi=value[4]||0, ss=value[5]||0;
                d = new Date(y, m-1, dd, hh, mi, ss);
            } else { d = new Date(value); }
            return withTime ? d.toLocaleString('ko-KR') : d.toLocaleDateString('ko-KR');
        }catch(e){ return '-'; }
    }
    const fmtDate = (v)=>toKDate(v,false);
    const fmtDT   = (v)=>toKDate(v,true);
    const yn      = (v)=> (v===1||v==='1'||v===true)?'예':'아니오';

    function statusBadgeClass(code){
        switch((code||'').toUpperCase()){
            case 'PENDING':  return 'bg-warning text-dark';
            case 'APPROVED': return 'bg-primary';
            case 'SHIPPED':  return 'bg-success';
            case 'REJECTED': return 'bg-danger';
            default:         return 'bg-secondary';
        }
    }
    function show(el){ el.classList.remove('d-none'); }
    function hide(el){ el.classList.add('d-none'); }
    function text(el, v){ el.textContent = (v ?? '-') + ''; }

    // 헤더 렌더
    function renderHeader(h){
        const code = (h.status || 'PENDING').toUpperCase();
        const badge = document.getElementById('status-badge');
        badge.className = 'badge ' + statusBadgeClass(code);
        badge.textContent = h.statusValue || (code==='PENDING'?'승인대기':code);

        text(document.getElementById('h-comId'), h.comId);
        text(document.getElementById('h-comName'), h.comName);
        text(document.getElementById('h-outDttmReq'), fmtDT(h.outDttmReq));
        text(document.getElementById('h-outDttmAppr'), fmtDT(h.outDttmAppr));
        text(document.getElementById('h-outDateWish'), fmtDate(h.outDateWish));
        text(document.getElementById('h-isTempo'), yn(h.isTempo));
        show(document.getElementById('header-section'));

        const mgrBar  = document.getElementById('mgr-actions');
        const btnRecv = document.getElementById('btnReceived');

        if (code === 'PENDING'){
            show(mgrBar);
            hide(btnRecv);
        } else if (code === 'APPROVED'){
            hide(mgrBar);
            show(btnRecv);
        } else {
            hide(mgrBar);
            hide(btnRecv);
        }
    }

    // 아이템 렌더
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
            list.forEach(it=>{
                const node = tpl.content.cloneNode(true);
                node.querySelector('[data-field="cfName"]').textContent      = it.cfName ?? '-';
                node.querySelector('[data-field="cfId"]').textContent        = it.cfId ?? '-';
                node.querySelector('[data-field="cfCategory"]').textContent  = it.cfCategory ?? '-';
                node.querySelector('[data-field="cfGrade"]').textContent     = it.cfGrade ?? '-';
                node.querySelector('[data-field="stkId"]').textContent       = it.stkId ?? '-';
                node.querySelector('[data-field="outQtyReq"]').textContent   = it.outQtyReq ?? '-';
                node.querySelector('[data-field="outOrderAddr"]').textContent= it.outOrderAddr ?? '-';

                const code = (it.status || 'PENDING').toUpperCase();
                const badge = node.querySelector('[data-field="statusValue"]');
                badge.textContent = it.statusValue ?? it.status ?? '-';
                badge.className   = 'badge ' + statusBadgeClass(code);

                node.querySelector('[data-field="vehicleId"]').textContent   = it.vehicleId ?? '-';
                box.appendChild(node);
            });
        }
        show(wrap); show(sep);
    }

    // API
    async function get(url){ const r=await axios.get(url); return r.data; }
    async function post(url){ const r=await axios.post(url); return (r.data&&(r.data.message||r.data))||'처리되었습니다.'; }

    function showError(e){
        const box = document.getElementById('error');
        const msg = e?.response?.data
            ? (typeof e.response.data === 'string' ? e.response.data : JSON.stringify(e.response.data))
            : (e?.message || '요청 중 오류가 발생했습니다.');
        box.textContent = msg;
        box.classList.remove('d-none');
    }

    // 차량 드롭다운 로딩
    async function loadVehicles(){
        try{
            const sel = document.getElementById('vehicleSelect');
            sel.innerHTML = '<option value="" selected disabled>배차할 차량을 선택하세요</option>';
            const list = await get('/outbounds/api/vehicles');
            if(Array.isArray(list) && list.length){
                list.forEach(v=>{
                    const opt = document.createElement('option');
                    opt.value = v.vehicleId;
                    opt.textContent = v.vehicleId + (v.vehicleModel ? (' · ' + v.vehicleModel) : '');
                    sel.appendChild(opt);
                });
            }else{
                const opt = document.createElement('option');
                opt.disabled = true;
                opt.textContent = '등록된 차량이 없습니다';
                sel.appendChild(opt);
            }
        }catch(e){ showError(e); }
    }

    // 액션
    async function actionDispatch(){
        try{
            const v = document.getElementById('vehicleSelect').value;
            if(!v){ alert('배차할 차량을 선택하세요.'); return; }
            const msg = await post(apiBase + '/dispatch?vehicleId=' + encodeURIComponent(v));
            alert(msg);
            await loadDetail();
        }catch(e){ showError(e); }
    }

    async function actionApprove(){
        try{
            let mid = (sessionUserId || '').trim();
            if(!mid){ mid = prompt('승인 관리자 ID를 입력하세요:') || ''; }
            if(!mid) return;

            const msg = await post(apiBase + ':approve?managerId=' + encodeURIComponent(mid));
            alert(msg);

            // 승인 완료 후 목록 페이지로 이동
            window.location.href = '/outbounds';
        }catch(e){
            showError(e);
        }
    }

    async function actionReceived(){
        try{
            if(!confirm('출고 완료로 처리하시겠습니까?')) return;
            alert(await post(apiBase + ':received'));
            location.href = '/outbounds';
        }catch(e){ showError(e); }
    }

    // 상세 로딩
    async function loadDetail(){
        try{
            document.getElementById('error').classList.add('d-none');
            const loading = document.getElementById('loading');
            loading.classList.remove('d-none');

            const header = await get(apiBase);
            renderHeader(header);

            const items  = await get(apiBase + '/items');
            renderItems(items);

            loading.classList.add('d-none');
        }catch(e){ showError(e); }
    }

    // init
    document.addEventListener('DOMContentLoaded', ()=>{
        document.getElementById('btnDispatch').addEventListener('click', actionDispatch);
        document.getElementById('btnApprove').addEventListener('click', actionApprove);
        document.getElementById('btnReceived').addEventListener('click', actionReceived);
        document.getElementById('btnReload').addEventListener('click', loadDetail);

        loadVehicles();
        loadDetail();
    });
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
