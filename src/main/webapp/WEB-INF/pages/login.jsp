<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand - Login</title>
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
    </style>
</head>
<body class="bg-surface min-vh-100 d-flex align-items-center justify-content-center p-3 p-md-4">
    
    <main class="container-fluid max-w-5xl p-0">
        <div class="row g-0 main-panel editorial-shadow bg-surface-container-lowest min-vh-60 min-vh-md-75">
            
            <!-- Left Side: Login Form -->
            <div class="col-12 col-md-6 d-flex flex-column justify-content-center p-4 py-5 p-md-5 p-lg-5">
                <div class="mb-5">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            <i class="fa-solid fa-book-open fs-5"></i>
                        </div>
                        <span class="brand-headline fs-5 fw-bold text-primary">The Academic Curator</span>
                    </div>
                    <h1 class="brand-headline fs-3 fw-semibold text-on-surface mb-2">Welcome Back</h1>
                    <p class="text-on-surface-variant small mb-0">Access your curated academic resources and schedules.</p>
                </div>

                <form action="${pageContext.request.contextPath}/login" method="post" class="vstack gap-4">
                    <div>
                        <label for="username" class="form-label small fw-medium text-on-surface">Email or Student ID</label>
                        <div class="position-relative">
                            <i class="fa-solid fa-envelope input-icon"></i>
                            <input type="text" id="username" name="username" class="form-control input-ghost w-100" placeholder="curator@institution.edu" required autofocus>
                        </div>
                    </div>
                    
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label for="password" class="form-label small fw-medium text-on-surface mb-0">Password</label>
                            <a href="${pageContext.request.contextPath}/forgot-password" class="small fw-semibold text-primary-link">Forgot Password?</a>
                        </div>
                        <div class="position-relative">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" class="form-control input-ghost w-100" placeholder="••••••••" required>
                        </div>
                    </div>

                    <div class="form-check py-1">
                        <input class="form-check-input border-outline-variant" type="checkbox" id="remember" name="remember" value="true">
                        <label class="form-check-label text-on-surface-variant mt-1" style="font-size: 0.75rem;" for="remember">Keep me signed in for 30 days</label>
                    </div>

                    <button type="submit" class="btn btn-primary-curator w-100 py-2 py-md-3 mt-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                        Sign In <i class="fa-solid fa-arrow-right-to-bracket small"></i>
                    </button>
                </form>

                <div class="mt-4 pt-4 border-top border-surface-container d-flex flex-column align-items-center gap-3">
                    <span class="text-on-surface-variant text-uppercase fw-bold" style="font-size: 10px; letter-spacing: 0.1em;">Or continue with</span>
                    <div class="d-flex gap-3 w-100">
                        <button class="btn border border-outline-variant text-on-surface-variant bg-surface-container-low icon-btn flex-grow-1 py-1 py-md-2 fw-medium small d-flex align-items-center justify-content-center gap-2">
                            <i class="fa-brands fa-google"></i> Google
                        </button>
                        <button class="btn border border-outline-variant text-on-surface-variant bg-surface-container-low icon-btn flex-grow-1 py-1 py-md-2 fw-medium small d-flex align-items-center justify-content-center gap-2">
                            <i class="fa-solid fa-building-columns"></i> EduPass
                        </button>
                    </div>
                </div>

                <p class="mt-4 text-center small text-on-surface-variant mb-0">
                    New to the platform? <a href="${pageContext.request.contextPath}/request-access" class="fw-semibold text-primary-link">Request Access</a>
                </p>
            </div>

            <!-- Right Side: Aesthetic Geometric Panel -->
            <div class="col-12 col-md-6 d-none d-md-flex position-relative align-items-center justify-content-center overflow-hidden" style="background-color: #f0f7ff;">
                <!-- Background Decorative Elements -->
                <div class="position-absolute top-0 start-0 w-100 h-100 pattern-bg"></div>
                
                <div class="position-relative z-1 p-5 text-center w-100 d-flex flex-column align-items-center justify-content-center">
                    
                    <div class="mb-5 d-flex justify-content-center">
                        <div class="position-relative">
                            <!-- Background blobs -->
                            <div class="position-absolute rounded-circle" style="top: -1.5rem; left: -1.5rem; width: 4rem; height: 4rem; background-color: rgba(0, 120, 212, 0.1); filter: blur(15px);"></div>
                            <div class="position-absolute rounded-circle" style="bottom: -2rem; right: -2rem; width: 6rem; height: 6rem; background-color: rgba(0, 120, 212, 0.2); filter: blur(20px);"></div>
                            
                            <!-- Widget box -->
                            <div class="position-relative glass-panel rounded-4 p-4 d-flex flex-column align-items-center justify-content-center editorial-shadow" style="width: 13rem; height: 13rem;">
                                <i class="fa-solid fa-compass-drafting text-primary mb-4" style="font-size: 3.5rem;"></i>
                                <div class="w-100 bg-surface-container-high rounded-pill overflow-hidden" style="height: 6px;">
                                    <div class="bg-primary h-100" style="width: 75%;"></div>
                                </div>
                                <span class="mt-3 fw-bold text-primary text-uppercase text-center" style="font-size: 10px; letter-spacing: 0.1em;">Syncing Curator Pro</span>
                            </div>
                        </div>
                    </div>

                    <h2 class="brand-headline fs-4 fw-bold text-on-surface mb-3">Empowering Modern Educators</h2>
                    <p class="text-on-surface-variant mx-auto small" style="max-width: 20rem; line-height: 1.6;">
                        A premium digital sanctuary designed for focus, intellectual growth, and seamless resource sharing across your academic ecosystem.
                    </p>

                    <div class="mt-4 mt-lg-5 w-100" style="max-width: 24rem;">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="glass-panel p-3 rounded-3 text-start w-100">
                                    <i class="fa-solid fa-folder-tree text-primary fs-5 mb-2"></i>
                                    <div class="fw-bold text-uppercase text-on-surface-variant mb-1" style="font-size: 10px; letter-spacing: -0.02em;">Shared Assets</div>
                                    <div class="small fw-semibold text-on-surface">12.4k Resources</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="glass-panel p-3 rounded-3 text-start w-100">
                                    <i class="fa-solid fa-users-viewfinder text-primary fs-5 mb-2"></i>
                                    <div class="fw-bold text-uppercase text-on-surface-variant mb-1" style="font-size: 10px; letter-spacing: -0.02em;">Active Users</div>
                                    <div class="small fw-semibold text-on-surface">850 Educators</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Absolute floating shapes for asymmetric editorial look -->
                <div class="position-absolute rounded-circle" style="top: 2.5rem; right: 2.5rem; width: 8rem; height: 8rem; border: 2px solid rgba(0, 120, 212, 0.05); z-index: 0;"></div>
                <div class="position-absolute rounded-4" style="bottom: -1.25rem; left: -1.25rem; width: 12rem; height: 12rem; background: linear-gradient(to top right, rgba(0, 120, 212, 0.1), transparent); transform: rotate(45deg); z-index: 0;"></div>
            </div>
            
        </div>
    </main>

    <!-- Bootstrap bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>