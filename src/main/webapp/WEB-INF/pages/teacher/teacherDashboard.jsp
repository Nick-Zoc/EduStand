<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Teacher Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<c:set var="activeSidebar" value="dashboard" scope="request" />
<c:set var="searchPlaceholder" value="Search resources..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">

    <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell d-flex flex-column" style="gap: 2rem;">

            <!-- Hero Banner -->
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white shadow-sm"
                     style="background: linear-gradient(135deg, var(--primary) 0%, rgba(0,86,179,1) 100%);">
                <div class="position-relative z-1" style="max-width: 650px;">
                    <div class="small fw-semibold text-uppercase opacity-75 mb-2" style="letter-spacing: 0.08em;">
                        <i class="fa-solid fa-chalkboard-user me-1"></i> Teacher Dashboard
                    </div>
                    <h2 class="fs-1 fw-bold mb-3 brand-headline">Welcome back, <c:out value="${userName}" /></h2>
                    <p class="fs-5 opacity-75 mb-0">Manage your resources, assignments, and track student progress all in one place.</p>
                    <div class="mt-4 d-flex gap-3 flex-wrap">
                        <a href="<c:url value='/TeacherClassroom'/>" class="btn bg-white text-primary fw-bold px-4 py-2 shadow-sm border-0 rounded-3" style="font-size:14px;">
                            <i class="fa-solid fa-folder-open me-2"></i>Open Classroom
                        </a>
                    </div>
                </div>
                <div class="position-absolute h-100 top-0 end-0" style="width:33%; background:radial-gradient(circle,rgba(255,255,255,0.2) 0%,transparent 70%); right:-5%; filter:blur(30px);"></div>
            </section>

            <!-- Stats Row -->
            <section class="row g-3" id="dashboard-stats">
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:var(--primary-container);color:var(--primary)">
                            <i class="fa-solid fa-file-alt fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Assignments</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-assignments">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#d1fae5;color:#065f46">
                            <i class="fa-solid fa-folder-open fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Resources</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-resources">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#fef3c7;color:#d97706">
                            <i class="fa-solid fa-bullhorn fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Active Notices</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-notices">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#e0e7ff;color:#4338ca">
                            <i class="fa-solid fa-pen-to-square fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Go To</div>
                            <a href="<c:url value='/TeacherClassroom'/>" class="small fw-semibold text-primary text-decoration-none">Classroom →</a>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Recent Resources & Content Overview -->
            <section class="row g-4">
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover overflow-hidden h-100 d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-folder-open text-primary me-2"></i>Recent Resources
                            </h3>
                            <a href="<c:url value='/TeacherClassroom'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3">Manage Files</a>
                        </div>
                        <div class="p-4 flex-grow-1" id="dash-resources">
                            <div class="text-center text-on-surface-variant py-4"><i class="fa-solid fa-spinner fa-spin"></i> Loading...</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover p-4 h-100 d-flex flex-column">
                        <div class="small fw-semibold text-uppercase text-on-surface-variant mb-3 w-100 text-center" style="letter-spacing:0.06em;">Dashboard Analytics</div>
                        <div class="row g-3 flex-grow-1 align-items-center">
                            <div class="col-6 text-center">
                                <div class="small fw-semibold text-on-surface-variant mb-2" style="font-size: 11px;">Distribution (Doughnut)</div>
                                <div style="height: 160px; position: relative;">
                                    <canvas id="teacherDoughnutChart"></canvas>
                                </div>
                            </div>
                            <div class="col-6 text-center">
                                <div class="small fw-semibold text-on-surface-variant mb-2" style="font-size: 11px;">Overview (Bar)</div>
                                <div style="height: 160px; position: relative;">
                                    <canvas id="teacherBarChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Two-column: Assignments + Notices -->
            <section class="row g-4 mt-2">
                <!-- Recent Assignments -->
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover h-100 overflow-hidden d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-file-alt text-primary me-2"></i>Recent Assignments
                            </h3>
                            <a href="<c:url value='/TeacherClassroom'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3">View All</a>
                        </div>
                        <div class="p-3 flex-grow-1" id="dash-assignments">
                            <div class="text-center text-on-surface-variant py-4"><i class="fa-solid fa-spinner fa-spin"></i> Loading...</div>
                        </div>
                    </div>
                </div>

                <!-- Notice Board -->
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover h-100 overflow-hidden d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-bullhorn text-warning me-2"></i>Notice Board
                            </h3>
                            <button class="btn btn-sm btn-primary-edu rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#createNoticeModal">
                                <i class="fa-solid fa-plus me-1"></i>Post Notice
                            </button>
                        </div>
                        <div class="p-3 flex-grow-1" id="dash-notices">
                            <div class="text-center text-on-surface-variant py-4"><i class="fa-solid fa-spinner fa-spin"></i> Loading...</div>
                        </div>
                    </div>
                </div>
            </section>

        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <!-- Create Notice Modal -->
    <div class="modal fade" id="createNoticeModal" tabindex="-1" aria-labelledby="createNoticeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1rem;">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title fw-bold brand-headline" id="createNoticeModalLabel">
                        <i class="fa-solid fa-bullhorn text-warning me-2"></i>Post a Notice
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="createNoticeForm" enctype="multipart/form-data">
                    <div class="modal-body px-4 py-3">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:0.05em;">Title</label>
                            <input type="text" class="form-control input-ghost" name="noticeTitle" placeholder="Notice title..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:0.05em;">Message</label>
                            <textarea class="form-control input-ghost" name="noticeBody" rows="4" placeholder="Write your announcement here..." required></textarea>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:0.05em;">Active From</label>
                                <input type="date" class="form-control input-ghost" name="noticeStartDate" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:0.05em;">Active Until</label>
                                <input type="date" class="form-control input-ghost" name="noticeEndDate" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:0.05em;">Attachment (Optional)</label>
                            <input type="file" class="form-control input-ghost" name="noticeAttachment" accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.png,.jpg,.jpeg,.zip">
                            <div class="form-text text-on-surface-variant">PDF, Word, PowerPoint, images, ZIP — max 50MB</div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-edu rounded-pill px-5 fw-semibold">
                            <i class="fa-solid fa-paper-plane me-2"></i>Post Notice
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>

    <script>
    // Embedded JSON from server
    const assignmentsData = ${not empty assignmentsJson ? assignmentsJson : '[]'};
    const resourcesData   = ${not empty resourcesJson   ? resourcesJson   : '[]'};
    const noticesData     = ${not empty noticesJson     ? noticesJson     : '[]'};

    function showToast(msg, type) {
        const cls = type === 'error' ? 'bg-danger' : 'bg-success';
        const div = document.createElement('div');
        div.className = 'position-fixed bottom-0 end-0 p-3';
        div.style.zIndex = '9999';
        div.innerHTML = `<div class="toast align-items-center text-white \${cls} border-0 show" role="alert">
            <div class="d-flex"><div class="toast-body fw-semibold">\${msg}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.closest('.position-fixed').remove()"></button></div></div>`;
        document.body.appendChild(div);
        setTimeout(() => div.remove(), 3000);
    }

    function getFileIcon(type) {
        if (!type) return 'fa-file';
        const t = type.toLowerCase();
        if (t.includes('pdf')) return 'fa-file-pdf';
        if (t.includes('word') || t.includes('doc')) return 'fa-file-word';
        if (t.includes('ppt') || t.includes('powerpoint')) return 'fa-file-powerpoint';
        if (t.includes('xls') || t.includes('excel') || t.includes('spreadsheet')) return 'fa-file-excel';
        if (t.includes('image') || t.includes('png') || t.includes('jpg')) return 'fa-file-image';
        if (t.includes('zip') || t.includes('archive')) return 'fa-file-zipper';
        if (t === 'folder') return 'fa-folder';
        return 'fa-file';
    }

    // ---- Assignments ----
    function renderAssignments() {
        const el = document.getElementById('dash-assignments');
        document.getElementById('stat-assignments').textContent = assignmentsData.length;
        if (!assignmentsData.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No assignments yet. <a href="${pageContext.request.contextPath}/TeacherClassroom">Create one →</a></p>';
            return;
        }
        const recent = assignmentsData.slice(0, 4);
        el.innerHTML = recent.map(a => `
            <div class="d-flex align-items-start justify-content-between gap-2 py-2 border-bottom border-outline-variant">
                <div>
                    <div class="fw-semibold text-on-surface small">\${a.title}</div>
                    <div class="small text-on-surface-variant">Due: \${a.due}</div>
                </div>
                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium flex-shrink-0">Open</span>
            </div>`).join('') +
            (assignmentsData.length > 4 ? `<div class="text-center pt-2"><a href="${pageContext.request.contextPath}/TeacherClassroom" class="small text-primary fw-semibold">+\${assignmentsData.length - 4} more →</a></div>` : '');
    }

    // ---- Resources ----
    function renderResources() {
        const el = document.getElementById('dash-resources');
        const files = resourcesData.filter(r => r.type !== 'FOLDER').slice(0, 6);
        document.getElementById('stat-resources').textContent = resourcesData.filter(r => r.type !== 'FOLDER').length;
        if (!files.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No files uploaded yet. <a href="${pageContext.request.contextPath}/TeacherClassroom">Upload one →</a></p>';
            return;
        }
        el.innerHTML = `<div class="row g-3">\${files.map(r => `
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                    <div class="bg-primary-container rounded-3 d-flex align-items-center justify-content-center mb-2" style="width:44px;height:44px;color:var(--primary)">
                        <i class="fa-solid \${getFileIcon(r.type)} fs-4"></i>
                    </div>
                    <span class="text-on-surface fw-semibold text-truncate w-100 mb-2" style="font-size:11px;" title="\${r.title}">\${r.title}</span>
                    <a href="${pageContext.request.contextPath}/\${r.path}" target="_blank" class="btn btn-primary-edu rounded-circle mt-auto d-flex align-items-center justify-content-center" style="width:30px;height:30px;padding:0;">
                        <i class="fa-solid fa-download" style="font-size:11px;"></i>
                    </a>
                </div>
            </div>`).join('')}</div>`;
    }

    // ---- Notices ----
    function renderNotices() {
        const el = document.getElementById('dash-notices');
        document.getElementById('stat-notices').textContent = noticesData.length;
        if (!noticesData.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No active notices. Post one to inform students.</p>';
            return;
        }
        el.innerHTML = noticesData.slice(0, 4).map(n => {
            const attach = n.attachmentPath ? `
                <a href="${pageContext.request.contextPath}/\${n.attachmentPath}" target="_blank"
                   class="d-inline-flex align-items-center gap-2 mt-2 py-1 px-3 rounded-3 border border-outline-variant small fw-semibold text-on-surface text-decoration-none" style="background:var(--surface-container);">
                    <i class="fa-solid fa-paperclip text-primary"></i> \${n.attachmentName || 'Attachment'}
                </a>` : '';
            return `<div class="py-3 border-bottom border-outline-variant">
                <div class="d-flex align-items-start justify-content-between gap-2 mb-1">
                    <span class="fw-semibold text-on-surface small">\${n.title}</span>
                    <span class="small text-on-surface-variant flex-shrink-0">\${n.startDate}</span>
                </div>
                <p class="small text-on-surface-variant mb-1 line-clamp-2">\${n.body.substring(0, 120)}\${n.body.length > 120 ? '…' : ''}</p>
                <div class="small text-on-surface-variant">— \${n.author}</div>
                \${attach}
            </div>`;
        }).join('');
    }

    // ---- Notice Form Submit ----
    document.getElementById('createNoticeForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        try {
            const resp = await fetch('${pageContext.request.contextPath}/notice/create', { method: 'POST', body: formData });
            const result = await resp.json();
            if (result.success) {
                bootstrap.Modal.getInstance(document.getElementById('createNoticeModal')).hide();
                showToast('Notice posted successfully!');
                this.reset();
                // Reload notices from server
                const r2 = await fetch('${pageContext.request.contextPath}/notice/recent');
                const j2 = await r2.json();
                if (j2.success) {
                    noticesData.length = 0;
                    j2.data.forEach(n => noticesData.push(n));
                    renderNotices();
                    document.getElementById('stat-notices').textContent = noticesData.length;
                }
            } else {
                showToast(result.message || 'Failed to post notice.', 'error');
            }
        } catch (err) { console.error(err); showToast('Error posting notice.', 'error'); }
    });

    // Init
    renderAssignments();
    renderResources();
    renderNotices();

    // Charts
    setTimeout(() => {
        const totalFiles = resourcesData.filter(r => r.type !== 'FOLDER').length;
        const totalFolders = resourcesData.filter(r => r.type === 'FOLDER').length;
        const totalAssignments = assignmentsData.length;

        // Doughnut Chart
        const ctxDoughnut = document.getElementById('teacherDoughnutChart');
        if (ctxDoughnut) {
            new Chart(ctxDoughnut, {
                type: 'doughnut',
                data: {
                    labels: ['Files', 'Folders', 'Assignments'],
                    datasets: [{
                        data: [totalFiles, totalFolders, totalAssignments],
                        backgroundColor: ['#0ea5e9', '#6366f1', '#f59e0b'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { boxWidth: 10, font: { size: 9 } }
                        }
                    }
                }
            });
        }

        // Bar Chart
        const ctxBar = document.getElementById('teacherBarChart');
        if (ctxBar) {
            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: ['Files', 'Folders', 'Assignments'],
                    datasets: [{
                        label: 'Count',
                        data: [totalFiles, totalFolders, totalAssignments],
                        backgroundColor: ['#0ea5e9', '#6366f1', '#f59e0b'],
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
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' }, ticks: { stepSize: 1, font: { size: 9 } } },
                        x: { grid: { display: false }, ticks: { font: { size: 9 } } }
                    }
                }
            });
        }
    }, 500);
    </script>
</body>
</html>