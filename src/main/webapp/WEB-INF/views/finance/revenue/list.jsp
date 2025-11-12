<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<!-- 상단 타이틀 -->
<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div><h3 class="fw-bold mb-3">매출 관리 목록</h3></div>
</div>

<!-- ===== KPI 카드: 이번 달 매출 / 전월 대비 / 창고 수 ===== -->
<div class="row g-3">
    <div class="col-md-4">
        <div class="card shadow-sm border-0 rounded-4"><div class="card-body">
            <div class="text-muted small mb-1">이번 달 매출</div>
            <div id="rev-kpi-total" class="h4 fw-bold">₩0</div>
        </div></div>
    </div>
    <div class="col-md-4">
        <div class="card shadow-sm border-0 rounded-4"><div class="card-body">
            <div class="text-muted small mb-1">전월 대비</div>
            <div id="rev-kpi-mom" class="h4 fw-bold">0%</div>
        </div></div>
    </div>
    <div class="col-md-4">
        <div class="card shadow-sm border-0 rounded-4"><div class="card-body">
            <div class="text-muted small mb-1">창고 수</div>
            <div id="rev-kpi-wh" class="h4 fw-bold">0</div>
        </div></div>
    </div>
</div>

<!-- ===== 월별 매출 라인 에어리어 차트 ===== -->
<div class="card mt-3">
    <div class="card-body">
        <canvas id="revMonthlyArea" height="80"></canvas>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    /* 숫자 포맷 공통 */
    function kr(n){ return Number(n||0).toLocaleString('ko-KR'); }

    /* KPI 로드: /finance/api/revenueChart1 -> {monthRevenueTotal, momRatePct, warehouseCount} */
    function loadRevenueKpis(){
        axios.get('/finance/api/revenueChart1')
            .then(({data:d})=>{
                d = d || {};
                document.getElementById('rev-kpi-total').textContent = '₩' + kr(d.monthRevenueTotal||0);
                const mom = Number(d.momRatePct||0);
                const sign = mom>0?'+':''; // 음수는 자동 표시
                document.getElementById('rev-kpi-mom').textContent = sign + mom.toFixed(1) + '%';
                document.getElementById('rev-kpi-wh').textContent = d.warehouseCount||0;
            })
            .catch(e=>console.error('KPI 오류', e));
    }

    /* 월별 시계열 로드: /finance/api/revenueChart2 -> [{ym, total}] */
    let revChart;
    function loadRevenueSeries(){
        axios.get('/finance/api/revenueChart2')
            .then(({data:list})=>{
                list = Array.isArray(list)?list:[];
                const labels = list.map(it=>it.ym);
                const data   = list.map(it=>Number(it.total||0));

                const ctx = document.getElementById('revMonthlyArea').getContext('2d');
                if(revChart){ revChart.destroy(); }
                revChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '월별 매출',
                            data: data,
                            fill: true,
                            tension: 0.25
                        }]
                    },
                    options: {
                        plugins: { legend: { display:false } },
                        scales: { y: { ticks: { callback:v=>'₩'+kr(v) } } }
                    }
                });
            })
            .catch(e=>console.error('차트 데이터 오류', e));
    }

    /* 초기 진입 시 KPI/차트 로드 */
    document.addEventListener('DOMContentLoaded', function(){
        loadRevenueKpis();
        loadRevenueSeries();
    });
</script>

<!-- ===== 전체 목록 ===== -->
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h4 class="card-title">매출 전체 목록</h4>
                <!-- 새로고침: KPI/차트/목록 동시 갱신 -->
                <button class="btn btn-primary btn-round ms-auto" id="btnReload">
                    <i class="fa fa-rotate"></i> 새로고침
                </button>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped mt-3">
                        <thead>
                        <tr>
                            <th>매출ID</th>
                            <th>매출일</th>
                            <th>총금액</th>
                        </tr>
                        </thead>
                        <tbody id="revenue-tbody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    /* 날짜 포맷 */
    function fmtDate(s){
        if(!s) return '';
        if(typeof s==='string' && s.length>=10) return s.slice(0,10);
        var d=new Date(s);
        return isNaN(d)?'':d.toISOString().slice(0,10);
    }
    function numKR(n){ var v=n?Number(n):0; return v.toLocaleString('ko-KR'); }

    /* 목록 로드: /finance/api/revenue -> [{revenueId, revenueDt, totalAmt}] */
    function loadRevenueList(){
        axios.get('/finance/api/revenue')
            .then(function(res){ renderTable(res.data||[]); })
            .catch(function(err){ console.error('매출 목록 조회 오류:', err); });
    }

    /* 테이블 렌더링 */
    function renderTable(list){
        var tb=document.getElementById('revenue-tbody'); tb.innerHTML='';
        if(!list || !list.length){
            tb.innerHTML='<tr><td colspan="3" class="text-center">조회된 데이터가 없습니다.</td></tr>'; return;
        }
        list.forEach(function(v){
            var row='<tr>'
                +'<td>'+ (v.revenueId||'') +'</td>'
                +'<td>'+ fmtDate(v.revenueDt) +'</td>'
                +'<td>'+ numKR(v.totalAmt) +'</td>'
                +'</tr>';
            tb.insertAdjacentHTML('beforeend', row);
        });
    }

    /* 새로고침: KPI/차트/목록 동시 갱신 */
    document.getElementById('btnReload').addEventListener('click', function(){
        loadRevenueKpis();
        loadRevenueSeries();
        loadRevenueList();
    });

    /* 초기 목록 로드 */
    document.addEventListener('DOMContentLoaded', loadRevenueList);
</script>

<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>