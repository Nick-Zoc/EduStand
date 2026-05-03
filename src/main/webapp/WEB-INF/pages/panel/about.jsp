<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | About</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="searchPlaceholder" value="Search pages..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">

    <c:choose>
        <c:when test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
            <c:set var="activeSidebar" value="about" scope="request" />
            <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />
        </c:when>
        <c:when test="${sessionScope.loggedInUser.role eq 'TEACHER'}">
            <c:set var="activeSidebar" value="about" scope="request" />
            <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />
        </c:when>
        <c:otherwise>
            <c:set var="activeSidebar" value="about" scope="request" />
            <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />
        </c:otherwise>
    </c:choose>

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1200px; gap: 1.5rem;">
            <section class="about-hero p-4 p-md-5">
                <div class="small text-uppercase fw-semibold text-primary mb-2" style="letter-spacing: 0.08em;">About Platform</div>
                <h1 class="brand-headline fw-bold mb-3" style="font-size: clamp(2rem, 4vw, 3rem);">Transform Your Learning Ecosystem</h1>
                <p class="text-on-surface-variant mb-0" style="max-width: 54rem; font-size: 1.05rem;">EduStand adapts modern platform-thinking inspired by Nepal Solution Hub: designing digital ecosystems, building scalable products, and helping institutions move faster with reliable software.</p>
            </section>

            <section class="row g-3">
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="about-stat-card p-4 h-100">
                        <div class="about-stat-value">120k+</div>
                        <div class="text-on-surface-variant fw-semibold">Lines of code mindset</div>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="about-stat-card p-4 h-100">
                        <div class="about-stat-value">100%</div>
                        <div class="text-on-surface-variant fw-semibold">Commitment to quality</div>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="about-stat-card p-4 h-100">
                        <div class="about-stat-value">6-Step</div>
                        <div class="text-on-surface-variant fw-semibold">Delivery process</div>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="about-stat-card p-4 h-100">
                        <div class="about-stat-value">24/7</div>
                        <div class="text-on-surface-variant fw-semibold">Support-first culture</div>
                    </div>
                </div>
            </section>

            <section class="about-content-card p-4 p-md-5">
                <div class="row g-4">
                    <div class="col-12 col-lg-6">
                        <h3 class="brand-headline fw-bold mb-3">Our Service Philosophy</h3>
                        <ul class="list-unstyled d-flex flex-column gap-3 mb-0">
                            <li class="d-flex gap-3"><i class="fa-solid fa-code text-primary mt-1"></i><span>Custom software solutions tailored to educational institutions and platform workflows.</span></li>
                            <li class="d-flex gap-3"><i class="fa-solid fa-globe text-primary mt-1"></i><span>Modern web development with responsive UX and maintainable architecture.</span></li>
                            <li class="d-flex gap-3"><i class="fa-solid fa-mobile-screen-button text-primary mt-1"></i><span>Mobile-first thinking for students, teachers, and administrators on the go.</span></li>
                            <li class="d-flex gap-3"><i class="fa-solid fa-shield-halved text-primary mt-1"></i><span>Reliable delivery process: discovery, design, development, testing, launch, support.</span></li>
                        </ul>
                    </div>
                    <div class="col-12 col-lg-6">
                        <h3 class="brand-headline fw-bold mb-3">Why This Matters For EduStand</h3>
                        <div class="d-flex flex-column gap-3">
                            <div class="about-point p-3 rounded-3">
                                <div class="fw-bold">Scalable Growth</div>
                                <small class="text-on-surface-variant">Architecture designed to grow with new modules, users, and academic programs.</small>
                            </div>
                            <div class="about-point p-3 rounded-3">
                                <div class="fw-bold">Enterprise Quality</div>
                                <small class="text-on-surface-variant">Production-grade patterns, robust data workflows, and structured administration.</small>
                            </div>
                            <div class="about-point p-3 rounded-3">
                                <div class="fw-bold">Digital Economy Ready</div>
                                <small class="text-on-surface-variant">A platform that helps institutions modernize student services and academic collaboration.</small>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
