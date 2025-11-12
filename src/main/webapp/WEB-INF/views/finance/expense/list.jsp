<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div><h3 class="fw-bold mb-3">지출 관리 목록</h3></div>
    <div class="ms-md-3 d-flex gap-2">
        <button class="btn btn-success" id="btnOpenNewModal">관리비 생성</button>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <div class="d-flex align-items-center">
                    <h4 class="card-title">지출 목록 필터</h4>
                    <button class="btn btn-primary btn-round ms-auto" id="searchBtn">
                        <i class="fa fa-search"></i> 검색
                    </button>
                </div>

                <div class="row mt-3">
                    <div class="col-md-4">
                        <label for="whId" class="form-label">창고</label>
                        <select class="form-select" id="whId">
                            <option value="">전체</option>
                            <option value="1">곤지암</option>
                            <option value="2">부산</option>
                            <option value="3">전주</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="expenseCategory" class="form-label">카테고리</label>
                        <select class="form-select" id="expenseCategory">
                            <option value="">전체</option>
                            <option value="inboundCost">입고비용</option>
                            <option value="outboundCost">출고비용</option>
                            <option value="deliveryCost">배송비용</option>
                            <option value="storageCost">보관비용</option>
                            <option value="management">관리비</option>
                        </select>
                    </div>
                    <div class="col-md-4">
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
                            <th>지출ID</th>
                            <th>지출일</th>
                            <th>카테고리</th>
                            <th>금액</th>
                            <th>상태</th>
                            <th>확정일</th>
                            <th>창고ID</th>
                            <th>거래처ID</th>
                            <th>작업</th>
                        </tr>
                        </thead>
                        <tbody id="expense-list-body"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ===== 생성 모달 ===== -->
<div class="modal fade" id="expenseNewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">관리비 생성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label class="form-label">창고ID</label>
                        <select class="form-select" id="m-whId" required>
                            <option value="">선택</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">금액</label>
                        <input type="number" class="form-control" id="m-totalAmt" min="0" step="1" value="0" required>
                    </div>
                    <div class="small text-muted">카테고리=관리비, 지출일=오늘, 상태=draft 로 생성</div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button class="btn btn-primary" id="btnSubmitNew">생성</button>
            </div>
        </div>
    </div>
</div>

