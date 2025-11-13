<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div><h3 class="fw-bold mb-3">청구 관리 목록</h3></div>
</div>

<div class="row g-3" id="invoice-kpis">
    <div class="col-md-3"><div class="card shadow-sm border-0 rounded-4"><div class="card-body">
        <div class="text-muted small mb-1">이번 달 총 청구(만원)</div>
        <div id="kpi-inv-total" class="h4 fw-bold">₩0</div>
    </div></div></div>
    <div class="col-md-3"><div class="card shadow-sm border-0 rounded-4"><div class="card-body">
        <div class="text-muted small mb-1">입금 완료율</div>
        <div id="kpi-inv-paidPct" class="h4 fw-bold">0%</div>
    </div></div></div>
    <div class="col-md-3"><div class="card shadow-sm border-0 rounded-4"><div class="card-body">
        <div class="text-muted small mb-1">발행 중</div>
        <div id="kpi-inv-issuing" class="h4 fw-bold">0건</div>
    </div></div></div>
    <div class="col-md-3"><div class="card shadow-sm border-0 rounded-4"><div class="card-body">
        <div class="text-muted small mb-1">미납</div>
        <div id="kpi-inv-unpaid" class="h4 fw-bold">0건</div>
    </div></div></div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center">
                    <h4 class="card-title">청구 목록 필터</h4>
                    <button class="btn btn-primary btn-round ms-auto" id="btnSearch"><i class="fa fa-search"></i> 검색</button>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <label for="invStatus" class="form-label">상태</label>
                        <select class="form-select" id="invStatus">
                            <option value="">전체</option><option value="draft">작성</option><option value="issued">발행</option><option value="paid">입금</option><option value="canceled">취소</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="userId" class="form-label">거래처</label>
                        <input type="text" class="form-control" id="userId" placeholder="거래처 ID 입력">
                    </div>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped mt-3">
                        <thead>
                        <tr>
                            <th>청구ID</th><th>청구일</th><th>금액(만원)</th><th>상태</th><th>입금일</th><th>거래처ID</th><th>작업</th>
                        </tr>
                        </thead>
                        <tbody id="invoice-tbody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="invConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-sm"><div class="modal-content">
        <div class="modal-header"><h5 class="modal-title">상태 변경</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button></div>
        <div class="modal-body"><p class="mb-0">청구ID <strong id="invConfirmId"></strong> 을(를) <strong id="invConfirmTargetText"></strong> 상태로 변경할까요?</p></div>
        <div class="modal-footer"><button class="btn btn-secondary" data-bs-dismiss="modal">취소</button><button class="btn btn-primary" id="btnInvConfirmDo">변경</button></div>
    </div></div>
</div>

