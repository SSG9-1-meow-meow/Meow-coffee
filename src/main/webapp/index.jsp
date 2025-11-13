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

    <!-- 2행: 좌 - 월별 매출 추이, 우 - 최근 한달 입출고 수량 (위치 교체) -->
    <div class="row g-3 mt-2">
        <!-- 월별 매출 추이 (왼쪽으로 이동) -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">월별 매출 추이 (단위: 만원)</div>
                    <canvas id="revenueLineChart" height="180"></canvas>
                </div>
            </div>
        </div>

        <!-- 최근 한달 입·출고 수량 (오른쪽으로 이동) -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">최근 한달 입·출고 수량 (단위: 건)</div>
                    <canvas id="inoutDailyChart" height="180"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- 3행: 리드타임 그래프 (위치 교체됨) -->
    <div class="row g-3 mt-2">

        <!-- ★ 왼쪽: 월별 리드타임 추이 line chart -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">월별 입고·출고 리드타임 추이 (단위: 시간)</div>
                    <canvas id="leadtimeMonthlyChart" height="140"></canvas>
                </div>
            </div>
        </div>

        <!-- ★ 오른쪽: 최근 한달 평균 리드타임 bar chart -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-body">
                    <div class="text-muted small mb-2">최근 한달 평균 리드타임 (단위: 시간)</div>
                    <canvas id="avgLeadChart" height="140"></canvas>
                </div>
            </div>
        </div>

    </div>
    <!-- 메인 컨텐츠 종료 -->

    <!-- Chart.js + axios -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <script>
        // 공통 포맷터
        const nf = new Intl.NumberFormat('ko-KR');
        const fmtMan = function (n) {
            return nf.format(Math.floor(Number(n || 0) / 10000));
        };
        const fmtKRWMan = function (n) {
            return '₩' + fmtMan(n);
        };
        const fmtNum = function (n) {
            return nf.format(Number(n || 0));
        };

        // 리드타임 음수/NaN 방지
        const safe = function (n) {
            const v = parseFloat(n);
            if (!isFinite(v)) return 0;
            return v < 0 ? 0 : v;
        };

        const yAxisTitle = function (text) {
            return {title: {display: true, text: text}};
        };
        const tickSuffix = function (suffix) {
            return {
                ticks: {
                    callback: function (v) {
                        return fmtNum(v) + suffix;
                    }
                }
            };
        };
        const tooltipSuffix = function (suffix) {
            return {
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function (ctx) {
                                let v = 0;
                                if (ctx.raw != null) v = ctx.raw;
                                else if (ctx.parsed && ctx.parsed.y != null) v = ctx.parsed.y;
                                return (ctx.dataset.label || ctx.label) + ': ' + fmtNum(v) + suffix;
                            }
                        }
                    }
                }
            };
        };

        (async function loadDashboard() {
            try {
                // 지출 (만원)
                const expTotal = await axios.get('/charts/expense/month-total');
                document.getElementById('expenseTotal').textContent = fmtKRWMan(expTotal.data);
                const expPending = await axios.get('/charts/expense/pending-count');
                document.getElementById('expensePending').textContent = expPending.data;

                // 청구 (만원)
                const inv = (await axios.get('/charts/invoice/kpis')).data;
                document.getElementById('invoiceTotal').textContent = fmtKRWMan(inv.monthInvoiceTotal);
                document.getElementById('paidRate').textContent = inv.paidRatePct + '%';
                document.getElementById('issuingCount').textContent = inv.issuingCount;
                document.getElementById('unpaidCount').textContent = inv.unpaidCount;

                // 순이익 (만원)
                const profit = await axios.get('/charts/net-profit');
                document.getElementById('netProfit').textContent = fmtKRWMan(profit.data);

                // 매출 라인 차트 (갈색, 만원)
                const revSeries = (await axios.get('/charts/revenue/monthly-series')).data;
                new Chart(document.getElementById('revenueLineChart'), {
                    type: 'line',
                    data: {
                        labels: revSeries.map(function (r) {
                            return r.ym;
                        }),
                        datasets: [{
                            label: '매출액(만원)',
                            data: revSeries.map(function (r) {
                                return Math.floor((r.total || 0) / 10000);
                            }),
                            tension: 0.3,
                            fill: false,
                            borderColor: '#4169E1', // RoyalBlue (로얄블루)
                            backgroundColor: 'rgba(65, 105, 225, 0.2)', // 연한 배경색
                            pointBackgroundColor: '#4169E1',
                            pointBorderColor: '#4169E1'
                        }]
                    },
                    options: {
                        scales: {
                            y: Object.assign({}, yAxisTitle('금액(만원)'), tickSuffix('만원'))
                        },
                        plugins: Object.assign(
                            {legend: {display: true, onClick: null}},
                            tooltipSuffix('만원').plugins
                        )
                    }
                });

                // 입출고 일별 현황 (건, 입고=파랑, 출고=빨강)
                const inList = (await axios.get('/charts/in/daily-qty-30d')).data;
                const outList = (await axios.get('/charts/out/daily-qty-30d')).data;
                new Chart(document.getElementById('inoutDailyChart'), {
                    type: 'bar',
                    data: {
                        labels: inList.map(function (d) {
                            return d.chartKey;
                        }),
                        datasets: [
                            {
                                label: '입고(건)',
                                data: inList.map(function (d) {
                                    return d.totalQuantity;
                                }),
                                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            },
                            {
                                label: '출고(건)',
                                data: outList.map(function (d) {
                                    return d.totalQuantity;
                                }),
                                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 1
                            }
                        ]
                    },
                    options: {
                        scales: {
                            y: Object.assign({}, yAxisTitle('수량(건)'), tickSuffix('건'))
                        },
                        plugins: Object.assign(
                            {legend: {display: true, onClick: null}},
                            tooltipSuffix('건').plugins
                        )
                    }
                });

                // 창고 사용량 도넛 (사용=초록, 미사용=노랑)
                const wh = (await axios.get('/charts/warehouse-utilization')).data;
                document.getElementById('whUsagePct').textContent = wh.usageRatePct + '%';
                new Chart(document.getElementById('whDonut'), {
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
                                    label: function (ctx) {
                                        return ctx.label + ': ' + fmtNum(ctx.raw);
                                    }
                                }
                            }
                        }
                    }
                });

                // 평균 리드타임 bar
                const avgInRaw = (await axios.get('/charts/in/avg-leadtime-30d')).data;
                const avgOutRaw = (await axios.get('/charts/out/avg-leadtime-30d')).data;
                const avgIn = safe(avgInRaw);
                const avgOut = safe(avgOutRaw);

                new Chart(document.getElementById('avgLeadChart'), {
                    type: 'bar',
                    data: {
                        labels: ['입고', '출고'],
                        datasets: [
                            {
                                label: '입고(시간)',
                                data: [avgIn, 0],
                                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            },
                            {
                                label: '출고(시간)',
                                data: [0, avgOut],
                                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 1
                            }
                        ]
                    },
                    options: {
                        scales: {
                            y: Object.assign({}, yAxisTitle('시간(h)'), {
                                min: 0,
                                ticks: {
                                    callback: function (v) {
                                        return v + 'h';
                                    }
                                }
                            })
                        },
                        plugins: {
                            legend: {display: true, onClick: null},
                            tooltip: {
                                callbacks: {
                                    label: function (ctx) {
                                        return ctx.dataset.label + ': ' + ctx.raw + 'h';
                                    }
                                }
                            }
                        }
                    }
                });

                // 월별 리드타임 추이
                const inSeries = (await axios.get('/charts/in/leadtime-monthly')).data;
                const outSeries = (await axios.get('/charts/out/leadtime-monthly')).data;

                new Chart(document.getElementById('leadtimeMonthlyChart'), {
                    type: 'line',
                    data: {
                        labels: inSeries.map(function (r) {
                            return r.ym;
                        }),
                        datasets: [
                            {
                                label: '입고(시간)',
                                data: inSeries.map(function (r) {
                                    return safe(r.avg_hours);
                                }),
                                tension: 0.3,
                                borderColor: 'rgba(54, 162, 235, 1)',
                                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                fill: false
                            },
                            {
                                label: '출고(시간)',
                                data: outSeries.map(function (r) {
                                    return safe(r.avg_hours);
                                }),
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
                                    callback: function (v) {
                                        return v + 'h';
                                    }
                                }
                            })
                        },
                        plugins: {
                            legend: {display: true, onClick: null},
                            tooltip: {
                                callbacks: {
                                    label: function (ctx) {
                                        return ctx.dataset.label + ': ' + ctx.raw + 'h';
                                    }
                                }
                            }
                        }
                    }
                });

            } catch (err) {
                console.error('대시보드 로드 실패:', err);
            }
        })();
    </script>

    <%-- 푸터 포함 --%>
<%@ include file="/WEB-INF/views/includes/_footer.jsp" %>