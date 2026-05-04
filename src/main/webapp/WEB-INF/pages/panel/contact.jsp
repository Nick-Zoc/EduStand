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

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Get in Touch</div>
                    <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Contact Us</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Have questions about resources or platform support? Send us a message and our team will follow up.</p>
                </div>
            </div>

            <section class="row g-2 mb-3">
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card-sleek contact-info-card h-100 p-3 text-center">
                        <div class="contact-icon-circle mx-auto mb-2"><i class="fa-solid fa-location-dot"></i></div>
                        <div class="small fw-semibold brand-headline m-0">Address</div>
                        <p class="text-on-surface-variant mt-1 mb-0" style="font-size: 13px;">Imadol, Lalitpur</p>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card-sleek contact-info-card h-100 p-3 text-center">
                        <div class="contact-icon-circle mx-auto mb-2"><i class="fa-solid fa-phone"></i></div>
                        <div class="small fw-semibold brand-headline m-0">Phone</div>
                        <p class="text-on-surface-variant mt-1 mb-0" style="font-size: 13px;">+977 9765018488</p>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card-sleek contact-info-card h-100 p-3 text-center">
                        <div class="contact-icon-circle mx-auto mb-2"><i class="fa-solid fa-envelope"></i></div>
                        <div class="small fw-semibold brand-headline m-0">Email</div>
                        <p class="text-on-surface-variant mt-1 mb-0" style="font-size: 13px;">info@nepalsolutionhub.com</p>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card-sleek contact-info-card h-100 p-3 text-center">
                        <div class="contact-icon-circle mx-auto mb-2"><i class="fa-regular fa-clock"></i></div>
                        <div class="small fw-semibold brand-headline m-0">Hours</div>
                        <p class="text-on-surface-variant mt-1 mb-0" style="font-size: 13px;">Sun-Fri 10AM-5PM</p>
                    </div>
                </div>
            </section>

            <section class="contact-main-card p-3 p-md-4">
                <div class="row g-3">
                    <div class="col-12 col-lg-7">
                        <h3 class="brand-headline fw-bold mb-2">Send a Message</h3>
                        <p class="text-on-surface-variant mb-3" style="font-size: 14px;">Tell us about your request. We typically respond within 1-2 working days.</p>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success border-0 rounded-2 mb-3">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger border-0 rounded-2 mb-3">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/PanelContact" method="post" class="d-flex flex-column gap-2">
                            <div class="row g-2">
                                <div class="col-12 col-md-6">
                                    <input class="form-control" name="fullName" placeholder="Your Name" value="${empty prefillName ? sessionScope.loggedInUser.fullName : prefillName}" required>
                                </div>
                                <div class="col-12 col-md-6">
                                    <input class="form-control" type="email" name="email" placeholder="Your Email" value="${empty prefillEmail ? sessionScope.loggedInUser.email : prefillEmail}" required>
                                </div>
                            </div>
                            <input class="form-control" name="subject" placeholder="Subject" value="${prefillSubject}" required>
                            <textarea class="form-control" rows="4" name="message" placeholder="Your message" required>${prefillMessage}</textarea>
                            <div>
                                <button type="submit" class="btn btn-primary-edu btn-sm px-3 py-2 fw-semibold text-white">Send Message <i class="fa-regular fa-paper-plane ms-1"></i></button>
                            </div>
                        </form>
                    </div>
                    <div class="col-12 col-lg-5">
                        <div class="contact-gradient-panel h-100 p-3 p-md-4 text-white rounded-3">
                            <h3 class="brand-headline fw-bold mb-2" style="font-size: 18px;">Why Contact Us</h3>
                            <p class="mb-3 text-white-50" style="font-size: 14px;">Reach out for partnership, support, or collaboration inquiries.</p>

                            <div class="d-flex flex-column gap-2">
                                <div class="d-flex gap-2 align-items-start">
                                    <div class="contact-mini-dot flex-shrink-0"><i class="fa-solid fa-flask" style="font-size: 14px;"></i></div>
                                    <div>
                                        <div class="fw-bold" style="font-size: 13px;">Research</div>
                                        <small class="text-white-50">Collaboration and insights</small>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 align-items-start">
                                    <div class="contact-mini-dot flex-shrink-0"><i class="fa-solid fa-calendar-days" style="font-size: 14px;"></i></div>
                                    <div>
                                        <div class="fw-bold" style="font-size: 13px;">Events</div>
                                        <small class="text-white-50">Workshops and activities</small>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 align-items-start">
                                    <div class="contact-mini-dot flex-shrink-0"><i class="fa-solid fa-graduation-cap" style="font-size: 14px;"></i></div>
                                    <div>
                                        <div class="fw-bold" style="font-size: 13px;">Support</div>
                                        <small class="text-white-50">Platform assistance</small>
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
