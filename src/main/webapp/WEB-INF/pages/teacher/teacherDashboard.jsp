<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Teacher Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Local design tokens & universal styles -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .sidebar {
            width: 256px;
            height: 100vh;
            background-color: var(--surface-container-lowest);
            border-right: 1px solid var(--outline-variant);
            z-index: 1040;
        }
        .main-content {
            margin-left: 256px;
            width: calc(100% - 256px);
        }
        .nav-link-custom {
            color: var(--on-surface-variant);
            font-weight: 500;
            transition: all 0.3s ease-in-out;
            border-radius: 0;
        }
        .nav-link-custom:hover {
            color: var(--primary);
        }
        .nav-link-custom.active {
            background-color: var(--primary-container);
            color: var(--primary);
            border-right: 4px solid var(--primary);
            font-weight: 600;
        }
        .icon-w { width: 24px; text-align: center; }

        .table-index th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--on-surface-variant);
            font-weight: 700;
        }
        .offset-card {
            transition: transform 0.3s;
        }
        @media (min-width: 576px) {
            .offset-card-sm {
                transform: translateY(1.5rem);
            }
        }
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
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
    <aside class="sidebar d-none d-md-flex flex-column position-fixed top-0 start-0">
        <div class="px-4 py-4 mt-2 mb-2 d-flex align-items-center gap-2">
            <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                <i class="fa-solid fa-graduation-cap fs-6"></i>
            </div>
            <div>
                <h1 class="fs-5 fw-bold text-primary brand-headline m-0">EduStand</h1>
                <p class="small fw-semibold m-0" style="color: var(--on-surface-variant); font-size: 11px;">Resource Portal</p>
            </div>
        </div>

        <nav class="flex-grow-1 d-flex flex-column px-3 gap-1">
            <a href="#" class="nav-link-custom active d-flex align-items-center gap-3 px-3 py-3 text-decoration-none">
                <i class="fa-solid fa-chart-line fs-6 icon-w"></i>
                <span class="brand-headline small">Dashboard</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-3 text-decoration-none">
                <i class="fa-solid fa-book-open fs-6 icon-w"></i>
                <span class="brand-headline small">Curriculum</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-3 text-decoration-none">
                <i class="fa-solid fa-folder-tree fs-6 icon-w"></i>
                <span class="brand-headline small">Resources</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-3 text-decoration-none">
                <i class="fa-solid fa-chart-pie fs-6 icon-w"></i>
                <span class="brand-headline small">Analytics</span>
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-3 text-decoration-none">
                <i class="fa-solid fa-gear fs-6 icon-w"></i>
                <span class="brand-headline small">Settings</span>
            </a>
        </nav>

        <div class="p-3 mt-auto">
            <button class="btn btn-light bg-surface-container-low text-decoration-none text-on-surface-variant d-flex align-items-center justify-content-center w-100 gap-2 small border-0 py-2 rounded-3" onclick="document.querySelector('.sidebar').classList.toggle('show'); document.querySelector('.sidebar').classList.add('d-none');">
                <i class="fa-solid fa-chevron-left icon-w"></i>
                <span class="brand-headline fw-bold" style="font-size: 12px; text-transform: uppercase;">Collapse</span>
            </button>
        </div>
    </aside>

    <!-- Main Canvas -->
    <main class="main-content d-flex flex-column min-vh-100">
        <!-- Topbar -->
        <header class="d-flex justify-content-between align-items-center w-100 px-4 py-3 bg-white sticky-top border-bottom border-outline-variant shadow-sm" style="z-index: 1030;">
            <div class="d-flex align-items-center flex-grow-1" style="max-width: 400px;">
                <button class="btn btn-light d-md-none border-0 bg-transparent text-on-surface me-2 p-1" id="sidebarToggle" onclick="document.querySelector('.sidebar').classList.toggle('show'); document.querySelector('.sidebar').classList.remove('d-none');">
                    <i class="fa-solid fa-bars fs-5"></i>
                </button>
                <div class="position-relative w-100">
                    <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 1rem;"></i>
                    <input class="form-control form-control-sm bg-surface-container border-0 rounded-pill py-2 ps-5" placeholder="Search resources..." type="text"/>
                </div>
            </div>
            
            <div class="d-flex align-items-center gap-3">
                <span class="small fw-semibold text-on-surface">Prof. Miller</span>
                <i class="fa-solid fa-circle-user fs-2 text-primary"></i>
            </div>
        </header>

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 2.5rem;">
            <!-- Hero Section: Editorial Premium Style -->
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white shadow-sm" style="background: linear-gradient(135deg, var(--primary) 0%, rgba(0, 86, 179, 1) 100%);">
                <div class="position-relative z-1" style="max-width: 650px;">
                    <h2 class="fs-1 fw-bold mb-3 brand-headline">Welcome back, Prof. Miller</h2>
                    <p class="fs-5 opacity-75 mb-0" style="line-height: 1.6;">Your curriculum overview for Advanced Biochemistry is ready. You have 4 pending resource reviews and 12 new submissions from Semester 2 students.</p>
                    
                    <div class="mt-4 pt-2 d-flex gap-3">
                        <button class="btn bg-white text-primary fw-bold px-4 py-2 shadow-sm border-0 rounded-3" style="font-size: 14px;">View Schedule</button>
                        <button class="btn border border-white text-white fw-bold px-4 py-2 rounded-3" style="background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(10px); font-size: 14px;">Manage Class</button>
                    </div>
                </div>
                <!-- Abstract Decorative Image -->
                <div class="position-absolute h-100 top-0 end-0" style="width: 33%; background: radial-gradient(circle, rgba(255,255,255,0.2) 0%, transparent 70%); border-radius: 50%; right: -5%; filter: blur(30px);"></div>
            </section>

            <!-- Quick Actions & Recent Resources Bento Grid -->
            <section class="row g-4">
                <!-- Manage Resources Area -->
                <div class="col-12 col-md-4">
                    <div class="card-curator p-4 rounded-4 d-flex flex-column h-100">
                        <h3 class="fs-5 fw-bold text-on-surface mb-3 brand-headline">Manage Resources</h3>
                        <div class="d-flex flex-column gap-3 mt-2">
                            <button class="btn bg-surface-container-low border border-outline-variant rounded-3 p-3 d-flex align-items-center justify-content-between text-start icon-btn transition">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fa-solid fa-folder-plus text-primary fs-5"></i>
                                    <span class="small fw-semibold text-on-surface">Create Folder</span>
                                </div>
                                <i class="fa-solid fa-chevron-right text-on-surface-variant small"></i>
                            </button>
                            <button class="btn bg-surface-container-low border border-outline-variant rounded-3 p-3 d-flex align-items-center justify-content-between text-start icon-btn transition">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fa-solid fa-file-arrow-up text-primary fs-5"></i>
                                    <span class="small fw-semibold text-on-surface">Add File</span>
                                </div>
                                <i class="fa-solid fa-chevron-right text-on-surface-variant small"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Recent Resources Grid -->
                <div class="col-12 col-md-8">
                    <div class="d-flex justify-content-between align-items-end mb-4">
                        <h3 class="fs-5 fw-bold brand-headline m-0">Recent Resources</h3>
                        <button class="btn btn-link text-primary p-0 text-decoration-none fw-bold small">View All</button>
                    </div>
                    
                    <div class="row g-4">
                        <div class="col-12 col-sm-6">
                            <div class="card-sleek p-4 h-100 offset-card d-flex flex-column">
                                <div class="d-flex align-items-center justify-content-center rounded-3 mb-3" style="width: 44px; height: 44px; background: var(--primary-container); color: var(--primary);">
                                    <i class="fa-solid fa-file-pdf fs-4"></i>
                                </div>
                                <h4 class="fs-6 fw-bold text-on-surface mb-1">Molecular Bonding.pdf</h4>
                                <p class="small text-on-surface-variant mb-3 pb-1" style="font-size: 12px;">Uploaded 2 hours ago • 4.2MB</p>
                                <div class="d-flex align-items-center justify-content-between mt-auto">
                                    <span class="badge text-uppercase text-danger bg-danger bg-opacity-10 py-1" style="font-size: 10px; letter-spacing: 0.05em;">New</span>
                                    <button class="btn btn-sm btn-light rounded-circle"><i class="fa-solid fa-download text-on-surface-variant"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-sm-6">
                            <div class="card-sleek p-4 h-100 offset-card offset-card-sm d-flex flex-column">
                                <div class="d-flex align-items-center justify-content-center rounded-3 mb-3" style="width: 44px; height: 44px; background: rgba(108, 117, 125, 0.1); color: #6c757d;">
                                    <i class="fa-solid fa-file-powerpoint fs-4"></i>
                                </div>
                                <h4 class="fs-6 fw-bold text-on-surface mb-1">Organic Chem Intro.pptx</h4>
                                <p class="small text-on-surface-variant mb-3 pb-1" style="font-size: 12px;">Uploaded Yesterday • 12.8MB</p>
                                <div class="d-flex align-items-center justify-content-between mt-auto">
                                    <span class="badge text-uppercase text-secondary bg-secondary bg-opacity-10 py-1" style="font-size: 10px; letter-spacing: 0.05em;">Lecture</span>
                                    <button class="btn btn-sm btn-light rounded-circle"><i class="fa-solid fa-download text-on-surface-variant"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Resource Index Table -->
            <section class="mt-4 pt-2">
                <div class="card-curator overflow-hidden">
                    <div class="p-4 border-bottom border-outline-variant d-flex align-items-center justify-content-between">
                        <h3 class="fs-5 fw-bold text-on-surface m-0 brand-headline">Resource Index</h3>
                        <div class="d-flex gap-2">
                            <button class="btn btn-light d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;"><i class="fa-solid fa-filter text-on-surface-variant"></i></button>
                            <button class="btn btn-light d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;"><i class="fa-solid fa-ellipsis-vertical text-on-surface-variant"></i></button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover table-index m-0 align-middle">
                            <thead class="bg-surface">
                                <tr>
                                    <th class="ps-4 py-3 border-bottom-0">Name</th>
                                    <th class="py-3 border-bottom-0">Type</th>
                                    <th class="py-3 border-bottom-0">Last Modified</th>
                                    <th class="py-3 border-bottom-0">Size</th>
                                    <th class="pe-4 py-3 text-end border-bottom-0">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="border-top-0">
                                <tr>
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <i class="fa-solid fa-folder text-primary fs-5"></i>
                                            <span class="small fw-semibold text-on-surface brand-headline">Biochem Unit 01</span>
                                        </div>
                                    </td>
                                    <td class="py-3 small fw-medium text-on-surface-variant">Directory</td>
                                    <td class="py-3 small text-on-surface-variant">Oct 12, 2025</td>
                                    <td class="py-3 small text-on-surface-variant">—</td>
                                    <td class="pe-4 py-3 text-end">
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0 me-2"><i class="fa-solid fa-pen"></i></button>
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0"><i class="fa-solid fa-arrow-up-right-from-square"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <i class="fa-solid fa-file-pdf text-danger fs-5"></i>
                                            <span class="small fw-semibold text-on-surface brand-headline">Lab Safety Protocol</span>
                                        </div>
                                    </td>
                                    <td class="py-3 small fw-medium text-on-surface-variant">PDF Document</td>
                                    <td class="py-3 small text-on-surface-variant">Oct 10, 2025</td>
                                    <td class="py-3 small text-on-surface-variant">1.2 MB</td>
                                    <td class="pe-4 py-3 text-end">
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0 me-2"><i class="fa-solid fa-pen"></i></button>
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0"><i class="fa-solid fa-download"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <i class="fa-solid fa-file-excel text-success fs-5"></i>
                                            <span class="small fw-semibold text-on-surface brand-headline">Student Grades Q3</span>
                                        </div>
                                    </td>
                                    <td class="py-3 small fw-medium text-on-surface-variant">Spreadsheet</td>
                                    <td class="py-3 small text-on-surface-variant">Oct 08, 2025</td>
                                    <td class="py-3 small text-on-surface-variant">854 KB</td>
                                    <td class="pe-4 py-3 text-end">
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0 me-2"><i class="fa-solid fa-pen"></i></button>
                                        <button class="btn btn-sm btn-link text-on-surface-variant p-0"><i class="fa-solid fa-download"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="p-3 d-flex justify-content-between align-items-center small bg-surface border-top border-outline-variant">
                        <span class="fw-semibold text-on-surface-variant">Showing 3 of 248 items</span>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-secondary rounded-pill px-3">Previous</button>
                            <button class="btn btn-sm btn-outline-secondary rounded-pill px-3">Next</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <footer class="mt-auto py-4 w-100 border-top bg-white d-flex justify-content-center">
            <p class="small fw-semibold text-on-surface-variant m-0" style="font-size: 12px;">© 2026 EduStand - Resource Portal</p>
        </footer>
    </main>

</body>
</html>