<!-- ===== 수정 모달 ===== -->
<div class="modal fade" id="expenseEditModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">관리비 금액 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <div class="mb-2">지출ID: <span id="edit-expenseId"></span></div>
                <div class="mb-3">
                    <label class="form-label">금액</label>
                    <input type="number" class="form-control" id="edit-totalAmt" min="0" step="1" required>
                </div>
                <div class="small text-muted">조건: 관리비(draft)만 수정 가능</div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button class="btn btn-primary" id="btnSubmitEdit">수정</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    // ===== 유틸 =====
    function fmtDate(s){ if(!s)return ''; if(typeof s==='string'&&s.length>=10)return s.slice(0,10); var d=new Date(s); return isNaN(d)?'':d.toISOString().slice(0,10); }
    function catLabel(c){ if(c==='inboundCost')return'입고비용'; if(c==='outboundCost')return'출고비용'; if(c==='storageCost')return'보관비용'; if(c==='deliveryCost')return'배송비용'; if(c==='management'||c==='관리비')return'관리비'; return c||''; }
    function numberKR(n){var v=n?Number(n):0;return v.toLocaleString('ko-KR');}
    function statusBadge(s){if(s==='posted')return'badge bg-success';if(s==='draft')return'badge bg-secondary';return'badge bg-light text-dark';}
    function buildParams(raw){var p={};for(var k in raw){if(!raw.hasOwnProperty(k))continue;var v=raw[k];if(v===undefined||v===null)continue;if(typeof v==='string'&&v.trim()==='')continue;p[k]=v;}return p;}
    function resetExcept(exceptId){var ids=['whId','expenseCategory','userId'];for(var i=0;i<ids.length;i++){var id=ids[i];if(id===exceptId)continue;var el=document.getElementById(id);if(!el)continue;if(el.tagName==='INPUT')el.value='';else if(el.tagName==='SELECT')el.value='';}}

    // ===== 목록 조회 =====
    function loadExpenseList(){
        var raw={whId:document.getElementById('whId').value,category:document.getElementById('expenseCategory').value,userId:document.getElementById('userId').value};
        var params=buildParams(raw);
        axios.get('/finance/api/expense',{params:params})
            .then(function(res){renderTable(res.data||[]);})
            .catch(function(err){console.error('지출 목록 조회 오류:',err);});
    }

    // ===== 테이블 렌더 =====
    function renderTable(list){
        var tbody=document.getElementById('expense-list-body');
        tbody.innerHTML='';
        if(!list||!list.length){tbody.innerHTML='<tr><td colspan="9" class="text-center">조회된 데이터가 없습니다.</td></tr>';return;}
        list.forEach(function(e){
            var posted=e&&e.expenseStatus==='posted';
            var row='<tr>'
                +'<td>'+((e&&e.expenseId)||'')+'</td>'
                +'<td>'+fmtDate(e&&e.expenseDt)+'</td>'
                +'<td>'+catLabel(e&&e.expenseCategory)+'</td>'
                +'<td>'+numberKR(e&&e.totalAmt)+'</td>'
                +'<td><span class="'+statusBadge(e&&e.expenseStatus)+'">'+((e&&e.expenseStatus)||'')+'</span></td>'
                +'<td>'+(fmtDate(e&&e.confirmDt)||'-')+'</td>'
                +'<td>'+((e&&e.whId)||'')+'</td>'
                +'<td>'+((e&&e.userId)||'')+'</td>'
                +'<td>'
                +(posted
                    ? '<button class="btn btn-sm btn-outline-secondary" disabled>확정 완료</button>'
                    : '<button class="btn btn-sm btn-primary me-1" data-act="post" data-id="'+e.expenseId+'">확정</button>'
                    +'<button class="btn btn-sm btn-outline-secondary me-1" data-act="edit" data-id="'+e.expenseId+'" data-category="'+e.expenseCategory+'" data-status="'+e.expenseStatus+'" data-total="'+e.totalAmt+'">수정</button>'
                    +'<button class="btn btn-sm btn-outline-danger" data-act="del" data-id="'+e.expenseId+'">삭제</button>')
                +'</td></tr>';
            tbody.insertAdjacentHTML('beforeend',row);
        });
    }

    // ===== 행 버튼 이벤트 =====
    var editModal, createModal, currentEditId=null;
    document.getElementById('expense-list-body').addEventListener('click',function(e){
        var btn=e.target;while(btn&&btn.tagName!=='BUTTON')btn=btn.parentNode;if(!btn)return;
        var act=btn.getAttribute('data-act');var id=btn.getAttribute('data-id');
        if(act==='post'){
            axios.post('/finance/api/expense/'+id).then(function(r){if(r.status===201)loadExpenseList();});
        }else if(act==='del'){
            if(!confirm('삭제할까요?'))return;
            axios.delete('/finance/api/expense/'+id).then(function(r){if(r.status===200)loadExpenseList();});
        }else if(act==='edit'){
            var cat=btn.getAttribute('data-category');var st=btn.getAttribute('data-status');
            if(!(cat==='management'||cat==='관리비')||st!=='draft'){alert('관리비(draft)만 수정 가능');return;}
            document.getElementById('edit-expenseId').textContent=id;
            document.getElementById('edit-totalAmt').value=btn.getAttribute('data-total')||0;
            currentEditId=id;
            editModal=new bootstrap.Modal(document.getElementById('expenseEditModal'));
            editModal.show();
        }
    });

    // ===== 수정 제출 =====
    document.getElementById('btnSubmitEdit').addEventListener('click',function(){
        var amt=Number(document.getElementById('edit-totalAmt').value||0);
        if(isNaN(amt)||amt<0){alert('금액 확인');return;}
        axios.put('/finance/api/expense/'+currentEditId,{expenseId:Number(currentEditId),totalAmt:amt})
            .then(function(r){
                if(r.status===200){
                    if(editModal) editModal.hide();
                    loadExpenseList();
                }
            });
    });

    // ===== 필터 이벤트 =====
    document.getElementById('whId').addEventListener('change',function(){resetExcept('whId');loadExpenseList();});
    document.getElementById('expenseCategory').addEventListener('change',function(){resetExcept('expenseCategory');loadExpenseList();});
    document.getElementById('userId').addEventListener('keyup',function(e){if(e.key==='Enter'){resetExcept('userId');loadExpenseList();}});
    document.getElementById('searchBtn').addEventListener('click',loadExpenseList);

    // ===== 생성 모달 =====
    document.getElementById('btnOpenNewModal').addEventListener('click',function(){
        document.getElementById('m-whId').value=document.getElementById('whId').value||'';
        document.getElementById('m-totalAmt').value=0;
        createModal=new bootstrap.Modal(document.getElementById('expenseNewModal'));
        createModal.show();
    });

    document.getElementById('btnSubmitNew').addEventListener('click',function(){
        var whId=document.getElementById('m-whId').value;
        var amt=Number(document.getElementById('m-totalAmt').value||0);
        if(!whId){alert('창고ID 선택');return;}
        if(isNaN(amt)||amt<0){alert('금액 확인');return;}
        var dto={expenseDt:new Date().toISOString().slice(0,10),expenseCategory:'management',totalAmt:amt,whId:Number(whId),userId:null,memo:null};
        axios.post('/finance/api/expense',dto)
            .then(function(r){
                if(r.status===201){
                    if(createModal) createModal.hide();
                    alert('생성 완료 (지출ID: '+r.data+')');
                    loadExpenseList();
                }
            })
            .catch(function(err){console.error('생성 오류:',err);});
    });

    // ===== 초기 =====
    document.addEventListener('DOMContentLoaded',function(){loadExpenseList();});
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>