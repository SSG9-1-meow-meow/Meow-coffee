<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 헤더 포함 --%>
<%@ include file="/WEB-INF/views/includes/_header.jsp" %>

<style>
    /* 상단 KPI 카드 높이 (조금 더 낮게) */
    .kpi-card {
        min-height: 110px;
    }
</style>

<!-- 메인 컨텐츠 시작 -->
<div class="container-fluid py-3">

    <h3 class="fw-bold mb-4">Coffee WMS 대시보드</h3>

    <!-- 1행: KPI 4개 (지출 / 청구 / 순이익 / 창고 사용량) -->
    <div class="row g-3">
        <!-- 지출 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100 kpi-card">
                <div class="card-body">
                    <div class="text-muted small mb-1">지출 합계 (단위: 만원)</div>
                    <div id="expenseTotal" class="h5 fw-bold mb-0">₩0</div>
                    <div class="small text-muted">대기: <span id="expensePending">0</span>건</div>
                </div>
            </div>
        </div>

        <!-- 청구 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100 kpi-card">
                <div class="card-body">
                    <div class="text-muted small mb-1">이번 달 청구 (단위: 만원)</div>
                    <div id="invoiceTotal" class="h5 fw-bold mb-0">₩0</div>
                    <div class="small text-muted">
                        입금완료율 <span id="paidRate">0%</span><br>
                        발행중 <span id="issuingCount">0</span> / 미발행 <span id="unpaidCount">0</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 순이익 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100 kpi-card">
                <div class="card-body d-flex flex-column justify-content-center">
                    <div class="text-muted mb-1">이번 달 순이익 (단위: 만원)</div>
                    <div id="netProfit" class="h3 fw-bold mb-0">₩0</div>
                </div>
            </div>
        </div>

        <!-- 창고 사용량 -->
        <div class="col-lg-3 col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100 kpi-card">
                <div class="card-body">
                    <div class="text-muted small mb-2">창고 사용량 (단위: %)</div>
                    <div style="width:110px;height:110px;margin:auto">
                        <canvas id="whDonut"></canvas>
                    </div>
                    <div class="text-center mt-1">
                        <span id="whUsagePct" class="fw-bold">0%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 2행: 좌 - 월별 매출 추이, 우 - 최근 한달 입출고 수량 -->
    <div class="row g-3 mt-2">
        <!-- 월별 매출 추이 -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">월별 매출 추이 (단위: 만원)</div>
                    <canvas id="revenueLineChart" height="180"></canvas>
                </div>
            </div>
        </div>

        <!-- 최근 한달 입·출고 수량 -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">최근 한달 입·출고 수량 (단위: 건)</div>
                    <canvas id="inoutDailyChart" height="180"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- 3행: 리드타임 그래프 -->
    <div class="row g-3 mt-2">
        <!-- 월별 리드타임 추이 line chart -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">월별 입고·출고 리드타임 추이 (단위: 시간)</div>
                    <canvas id="leadtimeMonthlyChart" height="140"></canvas>
                </div>
            </div>
        </div>

        <!-- 최근 한달 평균 리드타임 bar chart -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">최근 한달 평균 리드타임 (단위: 시간)</div>
                    <canvas id="avgLeadChart" height="140"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js + axios -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <script>
        // 공통 포맷터
        const nf = new Intl.NumberFormat('ko-KR');
        const fmtMan = n => nf.format(Math.floor(Number(n || 0) / 10000));
        const fmtKRWMan = n => '₩' + fmtMan(n);
        const fmtNum = n => nf.format(Number(n || 0));

        // 리드타임 음수/NaN 방지
        const safe = n => {
            const v = parseFloat(n);
            if (!isFinite(v)) return 0;
            return v < 0 ? 0 : v;
        };

        const yAxisTitle = text => ({title: {display: true, text}});
        const tickSuffix = suffix => ({
            ticks: {
                callback: v => fmtNum(v) + suffix
            }
        });
        const tooltipSuffix = suffix => ({
            plugins: {
                tooltip: {
                    callbacks: {
                        label: ctx => {
                            let v = 0;
                            if (ctx.raw != null) v = ctx.raw;
                            else if (ctx.parsed && ctx.parsed.y != null) v = ctx.parsed.y;
                            return (ctx.dataset.label || ctx.label) + ': ' + fmtNum(v) + suffix;
                        }
                    }
                }
            }
        });

        // 컨텍스트 루트 (예: /meow-coffee)
        const ctxPath = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function () {
            (async function loadDashboard() {
                try {
                    // 지출 (만원)
                    const expTotal = await axios.get(ctxPath + '/charts/expense/month-total');
                    document.getElementById('expenseTotal').textContent = fmtKRWMan(expTotal.data);
                    const expPending = await axios.get(ctxPath + '/charts/expense/pending-count');
                    document.getElementById('expensePending').textContent = expPending.data;

                    // 청구 (만원)
                    const inv = (await axios.get(ctxPath + '/charts/invoice/kpis')).data;
                    document.getElementById('invoiceTotal').textContent = fmtKRWMan(inv.monthInvoiceTotal);
                    document.getElementById('paidRate').textContent = inv.paidRatePct + '%';
                    document.getElementById('issuingCount').textContent = inv.issuingCount;
                    document.getElementById('unpaidCount').textContent = inv.unpaidCount;

                    // 순이익 (만원)
                    const profit = await axios.get(ctxPath + '/charts/net-profit');
                    document.getElementById('netProfit').textContent = fmtKRWMan(profit.data);

                    // =========================
                    // 매출 라인 차트 (하늘색 + 영역)
                    // =========================
                    const revSeries = (await axios.get(ctxPath + '/charts/revenue/monthly-series')).data;
                    const revenueCanvas = document.getElementById('revenueLineChart');
                    if (revenueCanvas) {
                        new Chart(revenueCanvas, {
                            type: 'line',
                            data: {
                                labels: revSeries.map(r => r.ym),
                                datasets: [{
                                    label: '매출액(만원)',
                                    data: revSeries.map(r => Math.floor((r.total || 0) / 10000)),
                                    tension: 0.3,
                                    fill: true,
                                    borderColor: 'rgba(135, 206, 250, 1)',      // 하늘색 라인
                                    backgroundColor: 'rgba(135, 206, 250, 0.3)',// 하늘색 영역
                                    pointBackgroundColor: 'rgba(135, 206, 250, 1)',
                                    pointBorderColor: 'rgba(135, 206, 250, 1)'
                                }]
                            },
                            options: {
                                scales: {
                                    y: Object.assign(
                                        {},
                                        yAxisTitle('금액(만원)'),
                                        tickSuffix('만원')
                                    )
                                },
                                plugins: Object.assign(
                                    {legend: {display: true, onClick: null}},
                                    tooltipSuffix('만원').plugins
                                )
                            }
                        });
                    }

                    // 입출고 일별 현황 (입고=파랑, 출고=빨강)
                    const inList = (await axios.get(ctxPath + '/charts/in/daily-qty-30d')).data;
                    const outList = (await axios.get(ctxPath + '/charts/out/daily-qty-30d')).data;
                    const inoutCanvas = document.getElementById('inoutDailyChart');
                    if (inoutCanvas) {
                        new Chart(inoutCanvas, {
                            type: 'bar',
                            data: {
                                labels: inList.map(d => d.chartKey),
                                datasets: [
                                    {
                                        label: '입고(건)',
                                        data: inList.map(d => d.totalQuantity),
                                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1
                                    },
                                    {
                                        label: '출고(건)',
                                        data: outList.map(d => d.totalQuantity),
                                        backgroundColor: 'rgba(255, 99, 132, 0.5)',
                                        borderColor: 'rgba(255, 99, 132, 1)',
                                        borderWidth: 1
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    y: Object.assign(
                                        {},
                                        yAxisTitle('수량(건)'),
                                        tickSuffix('건')
                                    )
                                },
                                plugins: Object.assign(
                                    {legend: {display: true, onClick: null}},
                                    tooltipSuffix('건').plugins
                                )
                            }
                        });
                    }

                    // 창고 사용량 도넛 (사용=초록, 미사용=노랑)
                    const wh = (await axios.get(ctxPath + '/charts/warehouse-utilization')).data;
                    document.getElementById('whUsagePct').textContent = wh.usageRatePct + '%';
                    const whCanvas = document.getElementById('whDonut');
                    if (whCanvas) {
                        new Chart(whCanvas, {
                            type: 'doughnut',
                            data: {
                                labels: ['사용', '미사용'],
                                datasets: [{
                                    label: '용량',
                                    data: [wh.usedCapa, wh.unusedCapa],
                                    backgroundColor: ['#1cc88a', '#f6c23e'],
                                    borderColor: ['#1cc88a', '#f6c23e'],
                                    borderWidth: 1
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                radius: '90%',
                                cutout: '70%',
                                plugins: {
                                    legend: {display: true, position: 'top', onClick: null},
                                    tooltip: {
                                        callbacks: {
                                            label: ctx => ctx.label + ': ' + fmtNum(ctx.raw)
                                        }
                                    }
                                }
                            }
                        });
                    }

                    // 평균 리드타임 bar
                    const avgInRaw = (await axios.get(ctxPath + '/charts/in/avg-leadtime-30d')).data;
                    const avgOutRaw = (await axios.get(ctxPath + '/charts/out/avg-leadtime-30d')).data;
                    const avgIn = safe(avgInRaw);
                    const avgOut = safe(avgOutRaw);

                    const avgLeadCanvas = document.getElementById('avgLeadChart');
                    if (avgLeadCanvas) {
                        new Chart(avgLeadCanvas, {
                            type: 'bar',
                            data: {
                                // x축은 하나의 그룹만 사용
                                labels: ['입출고'],
                                datasets: [
                                    {
                                        label: '입고(시간)',
                                        data: [avgIn],
                                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1,
                                        categoryPercentage: 0.5,
                                        barPercentage: 0.4
                                    },
                                    {
                                        label: '출고(시간)',
                                        data: [avgOut],
                                        backgroundColor: 'rgba(255, 99, 132, 0.5)',
                                        borderColor: 'rgba(255, 99, 132, 1)',
                                        borderWidth: 1,
                                        categoryPercentage: 0.5,
                                        barPercentage: 0.4
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    x: {
                                        type: 'category',
                                        title: { display: false }
                                    },
                                    y: Object.assign({}, yAxisTitle('시간(h)'), {
                                        min: 0,
                                        ticks: {
                                            callback: v => v + 'h'
                                        }
                                    })
                                },
                                plugins: {
                                    legend: { display: true, onClick: null }, // 위 가운데에 입고/출고 두 개 범례
                                    tooltip: {
                                        callbacks: {
                                            // "입고(시간): 162.4h" 이런 식으로
                                            label: ctx => `${ctx.dataset.label}: ${ctx.raw}h`
                                        }
                                    }
                                }
                            }
                        });
                    }

                    // 월별 리드타임 추이
                    const inSeries = (await axios.get(ctxPath + '/charts/in/leadtime-monthly')).data;
                    const outSeries = (await axios.get(ctxPath + '/charts/out/leadtime-monthly')).data;

                    const leadtimeCanvas = document.getElementById('leadtimeMonthlyChart');
                    if (leadtimeCanvas) {
                        new Chart(leadtimeCanvas, {
                            type: 'line',
                            data: {
                                labels: inSeries.map(r => r.ym),
                                datasets: [
                                    {
                                        label: '입고(시간)',
                                        // ✅ avg_hours → avgHours
                                        data: inSeries.map(r => safe(r.avgHours)),
                                        tension: 0.3,
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                        fill: false
                                    },
                                    {
                                        label: '출고(시간)',
                                        // ✅ avg_hours → avgHours
                                        data: outSeries.map(r => safe(r.avgHours)),
                                        tension: 0.3,
                                        borderColor: 'rgba(255, 99, 132, 1)',
                                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                        fill: false
                                    }
                                ]
                            },
                            options: {
                                scales: {
                                    y: Object.assign({}, yAxisTitle('시간(h)'), {
                                        min: 0,
                                        ticks: {
                                            callback: v => v + 'h'
                                        }
                                    })
                                },
                                plugins: {
                                    legend: {display: true, onClick: null},
                                    tooltip: {
                                        callbacks: {
                                            label: ctx => ctx.dataset.label + ': ' + ctx.raw + 'h'
                                        }
                                    }
                                }
                            }
                        });
                    }

                } catch (err) {
                    console.error('대시보드 로드 실패:', err);
                }
            })();
        });
    </script>

    <%-- 푸터 포함 --%>
    <%@ include file="/WEB-INF/views/includes/_footer.jsp" %>
</div>