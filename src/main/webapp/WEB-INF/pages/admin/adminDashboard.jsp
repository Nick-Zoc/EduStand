<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand Admin Console</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="dashboard" scope="request" />
<c:set var="searchPlaceholder" value="Search resources, users..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 1.75rem;">
            <section class="page-header-sleek p-4 p-md-4 d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-2" style="letter-spacing: 0.08em;">Admin Dashboard</div>
                    <h2 class="fs-2 fw-bold mb-2 brand-headline text-on-surface">Welcome back, CENAS Admin</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 42rem; line-height: 1.6;">Monitor access, track platform activity, and manage the system from one clean overview.</p>
                </div>
                <a href="<c:url value='/AdminUsers'/>" class="btn btn-primary-edu d-inline-flex align-items-center gap-2 px-4 py-2 fw-semibold text-white text-decoration-none">
                    <i class="fa-solid fa-users"></i>
                    Manage Users
                </a>
            </section>

            <section class="row g-3">
                <div class="col-12 col-sm-6 col-xl-4">
                    <div class="card-sleek p-3 h-100 d-flex align-items-center gap-3">
                        <div class="rounded-3 d-flex align-items-center justify-content-center flex-shrink-0" style="width: 42px; height: 42px; background: var(--primary-container); color: var(--primary);">
                            <i class="fa-solid fa-chalkboard-user fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="small text-uppercase fw-semibold text-on-surface-variant">Teachers</div>
                            <div class="fs-3 fw-bold lh-1 text-on-surface">${teacherCount}</div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-xl-4">
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
                <div class="col-12 col-sm-6 col-xl-4">
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

            <section class="card-curator overflow-hidden">
                <div class="px-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant bg-surface gap-3">
                    <h2 class="fs-5 fw-bold brand-headline text-on-surface m-0">Recent User Activity</h2>
                    <a href="<c:url value='/AdminUsers'/>" class="btn btn-outline-primary d-inline-flex align-items-center gap-2 px-3 py-2 fw-semibold text-decoration-none">
                        <i class="fa-solid fa-users"></i>
                        Open Users
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 m-0 table-index">
                        <thead class="bg-surface">
                            <tr>
                                <th class="border-0 px-4 py-3">Name</th>
                                <th class="border-0 px-4 py-3">Role</th>
                                <th class="border-0 px-4 py-3">Status</th>
                                <th class="border-0 px-4 py-3">Updated</th>
                            </tr>
                        </thead>
                        <tbody class="border-top-0" style="font-family: 'Inter', sans-serif;">
                            <tr>
                                <td class="px-4 py-3 fw-semibold">Sarah Mitchell</td>
                                <td class="px-4 py-3">Teacher</td>
                                <td class="px-4 py-3"><span class="status-dot" style="background-color: #198754;"></span> Active</td>
                                <td class="px-4 py-3">2 mins ago</td>
                            </tr>
                            <tr>
                                <td class="px-4 py-3 fw-semibold">Elena Petrov</td>
                                <td class="px-4 py-3">Teacher</td>
                                <td class="px-4 py-3"><span class="status-dot" style="background-color: #f59e0b;"></span> Pending</td>
                                <td class="px-4 py-3">15 mins ago</td>
                            </tr>
                            <tr>
                                <td class="px-4 py-3 fw-semibold">Aaron Wright</td>
                                <td class="px-4 py-3">Student</td>
                                <td class="px-4 py-3"><span class="status-dot" style="background-color: #dc3545;"></span> Suspended</td>
                                <td class="px-4 py-3">1 hour ago</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
