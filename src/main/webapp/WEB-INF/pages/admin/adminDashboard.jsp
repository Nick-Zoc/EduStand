<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand Admin Console</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="dashboard" scope="request" />
<c:set var="searchPlaceholder" value="Search resources, users..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <!-- Hero Banner -->
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white shadow-sm mb-4"
                     style="background: linear-gradient(135deg, var(--primary) 0%, rgba(0,86,179,1) 100%);">
                <div class="position-relative z-1" style="max-width: 650px;">
                    <div class="small fw-semibold text-uppercase opacity-75 mb-2" style="letter-spacing: 0.08em;">
                        <i class="fa-solid fa-shield-halved me-1"></i> Admin Dashboard
                    </div>
                    <h2 class="fs-1 fw-bold mb-3 brand-headline">Welcome, <c:out value="${userName}" /></h2>
                    <p class="fs-5 opacity-75 mb-0">Monitor users, review access requests, and manage platform activity from your control center.</p>
                </div>
                <div class="position-absolute h-100 top-0 end-0" style="width:33%; background:radial-gradient(circle,rgba(255,255,255,0.2) 0%,transparent 70%); right:-5%; filter:blur(30px);"></div>
            </section>

            <section class="row g-2 mb-3">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 42px; height: 42px; background: var(--primary-container); color: var(--primary);">
                            <i class="fa-solid fa-users fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Total Users</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface">${totalUsers}</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 42px; height: 42px; background: #eff6ff; color: #1d4ed8;">
                            <i class="fa-solid fa-chalkboard-user fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Teachers</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface">${teacherCount}</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 42px; height: 42px; background: #e0f2fe; color: #0284c7;">
                            <i class="fa-solid fa-user-graduate fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Students</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface">${studentCount}</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 42px; height: 42px; background: #fef3c7; color: #d97706;">
                            <i class="fa-solid fa-user-clock fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Pending</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface">${pendingCount}</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Quick Actions -->
            <section class="mt-4 mb-2">
                <div class="small fw-semibold text-uppercase text-on-surface-variant mb-3" style="letter-spacing:0.06em;">Quick Actions</div>
                <div class="d-flex flex-wrap gap-3">
                    <a href="<c:url value='/AdminUsers'/>" class=" btn-outline-secondary bg-surface border-outline-variant rounded-3 px-4 py-2 text-on-surface fw-semibold text-decoration-none d-flex align-items-center gap-2 card-sleek">
                        <i class="fa-solid fa-user-gear text-primary fs-5"></i> Manage Users
                    </a>
                    <a href="<c:url value='/AdminAccessRequests'/>" class=" btn-outline-secondary bg-surface border-outline-variant rounded-3 px-4 py-2 text-on-surface fw-semibold text-decoration-none d-flex align-items-center gap-2 card-sleek ">
                        <i class="fa-solid fa-list-check text-success fs-5"></i> Access Queue
                    </a>
                    <a href="<c:url value='/AdminContactRequests'/>" class=" btn-outline-secondary bg-surface border-outline-variant rounded-3 px-4 py-2 text-on-surface fw-semibold text-decoration-none d-flex align-items-center gap-2 card-sleek">
                        <i class="fa-solid fa-envelope text-danger fs-5"></i> Inbox
                    </a>
                </div>
            </section>

            <!-- Chart Row -->
            <section class="row g-3 mt-1 mb-2">
                <!-- Activity Trend Chart -->
                <div class="col-12 col-lg-4">
                    <div class="card-sleek-no-hover p-4 h-100 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="small fw-semibold text-uppercase text-on-surface-variant" style="letter-spacing:0.06em;">System Activity</div>
                            <select id="activityTrendFilter" class="form-select form-select-sm w-auto border-outline-variant bg-surface">
                                <option value="today">Today</option>
                                <option value="week" selected>Last 7 Days</option>
                                <option value="month">This Month</option>
                                <option value="year">This Year</option>
                                <option value="all">All Time</option>
                            </select>
                        </div>
                        <div class="flex-grow-1 d-flex align-items-center justify-content-center">
                            <canvas id="activityChart" style="max-height: 200px; width: 100%;"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Resources Overview Chart -->
                <div class="col-12 col-lg-4">
                    <div class="card-sleek-no-hover p-4 h-100 d-flex flex-column align-items-center justify-content-center">
                        <div class="small fw-semibold text-uppercase text-on-surface-variant mb-3 w-100" style="letter-spacing:0.06em;">Content Overview</div>
                        <canvas id="resourcesChart" style="max-height: 200px; width: 100%;"></canvas>
                    </div>
                </div>

                <!-- Chart.js Doughnut -->
                <div class="col-12 col-lg-4">
                    <div class="card-sleek-no-hover p-4 h-100 d-flex flex-column align-items-center justify-content-center">
                        <div class="small fw-semibold text-uppercase text-on-surface-variant mb-3" style="letter-spacing:0.06em;">Users by Role</div>
                        <canvas id="roleChart" style="max-width:180px;max-height:180px;"></canvas>
                        <div class="d-flex gap-3 mt-3 small">
                            <span><span class="d-inline-block rounded-circle me-1" style="width:10px;height:10px;background:#6366f1;"></span>Admin</span>
                            <span><span class="d-inline-block rounded-circle me-1" style="width:10px;height:10px;background:#0ea5e9;"></span>Teacher</span>
                            <span><span class="d-inline-block rounded-circle me-1" style="width:10px;height:10px;background:#22c55e;"></span>Student</span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Two-column: Activity Logs + Notice Board -->
            <section class="row g-3 mt-2">
                <!-- Activity Logs (trimmed to 5) -->
                <div class="col-12 col-lg-7">
                    <div class="users-table-wrap h-100">
                        <div class="users-toolbar px-3 px-md-4 py-3 d-flex justify-content-between align-items-center border-bottom border-outline-variant gap-3">
                            <h3 class="fs-5 fw-bold brand-headline text-on-surface m-0">Recent Activity</h3>
                            <a href="<c:url value='/AdminActivityLogs'/>" class="btn btn-outline-primary btn-sm px-3 py-2 text-decoration-none"><i class="fa-solid fa-arrow-right me-1"></i> View All</a>
                        </div>
                        <div class="table-responsive" style="max-height: 340px; overflow-y: auto;">
                            <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                                <thead class="bg-surface">
                                    <tr>
                                        <th class="px-3 py-3">DATE</th>
                                        <th class="px-3 py-3">USER</th>
                                        <th class="px-3 py-3">ACTION</th>
                                        <th class="px-3 py-3">DESCRIPTION</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentLogs}" var="log" varStatus="loop">
                                        <tr>
                                            <td class="px-3 py-2 text-on-surface-variant" style="font-size:13px; white-space:nowrap;">
                                                <fmt:formatDate value="${log.createdAt}" pattern="MMM dd, HH:mm" />
                                            </td>
                                            <td class="px-3 py-2">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width:28px;height:28px;font-size:10px;flex-shrink:0;">${empty log.userName ? 'U' : fn:toUpperCase(fn:substring(log.userName, 0, 1))}</div>
                                                    <span class="fw-semibold text-on-surface" style="font-size:13px;"><c:out value="${log.userName}" /></span>
                                                </div>
                                            </td>
                                            <td class="px-3 py-2">
                                                <c:choose>
                                                    <c:when test="${log.action eq 'LOGIN'}"><span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill fw-medium"><i class="fa-solid fa-arrow-right-to-bracket me-1"></i>LOGIN</span></c:when>
                                                    <c:when test="${log.action eq 'LOGOUT'}"><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium">LOGOUT</span></c:when>
                                                    <c:when test="${log.action eq 'USER_CREATE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill fw-medium">CREATE</span></c:when>
                                                    <c:when test="${log.action eq 'USER_UPDATE'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill fw-medium">UPDATE</span></c:when>
                                                    <c:when test="${log.action eq 'USER_DELETE'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill fw-medium">DELETE</span></c:when>
                                                    <c:when test="${log.action eq 'ACCESS_APPROVE'}"><span class="badge bg-info-subtle text-info border border-info-subtle rounded-pill fw-medium">APPROVE</span></c:when>
                                                    <c:when test="${log.action eq 'ACCESS_REJECT'}"><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium">REJECT</span></c:when>
                                                    <c:when test="${log.action eq 'PROFILE_UPDATE'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill fw-medium">PROFILE</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium">${log.action}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-3 py-2" style="font-size:13px;"><c:out value="${log.description}" /></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentLogs}">
                                        <tr><td colspan="4" class="px-3 py-5 text-center text-on-surface-variant">No activity logs yet.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="px-3 py-2 border-top border-outline-variant">
                            <p class="m-0 fw-medium text-on-surface-variant" style="font-size:12px;">Showing ${fn:length(recentLogs)} recent entries</p>
                        </div>
                    </div>
                </div>

                <!-- Notice Board -->
                <div class="col-12 col-lg-5">
                    <div class="card-sleek-no-hover h-100 d-flex flex-column overflow-hidden">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold brand-headline text-on-surface m-0">
                                <i class="fa-solid fa-bullhorn text-warning me-2"></i>Notice Board
                            </h3>
                            <button class="btn btn-sm btn-primary-edu rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#createNoticeModal">
                                <i class="fa-solid fa-plus me-1"></i>Post
                            </button>
                        </div>
                        <div class="p-3 flex-grow-1 overflow-auto" id="dash-notices" style="max-height: 310px;">
                            <div class="text-center text-on-surface-variant py-4 small">Loading notices...</div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <!-- Create Notice Modal -->
    <div class="modal fade" id="createNoticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius:1rem;">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title fw-bold brand-headline"><i class="fa-solid fa-bullhorn text-warning me-2"></i>Post a Notice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="createNoticeForm" enctype="multipart/form-data">
                    <div class="modal-body px-4 py-3">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Title</label>
                            <input type="text" class="form-control input-ghost" name="noticeTitle" placeholder="Notice title..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Message</label>
                            <textarea class="form-control input-ghost" name="noticeBody" rows="4" placeholder="Write your announcement..." required></textarea>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Active From</label>
                                <input type="date" class="form-control input-ghost" name="noticeStartDate" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Active Until</label>
                                <input type="date" class="form-control input-ghost" name="noticeEndDate" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Attachment (Optional)</label>
                            <input type="file" class="form-control input-ghost" name="noticeAttachment" accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.png,.jpg,.jpeg,.zip">
                            <div class="form-text text-on-surface-variant">PDF, Word, PowerPoint, images, ZIP — max 50MB</div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-edu rounded-pill px-5 fw-semibold"><i class="fa-solid fa-paper-plane me-2"></i>Post Notice</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    // ---- Chart.js: Users by Role ----
    (function() {
        const ctx = document.getElementById('roleChart');
        if (!ctx) return;
        const roleData = ${not empty chartRoleData ? chartRoleData : '[0,0,0]'};
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Admin', 'Teacher', 'Student'],
                datasets: [{
                    data: roleData,
                    backgroundColor: ['#6366f1', '#0ea5e9', '#22c55e'],
                    borderWidth: 0,
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                return ' ' + ctx.label + ': ' + ctx.parsed;
                            }
                        }
                    }
                },
                cutout: '72%'
            }
        });
    })();

    // ---- Chart.js: Activity Trend (real DB data) ----
    (function() {
        const ctx = document.getElementById('activityChart');
        if (!ctx) return;

        let activityChartInstance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Logins',
                    data: [],
                    borderColor: '#0ea5e9',
                    backgroundColor: 'rgba(14, 165, 233, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: 'rgba(0,0,0,0.05)' } },
                    x: { grid: { display: false } }
                }
            }
        });

        /** Fill in missing dates with 0 so chart always has a full range. */
        function buildFullRange(rawData, days) {
            const map = {};
            rawData.forEach(d => { map[d.date] = d.count; });
            const labels = [], data = [];
            const today = new Date();
            for (let i = days - 1; i >= 0; i--) {
                const d = new Date(today);
                d.setDate(d.getDate() - i);
                const iso = d.toISOString().slice(0, 10); // YYYY-MM-DD
                labels.push(d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }));
                data.push(map[iso] || 0);
            }
            return { labels, data };
        }

        async function updateActivityChart(filter) {
            let days = 7;
            if (filter === 'month') days = 30;
            else if (filter === 'year') days = 365;
            else if (filter === 'all') days = 1825; // 5 years

            if (filter === 'today') {
                // Hourly buckets for today — still real: just show today's total in one bar
                activityChartInstance.data.labels = ['Today'];
                activityChartInstance.data.datasets[0].data = [0];
                activityChartInstance.update();
                try {
                    const resp = await fetch('${pageContext.request.contextPath}/notice/chart-data?days=1');
                    const result = await resp.json();
                    const total = (result.data || []).reduce((s, r) => s + r.count, 0);
                    activityChartInstance.data.labels = ['Today'];
                    activityChartInstance.data.datasets[0].data = [total];
                    activityChartInstance.update();
                } catch(e) {}
                return;
            }

            if (filter === 'year') {
                // Monthly grouping for year view
                try {
                    const resp = await fetch('${pageContext.request.contextPath}/notice/chart-data?days=365');
                    const result = await resp.json();
                    const raw = result.data || [];
                    const monthMap = {};
                    raw.forEach(d => {
                        const month = d.date.substring(0, 7); // YYYY-MM
                        monthMap[month] = (monthMap[month] || 0) + d.count;
                    });
                    const today = new Date();
                    const labels = [], data = [];
                    for (let i = 11; i >= 0; i--) {
                        const d = new Date(today.getFullYear(), today.getMonth() - i, 1);
                        const iso = d.toISOString().slice(0, 7);
                        labels.push(d.toLocaleDateString('en-US', { month: 'short', year: '2-digit' }));
                        data.push(monthMap[iso] || 0);
                    }
                    activityChartInstance.data.labels = labels;
                    activityChartInstance.data.datasets[0].data = data;
                    activityChartInstance.update();
                } catch(e) {}
                return;
            }

            try {
                const resp = await fetch('${pageContext.request.contextPath}/notice/chart-data?days=' + days);
                const result = await resp.json();
                const { labels, data } = buildFullRange(result.data || [], Math.min(days, 30));
                activityChartInstance.data.labels = labels;
                activityChartInstance.data.datasets[0].data = data;
                activityChartInstance.update();
            } catch(e) { console.error('Chart fetch error', e); }
        }

        document.getElementById('activityTrendFilter').addEventListener('change', function(e) {
            updateActivityChart(e.target.value);
        });

        // Initialize with last 7 days of real data
        updateActivityChart('week');
    })();

    // ---- Chart.js: Resources Overview ----
    (function() {
        const ctx = document.getElementById('resourcesChart');
        if (!ctx) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Resources (Files)', 'Assignments'],
                datasets: [{
                    label: 'Count',
                    data: [${filesCount}, ${assignmentsCount}],
                    backgroundColor: ['#0ea5e9', '#f59e0b'],
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                    x: { grid: { display: false } }
                }
            }
        });
    })();

    // ---- Notice Board ----
    function showToast(msg, type) {
        const cls = type === 'error' ? 'bg-danger' : 'bg-success';
        const div = document.createElement('div');
        div.className = 'position-fixed bottom-0 end-0 p-3';
        div.style.zIndex = '9999';
        div.innerHTML = `<div class="toast align-items-center text-white \${cls} border-0 show"><div class="d-flex"><div class="toast-body fw-semibold">\${msg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.closest('.position-fixed').remove()"></button></div></div>`;
        document.body.appendChild(div);
        setTimeout(() => div.remove(), 3500);
    }

    async function loadNotices() {
        const el = document.getElementById('dash-notices');
        try {
            const resp = await fetch('${pageContext.request.contextPath}/notice/recent');
            const result = await resp.json();
            const notices = result.data || [];
            if (!notices.length) {
                el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No active notices. Post one above.</p>';
                return;
            }
            el.innerHTML = notices.map(n => {
                const attach = n.attachmentPath ? `<a href="${pageContext.request.contextPath}/\${n.attachmentPath}" target="_blank" class="d-inline-flex align-items-center gap-2 mt-2 py-1 px-2 rounded-3 border border-outline-variant small fw-semibold text-decoration-none text-on-surface" style="background:var(--surface-container);font-size:11px;"><i class="fa-solid fa-paperclip text-primary"></i>\${n.attachmentName || 'Attachment'}</a>` : '';
                return `<div class="py-2 border-bottom border-outline-variant">
                    <div class="d-flex justify-content-between gap-2 mb-1">
                        <span class="fw-semibold text-on-surface" style="font-size:13px;">\${n.title}</span>
                        <span class="small text-on-surface-variant flex-shrink-0">\${n.startDate}</span>
                    </div>
                    <p class="small text-on-surface-variant mb-1" style="font-size:12px;">\${n.body.substring(0, 100)}\${n.body.length > 100 ? '…' : ''}</p>
                    <div class="small text-on-surface-variant" style="font-size:11px;">— \${n.author}</div>
                    \${attach}
                </div>`;
            }).join('');
        } catch(e) {
            el.innerHTML = '<p class="text-danger small text-center py-3">Failed to load notices.</p>';
        }
    }
    loadNotices();

    document.getElementById('createNoticeForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        try {
            const resp = await fetch('${pageContext.request.contextPath}/notice/create', { method: 'POST', body: formData });
            const result = await resp.json();
            if (result.success) {
                bootstrap.Modal.getInstance(document.getElementById('createNoticeModal')).hide();
                showToast('Notice posted!');
                this.reset();
                loadNotices();
            } else {
                showToast(result.message || 'Failed to post notice.', 'error');
            }
        } catch (err) { showToast('Error posting notice.', 'error'); }
    });
    </script>
</body>
</html>
