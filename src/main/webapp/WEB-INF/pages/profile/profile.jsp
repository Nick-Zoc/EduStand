<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="profile" scope="request" />
<c:set var="searchPlaceholder" value="Search the portal..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
            <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />
        </c:when>
        <c:when test="${sessionScope.loggedInUser.role eq 'TEACHER'}">
            <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />
        </c:otherwise>
    </c:choose>

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <section class="page-header-sleek px-4 py-4 mb-3">
                <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3">
                    <div>
                        <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Account Settings</div>
                        <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">My Profile</h2>
                        <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Update your contact details, address, and profile picture from one place.</p>
                    </div>
                    <span class="edu-badge edu-badge-status edu-badge-status-active">${profileUser.status}</span>
                </div>
            </section>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success border-0 rounded-3 mb-3">${param.success}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success border-0 rounded-3 mb-3">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 rounded-3 mb-3">${error}</div>
            </c:if>

            <div class="row g-3">
                <div class="col-12 col-lg-4">
                    <div class="panel-sleek p-4 h-100">
                        <div class="d-flex flex-column align-items-center text-center gap-3">
                            <div class="profile-picture-frame overflow-hidden rounded-circle border border-outline-variant bg-surface-container d-flex align-items-center justify-content-center" style="width: 132px; height: 132px;">
                                <c:choose>
                                    <c:when test="${not empty profileUser.profilePicturePath}">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.profilePictureCacheBuster}">
                                                <img id="profilePreviewImage" src="${pageContext.request.contextPath}/${profileUser.profilePicturePath}?v=${sessionScope.profilePictureCacheBuster}" alt="Profile picture" class="w-100 h-100 object-fit-cover">
                                            </c:when>
                                            <c:otherwise>
                                                <img id="profilePreviewImage" src="${pageContext.request.contextPath}/${profileUser.profilePicturePath}" alt="Profile picture" class="w-100 h-100 object-fit-cover">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img id="profilePreviewImage" src="${pageContext.request.contextPath}/${profileUser.profilePicturePath}" alt="Profile picture" class="w-100 h-100 object-fit-cover d-none">
                                    </c:otherwise>
                                </c:choose>
                                <span id="profilePreviewInitial" class="fs-1 fw-bold text-primary ${empty profileUser.profilePicturePath ? '' : 'd-none'}">${empty profileUser.fullName ? 'U' : fn:toUpperCase(fn:substring(profileUser.fullName, 0, 1))}</span>
                            </div>
                            <div>
                                <h3 class="fs-4 fw-bold brand-headline mb-1">${profileUser.fullName}</h3>
                                <p class="text-on-surface-variant mb-1">${profileUser.email}</p>
                                <span class="edu-badge ${profileUser.role eq 'ADMIN' ? 'bg-danger text-white' : profileUser.role eq 'TEACHER' ? 'edu-badge-teachers' : 'edu-badge-students'} text-uppercase">${profileUser.role}</span>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top border-outline-variant">
                            <div class="d-flex justify-content-between py-2 small"><span class="text-on-surface-variant">Phone</span><span class="fw-semibold text-on-surface">${empty profileUser.phoneNumber ? 'Not set' : profileUser.phoneNumber}</span></div>
                            <div class="d-flex justify-content-between py-2 small"><span class="text-on-surface-variant">Address</span><span class="fw-semibold text-on-surface text-end ms-3">${empty profileUser.address ? 'Not set' : profileUser.address}</span></div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-8">
                    <div class="panel-sleek p-4">
                        <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="row g-3">
                            <div class="col-12">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" name="fullName" class="form-control input-ghost" value="${profileUser.fullName}" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" name="email" class="form-control input-ghost" value="${profileUser.email}" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="text" name="phoneNumber" class="form-control input-ghost" value="${profileUser.phoneNumber}" placeholder="e.g. +94 77 123 4567">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Address</label>
                                <textarea name="address" class="form-control input-ghost" rows="4" placeholder="Street, city, district, country">${profileUser.address}</textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Profile Picture</label>
                                <input id="profilePictureInput" type="file" name="profilePicture" class="form-control input-ghost" accept="image/*">
                                <div class="form-text text-on-surface-variant">Choose a JPG, PNG, or WebP image. A new upload replaces the current picture.</div>
                            </div>
                            <div class="col-12 d-flex flex-column flex-sm-row gap-2 pt-2">
                                <button class="btn btn-primary-edu px-4 py-2 fw-semibold" type="submit">Save Changes</button>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger px-4 py-2 fw-semibold">Logout</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            const input = document.getElementById('profilePictureInput');
            const preview = document.getElementById('profilePreviewImage');
            const initial = document.getElementById('profilePreviewInitial');

            if (!input || !preview || !initial) {
                return;
            }

            input.addEventListener('change', () => {
                const file = input.files && input.files[0];
                if (!file) {
                    return;
                }

                const reader = new FileReader();
                reader.onload = (event) => {
                    preview.src = event.target.result;
                    preview.classList.remove('d-none');
                    initial.classList.add('d-none');
                };
                reader.readAsDataURL(file);
            });
        })();
    </script>
</body>
</html>