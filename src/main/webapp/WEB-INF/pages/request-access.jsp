<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand - Request Access</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Local design tokens & universal styles -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css'/>">
    <style>
        .max-w-5xl { max-width: 1024px; }
        .min-vh-60 { min-height: 60vh; }
        @media (min-width: 768px) {
            .min-vh-md-75 { min-height: 75vh; }
        }
        .request-textarea {
            min-height: 108px;
            resize: none;
        }
    </style>
</head>
<body class="bg-surface min-vh-100 d-flex align-items-center justify-content-center p-3 p-md-4">

    <main class="container-fluid max-w-5xl p-0">
        <div class="row g-0 main-panel card-sleek bg-surface-container-lowest min-vh-60 min-vh-md-75">

            <!-- Left Side: Request Access Form -->
            <div class="col-12 col-md-6 d-flex flex-column justify-content-center p-4 py-5 p-md-5 p-lg-5">
                <div class="mb-4">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                            <i class="fa-solid fa-user-plus fs-5"></i>
                        </div>
                        <span class="brand-headline fs-5 fw-bold text-primary">EduStand</span>
                    </div>
                    <h1 class="brand-headline fs-4 fw-bold text-on-surface mb-1">Request access</h1>
                    <p class="text-on-surface-variant small mb-0">Send your details and we will review your access request.</p>
                </div>

                <form action="#" method="post" class="vstack gap-3">
                    <div class="input-group input-group-float">
                        <span class="input-group-text input-icon-addon"><i class="fa-solid fa-user"></i></span>
                        <div class="form-floating flex-grow-1">
                            <input type="text" class="form-control input-with-addon" id="fullName" name="fullName" placeholder="Full Name" required>
                            <label for="fullName">Full Name</label>
                        </div>
                    </div>

                    <div class="input-group input-group-float">
                        <span class="input-group-text input-icon-addon"><i class="fa-solid fa-envelope"></i></span>
                        <div class="form-floating flex-grow-1">
                            <input type="email" class="form-control input-with-addon" id="requestEmail" name="email" placeholder="University Email" required>
                            <label for="requestEmail">University Email</label>
                        </div>
                    </div>

                    <div class="input-group input-group-float">
                        <span class="input-group-text input-icon-addon"><i class="fa-solid fa-user-graduate"></i></span>
                        <div class="form-floating flex-grow-1">
                            <select class="form-select" id="role" name="role" required>
                                <option value="" selected disabled>Select Role</option>
                                <option value="student">Student</option>
                                <option value="teacher">Teacher</option>
                                <option value="admin">Administrator</option>
                            </select>
                            <label for="role">Role</label>
                        </div>
                    </div>

                    <div class="form-floating">
                        <textarea class="form-control request-textarea" id="reason" name="reason" placeholder="Reason" required></textarea>
                        <label for="reason">Reason for Access</label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-primary-edu w-100 py-2 mt-2 fw-semibold">Submit Request</button>

                    <div class="text-center mt-1">
                        <a href="<c:url value='/login'/>" class="small fw-semibold text-primary-link forgot-link-inline"><i class="fa-solid fa-arrow-left me-1"></i>Back to Login</a>
                    </div>
                </form>

                <p class="mt-4 text-center small text-on-surface-variant mb-0">
                    Already have access? <a href="<c:url value='/login'/>" class="fw-semibold text-primary-link">Sign in</a>
                </p>
            </div>

            <!-- Right Side: Same visual panel as Login -->
            <div class="col-12 col-md-6 d-none d-md-flex position-relative align-items-center justify-content-center overflow-hidden login-visual-panel" style="background-color: #f0f7ff;">
                <div class="login-bg-orb orb-1"></div>
                <div class="login-bg-orb orb-2"></div>

                <div class="position-relative z-1 p-5 text-center w-100 d-flex flex-column align-items-center justify-content-center">

                    <div class="mb-5 d-flex justify-content-center">
                        <div class="position-relative">
                            <div class="position-relative glass-panel glass-card rounded-4 p-4 d-flex flex-column align-items-center justify-content-center" style="width: 13rem; height: 13rem;">
                                <i class="fa-solid fa-cloud-arrow-up text-primary mb-4" style="font-size: 3.2rem;"></i>
                                <div class="w-100 bg-surface-container-high rounded-pill overflow-hidden" style="height: 6px;">
                                    <div class="bg-primary h-100" style="width: 75%;"></div>
                                </div>
                                <span class="mt-3 fw-bold text-primary text-uppercase text-center" style="font-size: 10px; letter-spacing: 0.08em;">Syncing resources</span>
                            </div>
                        </div>
                    </div>

                    <h2 class="brand-headline fs-4 fw-bold text-on-surface mb-3">Share. Find. Study.</h2>
                    <p class="text-on-surface-variant mx-auto small" style="max-width: 20rem; line-height: 1.6;">
                        A simple place to share study materials and manage classes with your peers and instructors.
                    </p>

                    <div class="mt-4 mt-lg-5 w-100" style="max-width: 24rem;">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="glass-panel glass-card p-3 rounded-3 text-start w-100">
                                    <i class="fa-solid fa-folder-tree text-primary fs-5 mb-2"></i>
                                    <div class="fw-bold text-uppercase text-on-surface-variant mb-1" style="font-size: 10px; letter-spacing: -0.02em;">Shared Resources</div>
                                    <div class="small fw-semibold text-on-surface">12.4k Resources</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="glass-panel glass-card p-3 rounded-3 text-start w-100">
                                    <i class="fa-solid fa-users-viewfinder text-primary fs-5 mb-2"></i>
                                    <div class="fw-bold text-uppercase text-on-surface-variant mb-1" style="font-size: 10px; letter-spacing: -0.02em;">Active Users</div>
                                    <div class="small fw-semibold text-on-surface">850 Students</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="position-absolute rounded-circle" style="top: 2.5rem; right: 2.5rem; width: 8rem; height: 8rem; border: 2px solid rgba(0, 127, 255, 0.08); z-index: 0;"></div>
                <div class="position-absolute rounded-4" style="bottom: -1.25rem; left: -1.25rem; width: 12rem; height: 12rem; background: linear-gradient(to top right, rgba(0, 127, 255, 0.08), transparent); transform: rotate(45deg); z-index: 0;"></div>
            </div>

        </div>
    </main>

    <!-- Bootstrap bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>