<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Contact</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="searchPlaceholder" value="Search pages..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">

    <c:choose>
        <c:when test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
            <c:set var="activeSidebar" value="contact" scope="request" />
            <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />
        </c:when>
        <c:when test="${sessionScope.loggedInUser.role eq 'TEACHER'}">
            <c:set var="activeSidebar" value="contact" scope="request" />
            <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />
        </c:when>
        <c:otherwise>
            <c:set var="activeSidebar" value="contact" scope="request" />
            <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />
        </c:otherwise>
    </c:choose>

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 1.5rem;">
            <section class="row g-3">
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="contact-info-card h-100 p-4 text-center">
                        <div class="contact-icon-circle mx-auto mb-3"><i class="fa-solid fa-location-dot"></i></div>
                        <h3 class="fs-5 fw-bold brand-headline m-0">Postal Address</h3>
                        <p class="text-on-surface-variant mt-2 mb-0">GPO Box - 7548, Kathmandu, Nepal</p>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="contact-info-card h-100 p-4 text-center">
                        <div class="contact-icon-circle mx-auto mb-3"><i class="fa-solid fa-phone"></i></div>
                        <h3 class="fs-5 fw-bold brand-headline m-0">Call Us</h3>
                        <p class="text-on-surface-variant mt-2 mb-0">+977 9744455464</p>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="contact-info-card h-100 p-4 text-center">
                        <div class="contact-icon-circle mx-auto mb-3"><i class="fa-solid fa-envelope"></i></div>
                        <h3 class="fs-5 fw-bold brand-headline m-0">Email Us</h3>
                        <p class="text-on-surface-variant mt-2 mb-0">info@edustand.edu</p>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-xl-3">
                    <div class="contact-info-card h-100 p-4 text-center">
                        <div class="contact-icon-circle mx-auto mb-3"><i class="fa-regular fa-clock"></i></div>
                        <h3 class="fs-5 fw-bold brand-headline m-0">Open Time</h3>
                        <p class="text-on-surface-variant mt-2 mb-0">Sun - Fri (10 AM - 05 PM)</p>
                    </div>
                </div>
            </section>

            <section class="contact-main-card p-4 p-lg-4">
                <div class="row g-4">
                    <div class="col-12 col-lg-7">
                        <h2 class="brand-headline fw-bold mb-2">Contact Us</h2>
                        <p class="text-on-surface-variant mb-4">Have questions about resources or platform support? Send us a request and our team will follow up.</p>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/PanelContact" method="post" class="d-flex flex-column gap-3">
                            <div class="row g-3">
                                <div class="col-12 col-md-6">
                                    <input class="form-control" name="fullName" placeholder="Your Name" value="${empty prefillName ? sessionScope.loggedInUser.fullName : prefillName}" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <input class="form-control" type="email" name="email" placeholder="Your Email" value="${empty prefillEmail ? sessionScope.loggedInUser.email : prefillEmail}" required>
                                </div>
                            </div>
                            <input class="form-control" name="subject" placeholder="Your Subject" value="${prefillSubject}" required>
                            <textarea class="form-control" rows="5" name="message" placeholder="Write your message" required>${prefillMessage}</textarea>
                            <div>
                                <button type="submit" class="btn btn-primary-edu px-4 py-2 fw-semibold text-white">Send Message <i class="fa-regular fa-paper-plane ms-1"></i></button>
                            </div>
                        </form>
                    </div>
                    <div class="col-12 col-lg-5">
                        <div class="contact-gradient-panel h-100 p-4 p-xl-5 text-white">
                            <h3 class="brand-headline fw-bold mb-3">Collaborate With EduStand</h3>
                            <p class="mb-4 text-white-50">Tell us about your request, institution, and goals. We typically respond within 1-2 working days.</p>

                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="contact-mini-dot"><i class="fa-solid fa-flask"></i></div>
                                    <div>
                                        <div class="fw-bold">Research Collaboration</div>
                                        <small class="text-white-50">Joint research, mentoring, and network building.</small>
                                    </div>
                                </div>
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="contact-mini-dot"><i class="fa-solid fa-calendar-days"></i></div>
                                    <div>
                                        <div class="fw-bold">Events & Workshops</div>
                                        <small class="text-white-50">Capacity building, grants, and online activities.</small>
                                    </div>
                                </div>
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="contact-mini-dot"><i class="fa-solid fa-graduation-cap"></i></div>
                                    <div>
                                        <div class="fw-bold">Scholarship Guidance</div>
                                        <small class="text-white-50">Guidance for opportunities and applications.</small>
                                    </div>
                                </div>
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
