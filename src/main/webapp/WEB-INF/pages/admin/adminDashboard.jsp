<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <div class="small text-uppercase fw-semibold text-primary mb-2" style="letter-spacing: 0.08em;">Manage Dashboard</div>
                    <h2 class="fs-1 fw-bold mb-2 brand-headline text-on-surface">Welcome, <c:out value="${userName}" /></h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 42rem; line-height: 1.6;">Monitor access, track platform activity, and move between user, request, and support workflows from one command center.</p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="<c:url value='/AdminUsers'/>" class="btn btn-primary-edu d-inline-flex align-items-center gap-2 px-4 py-2 fw-semibold text-white text-decoration-none">
                        <i class="fa-solid fa-users"></i>
                        Manage Users
                    </a>
                    <a href="<c:url value='/AdminAccessRequests'/>" class="btn btn-outline-primary d-inline-flex align-items-center gap-2 px-3 py-2 fw-semibold text-decoration-none">
                        <i class="fa-solid fa-file-circle-check"></i>
                        Access Queue
                    </a>
                </div>
            </section>

            <section class="row g-3">
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

            <section class="row g-3">
                <div class="col-12 col-lg-8">
                    <div class="users-table-wrap p-4 h-100 d-flex flex-column justify-content-center">
                        <h3 class="fs-5 fw-bold brand-headline mb-3">Quick Actions</h3>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="<c:url value='/AdminUsers'/>" class="btn btn-primary-edu btn-sm px-3 py-2 text-white"><i class="fa-solid fa-user-gear me-1"></i> User Management</a>
                            <a href="<c:url value='/AdminAccessRequests'/>" class="btn btn-outline-primary btn-sm px-3 py-2"><i class="fa-solid fa-list-check me-1"></i> Review Access</a>
                            <a href="<c:url value='/AdminContactRequests'/>" class="btn btn-outline-primary btn-sm px-3 py-2"><i class="fa-solid fa-envelope-open-text me-1"></i> Contact Inbox (${unreadContactCount})</a>
                            <a href="<c:url value='/PanelContact'/>" class="btn btn-outline-primary btn-sm px-3 py-2"><i class="fa-solid fa-address-book me-1"></i> Open Contact Page</a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-4">
                    <div class="users-table-wrap p-4 h-100 d-flex flex-column justify-content-center">
                        <h3 class="fs-6 fw-bold brand-headline mb-3">Health Snapshot</h3>
                        <div class="d-flex justify-content-between py-1 border-bottom border-outline-variant">
                            <span class="text-on-surface-variant">Inactive Users</span>
                            <strong>${inactiveCount}</strong>
                        </div>
                        <div class="d-flex justify-content-between py-1 border-bottom border-outline-variant">
                            <span class="text-on-surface-variant">Unread Contact</span>
                            <strong>${unreadContactCount}</strong>
                        </div>
                        <div class="d-flex justify-content-between py-1">
                            <span class="text-on-surface-variant">Pending Access</span>
                            <strong>${pendingCount}</strong>
                        </div>
                    </div>
                </div>
            </section>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant bg-surface gap-3">
                    <h2 class="fs-5 fw-bold brand-headline text-on-surface m-0">Recent User Activity</h2>
                    <a href="<c:url value='/AdminUsers'/>" class="btn btn-outline-primary d-inline-flex align-items-center gap-2 px-3 py-2 fw-semibold text-decoration-none">
                        <i class="fa-solid fa-users"></i>
                        Open Users
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3">NAME</th>
                                <th class="px-3 px-md-4 py-3">EMAIL</th>
                                <th class="px-3 px-md-4 py-3">ROLE</th>
                                <th class="px-3 px-md-4 py-3">STATUS</th>
                                <th class="px-3 px-md-4 py-3">CREATED</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentUsers}" var="user">
                                <tr>
                                    <td class="px-3 px-md-4 py-3 fw-semibold text-on-surface"><c:out value="${user.fullName}" /></td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant"><c:out value="${user.email}" /></td>
                                    <td class="px-3 px-md-4 py-3">
                                        <span class="edu-badge edu-badge-role ${user.role eq 'ADMIN' ? 'edu-badge-role-admin' : (user.role eq 'TEACHER' ? 'edu-badge-role-teacher' : 'edu-badge-role-student')}">
                                            <c:out value="${user.role}" />
                                        </span>
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <span class="edu-badge edu-badge-status ${user.status eq 'ACTIVE' ? 'edu-badge-status-active' : (user.status eq 'PENDING' ? 'edu-badge-status-pending' : 'edu-badge-status-inactive')}">
                                            <c:out value="${user.status}" />
                                        </span>
                                    </td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentUsers}">
                                <tr>
                                    <td colspan="5" class="px-3 px-md-4 py-5 text-center text-on-surface-variant">No recent user activity available.</td>
                                </tr>
                            </c:if>
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
