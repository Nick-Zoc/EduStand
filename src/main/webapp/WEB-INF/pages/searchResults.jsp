<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | EduStand</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-body">

<div class="d-flex w-100 h-100">
    <!-- Sidebar -->
    <c:choose>
        <c:when test="${userRole == 'ADMIN'}">
            <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />
        </c:when>
        <c:when test="${userRole == 'TEACHER'}">
            <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />
        </c:otherwise>
    </c:choose>

    <!-- Main Content -->
    <div class="main-content flex-grow-1 d-flex flex-column" style="min-width: 0;">
        <c:set var="searchPlaceholder" value="Search again..." scope="request" />
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-lg-5 w-100" style="max-width: 1400px; margin: 0 auto;">
            
            <div class="mb-4">
                <h1 class="h3 brand-headline fw-bold text-on-surface mb-2">Search Results</h1>
                <p class="text-on-surface-variant">Showing results for "<span class="fw-semibold text-primary"><c:out value="${searchQuery}"/></span>"</p>
            </div>

            <div class="card-sleek p-0">
                <c:choose>
                    <c:when test="${empty results}">
                        <div class="text-center py-5">
                            <i class="fa-solid fa-magnifying-glass fs-1 text-on-surface-variant opacity-50 mb-3"></i>
                            <h5 class="fw-semibold text-on-surface">No results found</h5>
                            <p class="text-on-surface-variant mb-0">Try adjusting your search query or check for typos.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush border-0">
                            <c:forEach var="res" items="${results}">
                                <a href="${res.url}" class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3 border-outline-variant hover-lift" style="transition: all 0.2s;">
                                    <div class="d-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle" style="width: 48px; height: 48px;">
                                        <c:choose>
                                            <c:when test="${res.type == 'User'}"><i class="fa-solid fa-user"></i></c:when>
                                            <c:when test="${res.type == 'Assignment'}"><i class="fa-solid fa-file-pen"></i></c:when>
                                            <c:otherwise><i class="fa-regular fa-file"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-grow-1 min-w-0">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <h6 class="mb-0 fw-semibold text-on-surface text-truncate"><c:out value="${res.title}"/></h6>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill" style="font-size: 11px;"><c:out value="${res.badge}"/></span>
                                        </div>
                                        <p class="mb-0 text-on-surface-variant small text-truncate"><c:out value="${res.subtitle}"/></p>
                                    </div>
                                    <i class="fa-solid fa-chevron-right text-on-surface-variant ms-2 small"></i>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
