<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- 공통 헤더 --%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<!-- =========================
상단 타이틀
========================= -->
<div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
    <div><h3 class="fw-bold mb-3">매출 관리 목록</h3></div>
</div>

<!-- =========================
KPI 카드 (이번 달 매출 / 전월 대비)
========================= -->
<div class="row g-3">
    <div class="col-md-6">
        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body">
                <div class="text-muted small mb-1">이번 달 매출(만원)</div>
                <div id="rev-kpi-total" class="h4 fw-bold">₩0</div>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body">
                <div class="text-muted small mb-1">전월 대비</div>
                <div id="rev-kpi-mom" class="h4 fw-bold">0%</div>
            </div>
        </div>
    </div>
</div>

<!-- =========================
월별 매출 차트 (Area Line)
========================= -->
<div class="card mt-3">
    <div class="card-body">
        <canvas id="revMonthlyArea" height="80"></canvas>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- =========================
스크립트: KPI + 월별 매출 차트
========================= -->
<script>
    // 금액 포맷: 원 → 만원
    function manKR(n) {
        return (Number(n || 0) / 10000).toLocaleString('ko-KR');
    }

    function wMan(n) {
        return '₩' + manKR(n);
    }

    // KPI 로딩
    function loadRevenueKpis() {
        axios.get('/finance/api/revenueChart1')
            .then(({data: d}) => {
                d = d || {};
                document.getElementById('rev-kpi-total').textContent = wMan(d.monthRevenueTotal || 0);

                const mom = Number(d.momRatePct || 0);
                const sign = mom > 0 ? '+' : '';
                document.getElementById('rev-kpi-mom').textContent = sign + mom.toFixed(1) + '%';
            })
            .catch(e => console.error('KPI 오류', e));
    }

    // 월별 매출 차트
    let revChart;

    function loadRevenueSeries() {
        axios.get('/finance/api/revenueChart2')
            .then(({data: list}) => {
                list = Array.isArray(list) ? list : [];

                const labels = list.map(it => it.ym);
                const data = list.map(it => Number(it.total || 0) / 10000); // 만원 스케일

                const ctx = document.getElementById('revMonthlyArea').getContext('2d');
                if (revChart) {
                    revChart.destroy();
                }

                revChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels,
                        datasets: [{
                            label: '월별 매출(만원)',
                            data,
                            fill: true,
                            tension: 0.25,
                            borderColor: 'rgba(135, 206, 250, 1)',      // 하늘색 라인
                            backgroundColor: 'rgba(135, 206, 250, 0.3)' // 하늘색 반투명 영역
                        }]
                    },
                    options: {
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                callbacks: {
                                    label: (ctx) =>
                                        '월별 매출: ₩' + Number(ctx.parsed.y).toLocaleString('ko-KR') + '만'
                                }
                            }
                        },
                        scales: {
                            y: {
                                ticks: {
                                    callback: (v) => Number(v).toLocaleString('ko-KR')
                                }
                            }
                        }
                    }
                });
            })
            .catch(e => console.error('차트 데이터 오류:', e));
    }

    // 초기 로딩 (KPI + 차트)
    document.addEventListener('DOMContentLoaded', function () {
        loadRevenueKpis();
        loadRevenueSeries();
    });
</script>

<!-- =========================
매출 전체 목록
========================= -->
<div class="row mt-3">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h4 class="card-title">매출 전체 목록</h4>
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
                            <th>총금액(만원)</th>
                        </tr>
                        </thead>
                        <tbody id="revenue-tbody"></tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- =========================
스크립트: 매출 목록
========================= -->
<script type="text/javascript">
    function fmtDate(s) {
        if (!s) return '';
        if (typeof s === 'string' && s.length >= 10) return s.slice(0, 10);
        const d = new Date(s);
        return isNaN(d) ? '' : d.toISOString().slice(0, 10);
    }

    function loadRevenueList() {
        axios.get('/finance/api/revenue')
            .then(res => renderTable(res.data || []))
            .catch(err => console.error('매출 목록 조회 오류:', err));
    }

    function renderTable(list) {
        const tb = document.getElementById('revenue-tbody');
        tb.innerHTML = '';

        if (!list || !list.length) {
            tb.innerHTML =
                '<tr><td colspan="3" class="text-center">조회된 데이터가 없습니다.</td></tr>';
            return;
        }

        list.forEach(v => {
            const row =
                '<tr>'
                + '<td>' + (v.revenueId || '') + '</td>'
                + '<td>' + fmtDate(v.revenueDt) + '</td>'
                + '<td>' + wMan(v.totalAmt) + '</td>'
                + '</tr>';

            tb.insertAdjacentHTML('beforeend', row);
        });
    }

    // 새로고침 버튼: KPI + 차트 + 목록 모두 재조회
    document.getElementById('btnReload').addEventListener('click', function () {
        loadRevenueKpis();
        loadRevenueSeries();
        loadRevenueList();
    });

    // 초기 목록 로딩
    document.addEventListener('DOMContentLoaded', loadRevenueList);
</script>

<%-- 공통 푸터 --%>
<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>