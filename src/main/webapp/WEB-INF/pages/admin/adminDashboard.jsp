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
            <section class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Admin Dashboard</div>
                    <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Welcome, <c:out value="${userName}" /></h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Monitor users, review access requests, and manage platform activity from your control center.</p>
                </div>
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

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-outline-variant gap-3">
                    <h3 class="fs-5 fw-bold brand-headline text-on-surface m-0">Quick Actions</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="<c:url value='/AdminUsers'/>" class="btn btn-primary-edu btn-sm px-3 py-2 text-white text-decoration-none"><i class="fa-solid fa-user-gear me-1"></i> Users</a>
                        <a href="<c:url value='/AdminAccessRequests'/>" class="btn btn-outline-primary btn-sm px-3 py-2 text-decoration-none"><i class="fa-solid fa-list-check me-1"></i> Access Queue</a>
                        <a href="<c:url value='/AdminContactRequests'/>" class="btn btn-outline-primary btn-sm px-3 py-2 text-decoration-none"><i class="fa-solid fa-envelope me-1"></i> Inbox</a>
                    </div>
                </div>
            </section>

            <section class="users-table-wrap mt-3">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant gap-3">
                    <h3 class="fs-5 fw-bold brand-headline text-on-surface m-0">System Activity Logs</h3>
                    <a href="<c:url value='/AdminActivityLogs'/>" class="btn btn-outline-primary btn-sm px-3 py-2 text-decoration-none"><i class="fa-solid fa-arrow-right me-1"></i> View All</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3">SN</th>
                                <th class="px-3 px-md-4 py-3">DATE</th>
                                <th class="px-3 px-md-4 py-3">USER</th>
                                <th class="px-3 px-md-4 py-3">ACTION</th>
                                <th class="px-3 px-md-4 py-3">DESCRIPTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentLogs}" var="log" varStatus="loop">
                                <tr>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">${loop.count}</td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant" style="font-size: 13px;">
                                        <fmt:formatDate value="${log.createdAt}" pattern="MMM dd, HH:mm" />
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 32px; height: 32px; font-size: 11px;">${empty log.userName ? 'U' : fn:toUpperCase(fn:substring(log.userName, 0, 1))}</div>
                                            <span class="fw-semibold text-on-surface"><c:out value="${log.userName}" /></span>
                                        </div>
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <c:choose>
                                            <c:when test="${log.action eq 'LOGIN'}">
                                                <span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-arrow-right-to-bracket me-1"></i> LOGIN</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_CREATE'}">
                                                <span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-solid fa-plus me-1"></i> CREATE</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_UPDATE'}">
                                                <span class="badge bg-warning bg-opacity-20 text-warning fw-semibold"><i class="fa-solid fa-pen me-1"></i> UPDATE</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_DELETE'}">
                                                <span class="badge bg-danger bg-opacity-20 text-danger fw-semibold"><i class="fa-solid fa-trash me-1"></i> DELETE</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'LOGOUT'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-arrow-right-from-bracket me-1"></i> LOGOUT</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'ACCESS_APPROVE'}">
                                                <span class="badge bg-info bg-opacity-20 text-info fw-semibold"><i class="fa-solid fa-check-circle me-1"></i> APPROVE</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'ACCESS_REJECT'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-circle-xmark me-1"></i> REJECT</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'CONTACT_READ'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-envelope-open me-1"></i> READ</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'CONTACT_FIXED'}">
                                                <span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-circle-check me-1"></i> FIXED</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'PROFILE_UPDATE'}">
                                                <span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-regular fa-user-pen me-1"></i> UPDATE</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold">${log.action}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-3 px-md-4 py-3"><c:out value="${log.description}" /></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentLogs}">
                                <tr>
                                    <td colspan="5" class="px-3 px-md-4 py-5 text-center text-on-surface-variant">No activity logs yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="users-pagination-bar px-3 px-md-4 py-3 border-top border-outline-variant d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                    <p class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing ${fn:length(recentLogs)} recent activities</p>
                    <a href="<c:url value='/AdminActivityLogs'/>" class="btn btn-outline-primary btn-sm px-3 py-1 rounded-pill text-decoration-none">View all logs</a>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
</body>
</html>
