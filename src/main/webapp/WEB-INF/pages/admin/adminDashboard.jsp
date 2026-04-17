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
    <style>
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }
        .table-index th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--on-surface-variant);
            font-weight: 700;
        }
    </style>
</head>
<c:set var="activeSidebar" value="dashboard" scope="request" />
<c:set var="searchPlaceholder" value="Search resources, users..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 2.5rem;">
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white shadow-sm" style="background: linear-gradient(135deg, var(--primary) 0%, rgba(0, 86, 179, 1) 100%);">
                <div class="position-relative z-1" style="max-width: 650px;">
                    <h2 class="fs-1 fw-bold mb-3 brand-headline">Admin dashboard</h2>
                    <p class="fs-5 opacity-75 mb-0" style="line-height: 1.6;">Monitor users, approve access requests, and keep EduStand operations running smoothly.</p>
                </div>
            </section>

            <section class="row g-4">
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 text-primary bg-primary-container d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                <i class="fa-solid fa-chalkboard-user fs-4"></i>
                            </div>
                            <span class="badge fw-bold text-primary bg-primary-container p-2 rounded-2" style="font-size: 11px;">Teachers</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">${teacherCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Total active educators</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #e0f2fe; color: #0284c7; width: 44px; height: 44px;">
                                <i class="fa-solid fa-user-graduate fs-4"></i>
                            </div>
                            <span class="badge fw-bold p-2 rounded-2" style="background-color: #e0f2fe; color: #0284c7; font-size: 11px;">Students</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">${studentCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Enrolled learners</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #fef3c7; color: #d97706; width: 44px; height: 44px;">
                                <i class="fa-solid fa-user-clock fs-4"></i>
                            </div>
                            <span class="badge fw-bold p-2 rounded-2" style="background-color: #fef3c7; color: #d97706; font-size: 11px;">Pending</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">${pendingCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Awaiting profile approval</p>
                    </div>
                </div>
            </section>

            <section class="card-curator overflow-hidden">
                <div class="px-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant bg-surface gap-3">
                    <h2 class="fs-5 fw-bold brand-headline text-on-surface m-0">Recent User Activity</h2>
                    <a href="<c:url value='/AdminUsers'/>" class="btn btn-primary-edu d-flex align-items-center justify-content-center gap-2 px-4 py-2 fw-bold small text-white border-0 shadow-sm" style="font-size: 13px; text-decoration: none;">
                        <i class="fa-solid fa-users fs-6"></i>
                        Manage Users
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
