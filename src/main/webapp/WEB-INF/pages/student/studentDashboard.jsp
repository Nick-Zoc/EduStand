<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Student Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<c:set var="activeSidebar" value="dashboard" scope="request" />
<c:set var="searchPlaceholder" value="Search for courses or resources..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">

    <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell d-flex flex-column" style="gap: 2rem;">


            <!-- Hero Banner -->
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white"
                     style="background: linear-gradient(135deg, #007FFF 0%, #0056b3 100%); box-shadow: 0 10px 25px rgba(0,127,255,0.2);">
                <div class="position-relative z-1" style="max-width: 600px;">
                    <div class="small fw-semibold text-uppercase opacity-75 mb-2" style="letter-spacing: 0.08em;">
                        <i class="fa-solid fa-graduation-cap me-1"></i> Student Dashboard
                    </div>
                    <h2 class="fw-bolder mb-3 brand-headline" style="font-size: calc(1.5rem + 1vw);">
                        Welcome back, <c:out value="${userName}" />
                    </h2>
                    <p class="fs-5 fw-medium opacity-75 mb-0" id="hero-subtitle">Loading your overview...</p>
                    <div class="mt-4 d-flex gap-3 flex-wrap">
                        <a href="<c:url value='/StudentClassroom'/>" class="btn bg-white text-primary fw-bold px-4 py-2 rounded-3 shadow-sm border-0" style="font-size:14px;">
                            <i class="fa-solid fa-folder-open me-2"></i>View Resources
                        </a>
                        <a href="<c:url value='/StudentClassroom?tab=assignments'/>" class="btn border border-white text-white fw-bold px-4 py-2 rounded-3" style="background:rgba(255,255,255,0.15);backdrop-filter:blur(10px);font-size:14px;">
                            <i class="fa-solid fa-file-alt me-2"></i>Assignments
                        </a>
                    </div>
                </div>
                <div class="position-absolute rounded-circle" style="right:-5rem;bottom:-5rem;width:20rem;height:20rem;background:rgba(255,255,255,0.1);filter:blur(48px);"></div>
                <div class="position-absolute rounded-circle" style="right:2.5rem;top:2.5rem;width:10rem;height:10rem;background:rgba(255,255,255,0.05);filter:blur(32px);"></div>
            </section>

            <!-- Stats Row -->
            <section class="row g-3">
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:var(--primary-container);color:var(--primary)">
                            <i class="fa-solid fa-file-alt fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Total</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-total">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#d1fae5;color:#065f46">
                            <i class="fa-solid fa-check-circle fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Submitted</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-submitted">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#fef3c7;color:#d97706">
                            <i class="fa-solid fa-clock fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Pending</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-pending">—</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width:42px;height:42px;background:#e0e7ff;color:#4338ca">
                            <i class="fa-solid fa-star fs-5"></i>
                        </div>
                        <div>
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Graded</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface" id="stat-graded">—</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Recent Resources & Status Chart -->
            <section class="row g-4">
                <div class="col-12 col-lg-8">
                    <div class="card-sleek-no-hover overflow-hidden h-100 d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-folder-open text-primary me-2"></i>Recent Resources
                            </h3>
                            <a href="<c:url value='/StudentClassroom'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3">View All Files</a>
                        </div>
                        <div class="p-4 flex-grow-1" id="dash-resources">
                            <div class="text-center text-on-surface-variant py-4"><i class="fa-solid fa-spinner fa-spin"></i> Loading...</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="card-sleek-no-hover p-4 h-100 d-flex flex-column align-items-center justify-content-center">
                        <div class="small fw-semibold text-uppercase text-on-surface-variant mb-3 w-100 text-center" style="letter-spacing:0.06em;">Assignment Status</div>
                        <canvas id="studentStatusChart" style="max-height: 200px; width: 100%;"></canvas>
                    </div>
                </div>
            </section>

            <!-- Two-column: Assignments + Notices -->
            <section class="row g-4 mt-2">
                <!-- Assignments -->
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover h-100 overflow-hidden d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-file-alt text-primary me-2"></i>My Assignments
                            </h3>
                            <a href="<c:url value='/StudentClassroom'/>" class="btn btn-sm btn-outline-primary rounded-pill px-3">Go to Classroom</a>
                        </div>
                        <div class="p-3 flex-grow-1" id="dash-assignments">
                            <div class="text-center text-on-surface-variant py-4"><i class="fa-solid fa-spinner fa-spin"></i> Loading...</div>
                        </div>
                    </div>
                </div>

                <!-- Notices -->
                <div class="col-12 col-lg-6">
                    <div class="card-sleek-no-hover h-100 overflow-hidden d-flex flex-column">
                        <div class="px-4 py-3 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                            <h3 class="fs-6 fw-bold text-on-surface m-0 brand-headline">
                                <i class="fa-solid fa-bullhorn text-warning me-2"></i>Notice Board
                            </h3>
                            <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill" id="notice-count-badge">0 active</span>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    const assignmentsData = ${not empty assignmentsJson ? assignmentsJson : '[]'};
    const resourcesData   = ${not empty resourcesJson   ? resourcesJson   : '[]'};
    const noticesData     = ${not empty noticesJson     ? noticesJson     : '[]'};

    function getFileIcon(type) {
        if (!type) return 'fa-file';
        const t = type.toLowerCase();
        if (t.includes('pdf')) return 'fa-file-pdf';
        if (t.includes('word') || t.includes('doc')) return 'fa-file-word';
        if (t.includes('ppt') || t.includes('powerpoint')) return 'fa-file-powerpoint';
        if (t.includes('xls') || t.includes('excel')) return 'fa-file-excel';
        if (t.includes('image') || t.includes('png') || t.includes('jpg')) return 'fa-file-image';
        if (t.includes('zip')) return 'fa-file-zipper';
        if (t === 'folder') return 'fa-folder';
        return 'fa-file';
    }

    // ---- Stats ----
    function renderStats() {
        const total = assignmentsData.length;
        const submitted = assignmentsData.filter(a => a.status === 'PENDING' || a.status === 'GRADED').length;
        const graded = assignmentsData.filter(a => a.status === 'GRADED').length;
        const pending = total - submitted;
        document.getElementById('stat-total').textContent = total;
        document.getElementById('stat-submitted').textContent = submitted;
        document.getElementById('stat-pending').textContent = pending;
        document.getElementById('stat-graded').textContent = graded;
        // Hero subtitle
        document.getElementById('hero-subtitle').textContent =
            total === 0 ? 'No assignments yet — check back later!'
            : `You have \${pending} pending assignment\${pending !== 1 ? 's' : ''} and \${graded} graded result\${graded !== 1 ? 's' : ''}.`;
    }

    // ---- Assignments ----
    function renderAssignments() {
        const el = document.getElementById('dash-assignments');
        if (!assignmentsData.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No assignments posted yet.</p>';
            return;
        }
        el.innerHTML = assignmentsData.slice(0, 5).map(a => {
            const isGraded = a.status === 'GRADED';
            const isSubmitted = a.status === 'PENDING';
            const badge = isGraded
                ? `<span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill fw-medium">\u2605 \${a.score}/100</span>`
                : isSubmitted
                    ? `<span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill fw-medium">\u2713 Submitted</span>`
                    : `<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium">Pending</span>`;
            return `<div class="d-flex align-items-start justify-content-between gap-2 py-2 border-bottom border-outline-variant">
                <div>
                    <div class="fw-semibold text-on-surface small">\${a.title}</div>
                    <div class="small text-on-surface-variant">Due: \${a.due}</div>
                </div>
                \${badge}
            </div>`;
        }).join('') + (assignmentsData.length > 5 ? `<div class="text-center pt-2"><a href="${pageContext.request.contextPath}/StudentClassroom" class="small text-primary fw-semibold">View all \${assignmentsData.length} assignments →</a></div>` : '');
    }

    // ---- Notices ----
    function renderNotices() {
        const el = document.getElementById('dash-notices');
        const badge = document.getElementById('notice-count-badge');
        badge.textContent = noticesData.length + ' active';
        if (!noticesData.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No active notices right now.</p>';
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
                <p class="small text-on-surface-variant mb-1 line-clamp-3">\${n.body.substring(0,150)}\${n.body.length>150?'…':''}</p>
                <div class="small text-on-surface-variant">— \${n.author}</div>
                \${attach}
            </div>`;
        }).join('');
    }

    // ---- Resources ----
    function renderResources() {
        const el = document.getElementById('dash-resources');
        const files = resourcesData.filter(r => r.type !== 'FOLDER').slice(0, 6);
        if (!files.length) {
            el.innerHTML = '<p class="text-on-surface-variant small text-center py-3">No resources uploaded yet.</p>';
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

    renderStats();
    renderAssignments();
    renderNotices();
    renderResources();

    // Chart
    setTimeout(() => {
        const ctx = document.getElementById('studentStatusChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Submitted', 'Graded', 'Pending'],
                    datasets: [{
                        data: [
                            parseInt(document.getElementById('stat-submitted').textContent) || 0,
                            parseInt(document.getElementById('stat-graded').textContent) || 0,
                            parseInt(document.getElementById('stat-pending').textContent) || 0
                        ],
                        backgroundColor: ['#10b981', '#3b82f6', '#f59e0b'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } },
                    cutout: '70%'
                }
            });
        }
    }, 800);
    </script>
</body>
</html>