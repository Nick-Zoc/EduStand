<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Student Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Local design tokens & universal styles -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .sidebar {
            width: 280px;
            height: 100vh;
            border-right: 1px solid var(--outline-variant);
            background: var(--surface-container-lowest);
        }
        .main-content {
            margin-left: 280px;
            width: calc(100% - 280px);
        }
        .nav-link-custom {
            color: var(--on-surface-variant);
            font-weight: 500;
            transition: all 0.2s;
            border-radius: var(--roundness);
        }
        .nav-link-custom:hover, .nav-link-custom.active {
            color: var(--primary);
            background-color: var(--surface-container);
        }
        .nav-link-custom.active {
            font-weight: 600;
        }
        .icon-w { width: 24px; text-align: center; }
        
        .hero-banner {
            background: linear-gradient(135deg, #007FFF 0%, #0056b3 100%);
            box-shadow: 0 10px 25px rgba(0, 127, 255, 0.2);
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1040;
                transition: transform 0.3s ease;
            }
            .sidebar.show {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
                width: 100%;
            }
        }
    </style>
</head>
<body class="bg-surface text-on-surface d-flex min-vh-100">

    <!-- Sidebar -->
    <aside class="sidebar d-none d-md-flex flex-column position-fixed top-0 start-0 py-4 px-3">
        
        <!-- Logo Area -->
        <div class="d-flex align-items-center gap-3 mb-5 px-2">
            <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                <i class="fa-solid fa-graduation-cap fs-6"></i>
            </div>
            <div>
                <h1 class="fs-5 fw-bold text-primary brand-headline m-0">EduStand</h1>
                <p class="small fw-bold text-outline-variant m-0" style="font-size: 10px; letter-spacing: 0.1em; color: var(--outline);">THE DIGITAL CURATOR</p>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="flex-grow-1 d-flex flex-column gap-2">
            <a href="#" class="nav-link-custom active d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
                <i class="fa-solid fa-table-columns fs-6 icon-w"></i>
                <span class="brand-headline small">Dashboard</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
                <i class="fa-solid fa-book-open fs-6 icon-w"></i>
                <span class="brand-headline small">Courses</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
                <i class="fa-solid fa-clipboard-list fs-6 icon-w"></i>
                <span class="brand-headline small">Assignments</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
                <i class="fa-solid fa-users fs-6 icon-w"></i>
                <span class="brand-headline small">Community</span>
            </a>
        </nav>

        <div class="mt-auto pt-4 border-top border-outline-variant d-flex flex-column gap-2">
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
                <i class="fa-solid fa-gear fs-6 icon-w"></i>
                <span class="brand-headline small">Settings</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none text-danger">
                <i class="fa-solid fa-right-from-bracket fs-6 icon-w"></i>
                <span class="brand-headline small">Logout</span>
            </a>
            <button class="btn btn-light d-flex align-items-center gap-2 justify-content-center w-100 mt-2 text-outline bg-surface-container-low rounded border-0" id="collapseSidebarBtn" onclick="document.querySelector('.sidebar').classList.toggle('show'); document.querySelector('.sidebar').classList.add('d-none');">
                <i class="fa-solid fa-chevron-left"></i>
                <span style="font-size: 12px; font-weight: 700; text-transform: uppercase;">Collapse</span>
            </button>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content d-flex flex-column min-vh-100">
        <!-- Topbar -->
        <header class="d-flex justify-content-between align-items-center w-100 px-4 py-3 bg-white border-bottom border-outline-variant sticky-top shadow-sm" style="z-index: 1030;">
            <div class="d-flex align-items-center flex-grow-1" style="max-width: 600px;">
                <button class="btn btn-light d-md-none border-0 bg-transparent text-on-surface me-2 p-1" id="sidebarToggle" onclick="document.querySelector('.sidebar').classList.toggle('show'); document.querySelector('.sidebar').classList.remove('d-none');">
                    <i class="fa-solid fa-bars fs-5"></i>
                </button>
                <div class="position-relative w-100">
                    <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 1rem;"></i>
                    <input class="form-control bg-surface-container border-0 rounded-pill py-2 small w-100" style="padding-left: 2.5rem;" placeholder="Search for courses or resources..." type="text"/>
                </div>
            </div>
            
            <div class="d-flex align-items-center gap-4 ms-4">
                <div class="position-relative cursor-pointer text-on-surface-variant">
                    <i class="fa-regular fa-bell fs-5"></i>
                    <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="d-none d-sm-block text-end me-1">
                        <p class="brand-headline fw-semibold m-0 text-on-surface" style="font-size: 0.9rem;">Alex Thompson</p>
                        <p class="text-on-surface-variant m-0" style="font-size: 0.75rem;">Student</p>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=Alex+Thompson&background=007FFF&color=fff" alt="Profile" class="rounded-circle" width="36" height="36">
                </div>
            </div>
        </header>

        <!-- Container -->
        <div class="p-4 p-md-5 mx-auto w-100" style="max-width: 1280px; gap: 2.5rem; display: flex; flex-direction: column;">
            
            <!-- Hero Section -->
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white hero-banner">
                <div class="position-relative z-1" style="max-width: 600px;">
                    <h2 class="fw-bolder mb-3 brand-headline" style="font-size: calc(1.5rem + 1vw);">Welcome back, Alex Thompson</h2>
                    <p class="fs-5 fw-medium opacity-75 mb-0">You have 3 upcoming classes today and 2 new resources available.</p>
                    
                    <div class="mt-4 pt-2 d-flex gap-3">
                        <button class="btn bg-white text-primary fw-bold px-4 py-2 rounded-3 shadow-sm border-0" style="font-size: 14px;">View Schedule</button>
                        <button class="btn border border-white text-white fw-bold px-4 py-2 rounded-3" style="background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(10px); font-size: 14px;">Check Resources</button>
                    </div>
                </div>
                <!-- Ornaments -->
                <div class="position-absolute rounded-circle" style="right: -5rem; bottom: -5rem; width: 20rem; height: 20rem; background: rgba(255,255,255,0.1); filter: blur(48px);"></div>
                <div class="position-absolute rounded-circle" style="right: 2.5rem; top: 2.5rem; width: 10rem; height: 10rem; background: rgba(255,255,255,0.05); filter: blur(32px);"></div>
            </section>

            <!-- Classroom Schedule -->
            <section>
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h3 class="fs-5 fw-bold text-on-surface d-flex align-items-center gap-2 m-0 brand-headline">
                        <i class="fa-solid fa-calendar-day text-primary"></i> My Classroom Schedule
                    </h3>
                    <button class="btn btn-link text-primary text-decoration-none fw-bold text-uppercase p-0" style="font-size: 11px; letter-spacing: 0.1em;">View Full Calendar</button>
                </div>
                
                <div class="row g-4">
                    <div class="col-12 col-md-4">
                        <div class="card-curator p-4 h-100 transition">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="bg-primary-container text-primary fw-bold rounded px-2 py-1 text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">09:00 AM</span>
                                <i class="fa-solid fa-ellipsis-vertical text-outline fs-5"></i>
                            </div>
                            <h4 class="fs-5 fw-bold text-on-surface mb-2">Advanced Mathematics</h4>
                            <div class="d-flex flex-column gap-2 mt-3">
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-user text-primary" style="opacity: 0.7; width:16px;"></i> <span>Prof. Miller</span>
                                </div>
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-door-open text-primary" style="opacity: 0.7; width:16px;"></i> <span>Hall A</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-4">
                        <div class="card-curator p-4 h-100 transition">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="bg-primary-container text-primary fw-bold rounded px-2 py-1 text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">11:30 AM</span>
                                <i class="fa-solid fa-ellipsis-vertical text-outline fs-5"></i>
                            </div>
                            <h4 class="fs-5 fw-bold text-on-surface mb-2">Quantum Physics</h4>
                            <div class="d-flex flex-column gap-2 mt-3">
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-user text-primary" style="opacity: 0.7; width:16px;"></i> <span>Dr. Sarah Jenkins</span>
                                </div>
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-door-open text-primary" style="opacity: 0.7; width:16px;"></i> <span>Lab 402</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="card-curator p-4 h-100 transition position-relative overflow-hidden" style="border-left: 4px solid var(--primary);">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="bg-primary-container text-primary fw-bold rounded px-2 py-1 text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">02:15 PM</span>
                                <i class="fa-solid fa-ellipsis-vertical text-outline fs-5"></i>
                            </div>
                            <h4 class="fs-5 fw-bold text-on-surface mb-2">Computer Architecture</h4>
                            <div class="d-flex flex-column gap-2 mt-3">
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-user text-primary" style="opacity: 0.7; width:16px;"></i> <span>Prof. Alan Turing</span>
                                </div>
                                <div class="d-flex align-items-center gap-2 small text-on-surface-variant">
                                    <i class="fa-solid fa-door-open text-primary" style="opacity: 0.7; width:16px;"></i> <span>Tech Wing B</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Bottom Section: Recent Resources -->
            <section>
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h3 class="fs-5 fw-bold text-on-surface d-flex align-items-center gap-2 m-0 brand-headline">
                        <i class="fa-solid fa-folder-open text-primary"></i> Recent Resources
                    </h3>
                    <button class="btn btn-link text-primary text-decoration-none fw-bold text-uppercase p-0" style="font-size: 11px; letter-spacing: 0.1em;">Explore Index</button>
                </div>

                <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-5 g-3">
                    <div class="col">
                        <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                            <div class="bg-primary-container rounded-3 d-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px; color: var(--primary);">
                                <i class="fa-solid fa-file-pdf fs-3"></i>
                            </div>
                            <span class="text-on-surface fw-semibold text-truncate w-100 mb-3" style="font-size: 12px;">Physics_Notes.pdf</span>
                            <button class="btn btn-primary-edu rounded-circle shadow-sm mt-auto d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; padding:0;">
                                <i class="fa-solid fa-download"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                            <div class="rounded-3 d-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px; background-color: #fff3cd; color: #ffc107;">
                                <i class="fa-solid fa-file-word fs-3"></i>
                            </div>
                            <span class="text-on-surface fw-semibold text-truncate w-100 mb-3" style="font-size: 12px;">Math_Assignment.docx</span>
                            <button class="btn btn-primary-edu rounded-circle shadow-sm mt-auto d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; padding:0;">
                                <i class="fa-solid fa-download"></i>
                            </button>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                            <div class="rounded-3 d-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px; background-color: #f8d7da; color: #dc3545;">
                                <i class="fa-solid fa-file-powerpoint fs-3"></i>
                            </div>
                            <span class="text-on-surface fw-semibold text-truncate w-100 mb-3" style="font-size: 12px;">Architecture_Lec.pptx</span>
                            <button class="btn btn-primary-edu rounded-circle shadow-sm mt-auto d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; padding:0;">
                                <i class="fa-solid fa-download"></i>
                            </button>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                            <div class="rounded-3 d-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px; background-color: #e2e3e5; color: #6c757d;">
                                <i class="fa-solid fa-file-video fs-3"></i>
                            </div>
                            <span class="text-on-surface fw-semibold text-truncate w-100 mb-3" style="font-size: 12px;">Lab_Tutorial.mp4</span>
                            <button class="btn btn-primary-edu rounded-circle shadow-sm mt-auto d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; padding:0;">
                                <i class="fa-solid fa-download"></i>
                            </button>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card-sleek p-3 text-center h-100 d-flex flex-column align-items-center">
                            <div class="rounded-3 d-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px; background-color: #d1e7dd; color: #198754;">
                                <i class="fa-solid fa-folder-closed fs-3"></i>
                            </div>
                            <span class="text-on-surface fw-semibold text-truncate w-100 mb-3" style="font-size: 12px;">Semester_Archive.zip</span>
                            <button class="btn btn-primary-edu rounded-circle shadow-sm mt-auto d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; padding:0;">
                                <i class="fa-solid fa-download"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Promotional -->
            <section>
                <div class="row g-4">
                    <div class="col-12 col-md-8">
                        <div class="p-4 p-md-5 rounded-4 d-flex flex-column justify-content-center position-relative overflow-hidden h-100" style="background-color: #1e293b;">
                            <div class="position-relative z-1 text-white">
                                <span class="fw-bold text-uppercase d-block mb-2" style="color: #94a3b8; font-size: 10px; letter-spacing: 0.1em;">Premium Content</span>
                                <h4 class="fs-4 fw-bold mb-3">Mastering Cloud Infrastructure</h4>
                                <p class="small opacity-75 mb-4" style="max-width: 400px;">Gain early access to our industry-certified cloud computing module. limited seats available for the next cohort.</p>
                                <button class="btn btn-light fw-bold px-4 py-2" style="font-size: 12px; border-radius: 8px;">Enroll Now</button>
                            </div>
                            <div class="position-absolute opacity-25" style="right: -2rem; bottom: -2rem;">
                                <i class="fa-solid fa-cloud text-primary" style="font-size: 200px;"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card-curator p-4 p-md-5 rounded-4 d-flex flex-column align-items-center text-center justify-content-center h-100">
                            <div class="bg-primary-container rounded-circle d-flex align-items-center justify-content-center shadow-sm mb-3 text-primary" style="width: 64px; height: 64px;">
                                <i class="fa-solid fa-award fs-1"></i>
                            </div>
                            <h4 class="fw-bold fs-5 text-on-surface mb-2">Dean's List 2026</h4>
                            <p class="text-on-surface-variant small mb-4">You're in the top 5% of your class this term. Keep up the excellence!</p>
                            <button class="btn btn-outline-primary w-100 rounded-3 fw-bold" style="font-size: 12px; padding: 12px 0;">View Certificate</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <footer class="mt-auto py-3 w-100 border-top bg-surface border-outline-variant d-flex justify-content-center">
            <p class="small fw-semibold text-uppercase text-on-surface-variant m-0" style="font-size: 11px; letter-spacing: 0.05em;">© 2026 EduStand | Created with ❤️ by nepalsolutionhub</p>
        </footer>
    </main>

</body>
</html>