<script type="text/javascript">
    function fmtDate(s){ if(!s)return ''; if(typeof s==='string'&&s.length>=10)return s.slice(0,10); const d=new Date(s); return isNaN(d)?'':d.toISOString().slice(0,10); }
    function manKR(n){ return (Number(n||0)/10000).toLocaleString('ko-KR'); }
    function wMan(n){ return '₩'+manKR(n); }
    function statusBadge(s){ if(s==='draft')return'badge bg-secondary'; if(s==='issued')return'badge bg-primary'; if(s==='paid')return'badge bg-success'; if(s==='canceled')return'badge bg-danger'; return'badge bg-light text-dark'; }
    function statusText(s){ if(s==='draft')return'작성'; if(s==='issued')return'발행'; if(s==='paid')return'입금'; if(s==='canceled')return'취소'; return s||''; }

    function buildParams(raw){ const p={}; for(const k in raw){ if(!raw.hasOwnProperty(k))continue; const v=raw[k]; if(v===undefined||v===null)continue; if(typeof v==='string'&&v.trim()==='')continue; p[k]=v; } return p; }
    function resetExcept(exceptId){ ['invStatus','userId'].forEach(id=>{ if(id===exceptId)return; const el=document.getElementById(id); if(!el)return; if(el.tagName==='INPUT')el.value=''; else if(el.tagName==='SELECT')el.value=''; }); }

    function loadInvoiceList(){
        const params=buildParams({ status:invStatus.value, userId:userId.value });
        axios.get('/finance/api/invoice',{params}).then(res=>renderTable(res.data||[])).catch(err=>console.error('청구 목록 조회 오류:',err));
    }

    function canToIssued(s){ return s==='draft'; }
    function canToPaid(s){ return s==='issued'; }
    function canToCanceled(s){ return s==='draft'||s==='issued'; }

    function renderTable(list){
        const tb=document.getElementById('invoice-tbody'); tb.innerHTML='';
        if(!list||!list.length){ tb.innerHTML='<tr><td colspan="7" class="text-center">조회된 데이터가 없습니다.</td></tr>'; return; }
        list.forEach(v=>{
            let buttons='';
            if(v.invoiceStatus==='paid'||v.invoiceStatus==='canceled'){
                buttons='<button class="btn btn-sm btn-outline-secondary" disabled>'+(v.invoiceStatus==='paid'?'입금 완료':'취소 완료')+'</button>';
            }else{
                if(canToIssued(v.invoiceStatus)) buttons+='<button class="btn btn-sm btn-primary me-1" data-act="to-issued" data-id="'+v.invoiceId+'">발행</button>';
                if(canToPaid(v.invoiceStatus))   buttons+='<button class="btn btn-sm btn-success me-1" data-act="to-paid" data-id="'+v.invoiceId+'">입금</button>';
                if(canToCanceled(v.invoiceStatus)) buttons+='<button class="btn btn-sm btn-outline-danger" data-act="to-canceled" data-id="'+v.invoiceId+'">취소</button>';
            }
            const row='<tr>'
                +'<td>'+(v.invoiceId||'')+'</td>'
                +'<td>'+fmtDate(v.invoiceDt)+'</td>'
                +'<td>'+wMan(v.totalAmt)+'</td>'
                +'<td><span class="'+statusBadge(v.invoiceStatus)+'">'+statusText(v.invoiceStatus)+'</span></td>'
                +'<td>'+(fmtDate(v.depositDt)||'-')+'</td>'
                +'<td>'+(v.userId||'')+'</td>'
                +'<td>'+buttons+'</td>'
                +'</tr>';
            tb.insertAdjacentHTML('beforeend',row);
        });
    }

    var invConfirmModal, pending={id:null,target:null};
    document.getElementById('invoice-tbody').addEventListener('click',e=>{
        const btn=e.target.closest('button'); if(!btn)return;
        const act=btn.getAttribute('data-act'); const id=btn.getAttribute('data-id'); if(!act)return;
        pending.id=id; pending.target=(act==='to-issued'?'issued':act==='to-paid'?'paid':'canceled');
        document.getElementById('invConfirmId').textContent=id;
        document.getElementById('invConfirmTargetText').textContent=statusText(pending.target);
        if(!invConfirmModal) invConfirmModal=new bootstrap.Modal(document.getElementById('invConfirmModal'));
        invConfirmModal.show();
    });

    document.getElementById('btnInvConfirmDo').addEventListener('click',function(){
        if(!pending.id||!pending.target)return;
        axios.put('/finance/api/invoice/'+pending.id,{invoiceStatus:pending.target}).then(r=>{
            if(r.status===200){ invConfirmModal.hide(); pending={id:null,target:null}; loadInvoiceList(); }
        }).catch(err=>console.error('상태 변경 오류:',err));
    });

    function loadInvoiceKpis(){
        axios.get('/finance/api/invoiceChart').then(res=>{
            const d=res.data||{};
            document.getElementById('kpi-inv-total').textContent=( '₩'+ (Number(d.monthInvoiceTotal||0)/10000).toLocaleString('ko-KR') );
            document.getElementById('kpi-inv-paidPct').textContent=(d.paidRatePct??0)+'%';
            document.getElementById('kpi-inv-issuing').textContent=(d.issuingCount||0)+'건';
            document.getElementById('kpi-inv-unpaid').textContent=(d.unpaidCount||0)+'건';
        }).catch(e=>console.error('Invoice KPI 오류',e));
    }

    document.addEventListener('DOMContentLoaded',function(){ loadInvoiceKpis(); loadInvoiceList(); });
    document.getElementById('invStatus').addEventListener('change',function(){ resetExcept('invStatus'); loadInvoiceList(); });
    document.getElementById('userId').addEventListener('keyup',e=>{ if(e.key==='Enter'){ resetExcept('userId'); loadInvoiceList(); }});
    document.getElementById('btnSearch').addEventListener('click',loadInvoiceList);
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>