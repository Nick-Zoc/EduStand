<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand Admin Console</title>
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
            border-radius: 8px;
        }
        .nav-link-custom:hover {
            background-color: var(--surface-container-low);
            color: var(--primary);
        }
        .nav-link-custom.active {
            background-color: var(--primary-container);
            color: var(--primary);
            font-weight: 600;
        }
        .icon-w { width: 24px; text-align: center; }
        
        .table-index th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--on-surface-variant);
            font-weight: 700;
        }
        .btn-report {
            background-color: var(--primary-container);
            color: var(--primary) !important;
            transition: transform 0.2s;
        }
        .btn-report:hover {
            filter: brightness(0.95);
        }
        .btn-report:active {
            transform: scale(0.95);
        }
        /* Status dots */
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
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

    <!-- SideNavBar -->
    <aside class="sidebar d-none d-md-flex flex-column position-fixed top-0 start-0 py-4">
        <div class="px-3 d-flex align-items-center gap-3">
            <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                <i class="fa-solid fa-shield-halved fs-6"></i>
            </div>
            <div>
                <h1 class="fs-5 fw-bold text-primary brand-headline m-0">EduStand</h1>
                <p class="small fw-semibold m-0" style="color: var(--on-surface-variant); font-size: 11px;">Admin Console</p>
            </div>
        </div>

        <nav class="flex-grow-1 d-flex flex-column px-3 mt-4 gap-2">
            <a href="#" class="nav-link-custom active d-flex align-items-center gap-3 px-3 py-2 text-decoration-none brand-headline small">
                <i class="fa-solid fa-chart-line fs-6 icon-w"></i>
                Dashboard
            </a>
            <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none brand-headline small">
                <i class="fa-solid fa-users-gear fs-6 icon-w"></i>
                Manage Users
            </a>

            <div class="pt-4 pb-2">
                <button class="btn btn-report w-100 py-2 px-3 rounded-3 d-flex align-items-center justify-content-center gap-2 border-0 fw-bold small brand-headline">
                    <i class="fa-solid fa-plus fs-6"></i>
                    New Report
                </button>
            </div>
        </nav>

        <div class="p-3 mt-auto border-top border-outline-variant">
            <div class="d-flex flex-column gap-1">
                <a href="#" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none brand-headline small">
                    <i class="fa-solid fa-gear fs-6 icon-w"></i>
                    Settings
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link-custom d-flex align-items-center gap-3 px-3 py-2 text-decoration-none brand-headline small text-danger">
                    <i class="fa-solid fa-right-from-bracket fs-6 icon-w"></i>
                    Logout
                </a>
            </div>
        </div>
    </aside>

    <!-- TopNavBar -->
    <header class="d-flex justify-content-between align-items-center px-4 py-3 sticky-top main-content" style="z-index: 1030; height: 64px; background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); border-bottom: 1px solid var(--outline-variant);">
        <div class="d-flex align-items-center flex-grow-1 gap-3">
            <button class="btn btn-light d-md-none border-0 bg-transparent text-on-surface p-1" id="sidebarToggle" onclick="document.querySelector('.sidebar').classList.toggle('show'); document.querySelector('.sidebar').classList.remove('d-none');">
                <i class="fa-solid fa-bars fs-5"></i>
            </button>
            <div class="position-relative w-100" style="max-width: 400px;">
                <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 1rem;"></i>
                <input class="form-control border-0 rounded-pill py-2 small ps-5 bg-surface-container" placeholder="Search resources, users..." type="text" style="font-size: 14px;"/>
            </div>
        </div>
        
        <div class="d-flex align-items-center gap-4 ms-auto">
            <div class="d-flex align-items-center gap-3 d-none d-sm-flex">
                <button class="btn btn-link text-on-surface-variant p-0 text-decoration-none transition-all"><i class="fa-regular fa-bell fs-5"></i></button>
                <button class="btn btn-link text-on-surface-variant p-0 text-decoration-none transition-all"><i class="fa-regular fa-circle-question fs-5"></i></button>
            </div>
            
            <div class="vr mx-2 d-none d-sm-block bg-outline-variant"></div>
            
            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-md-block">
                    <p class="m-0 fw-bold brand-headline text-on-surface" style="font-size: 14px; line-height: 1;">Admin User</p>
                    <p class="m-0 text-uppercase fw-bold mt-1 text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">Super Admin</p>
                </div>
                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold brand-headline bg-primary text-white" style="width: 40px; height: 40px;">
                    AD
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content p-4 p-md-5 d-flex flex-column">
        
        <!-- Metrics Row -->
        <div class="row g-4 mb-5">
            <!-- Card 1 -->
            <div class="col-12 col-md-4">
                <div class="card-sleek p-4 h-100 transition d-flex flex-column justify-content-center">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="p-2 rounded-3 text-primary bg-primary-container d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                            <i class="fa-solid fa-chalkboard-user fs-4"></i>
                        </div>
                        <span class="badge fw-bold text-primary bg-primary-container p-2 rounded-2" style="font-size: 11px;">Teachers</span>
                    </div>
                    <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">1,284</h3>
                    <p class="small text-on-surface-variant m-0 mt-1">Total active educators</p>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="col-12 col-md-4">
                <div class="card-sleek p-4 h-100 transition d-flex flex-column justify-content-center">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #e0f2fe; color: #0284c7; width: 44px; height: 44px;">
                            <i class="fa-solid fa-user-graduate fs-4"></i>
                        </div>
                        <span class="badge fw-bold p-2 rounded-2" style="background-color: #e0f2fe; color: #0284c7; font-size: 11px;">Students</span>
                    </div>
                    <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">14,502</h3>
                    <p class="small text-on-surface-variant m-0 mt-1">Enrolled learners</p>
                </div>
            </div>

            <!-- Card 3 -->
            <div class="col-12 col-md-4">
                <div class="card-sleek p-4 h-100 transition d-flex flex-column justify-content-center">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #fef3c7; color: #d97706; width: 44px; height: 44px;">
                            <i class="fa-solid fa-user-clock fs-4"></i>
                        </div>
                        <span class="badge fw-bold p-2 rounded-2" style="background-color: #fef3c7; color: #d97706; font-size: 11px;">Pending</span>
                    </div>
                    <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0">47</h3>
                    <p class="small text-on-surface-variant m-0 mt-1">Awaiting profile approval</p>
                </div>
            </div>
        </div>

        <!-- User Directory Section -->
        <section class="card-curator overflow-hidden">
            <div class="px-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant bg-surface gap-3">
                <h2 class="fs-5 fw-bold brand-headline text-on-surface m-0">Manage Users</h2>
                <button class="btn btn-primary-edu d-flex align-items-center justify-content-center gap-2 px-4 py-2 fw-bold small text-white border-0 shadow-sm" style="font-size: 13px;">
                    <i class="fa-solid fa-user-plus fs-6"></i>
                    Add New User
                </button>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 m-0 table-index">
                    <thead class="bg-surface">
                        <tr>
                            <th class="border-0 px-4 py-3">Name</th>
                            <th class="border-0 px-4 py-3">User ID</th>
                            <th class="border-0 px-4 py-3">Role</th>
                            <th class="border-0 px-4 py-3">Status</th>
                            <th class="border-0 px-4 py-3 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="border-top-0" style="font-family: 'Inter', sans-serif;">
                        
                        <!-- Row 1 -->
                        <tr class="transition">
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">SM</div>
                                    <div>
                                        <p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;">Sarah Mitchell</p>
                                        <p class="m-0 text-on-surface-variant" style="font-size: 12px;">sarah.m@edustand.edu</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-9283</td>
                            <td class="px-4 py-3">
                                <span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill bg-primary-container text-primary" style="font-size: 10px;">Teacher</span>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="status-dot" style="background-color: #198754;"></span>
                                    <span class="fw-medium text-on-surface" style="font-size: 13px;">Active</span>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-pen"></i></button>
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </td>
                        </tr>

                        <!-- Row 2 -->
                        <tr class="transition">
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">JC</div>
                                    <div>
                                        <p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;">James Chen</p>
                                        <p class="m-0 text-on-surface-variant" style="font-size: 12px;">j.chen@edustand.edu</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-4421</td>
                            <td class="px-4 py-3">
                                <span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill bg-surface-container-highest text-on-surface-variant" style="font-size: 10px;">Student</span>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="status-dot" style="background-color: #198754;"></span>
                                    <span class="fw-medium text-on-surface" style="font-size: 13px;">Active</span>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-pen"></i></button>
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </td>
                        </tr>

                        <!-- Row 3 -->
                        <tr class="transition">
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">EP</div>
                                    <div>
                                        <p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;">Elena Petrov</p>
                                        <p class="m-0 text-on-surface-variant" style="font-size: 12px;">elena.p@edustand.edu</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-1102</td>
                            <td class="px-4 py-3">
                                <span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill bg-primary-container text-primary" style="font-size: 10px;">Teacher</span>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="status-dot" style="background-color: #f59e0b;"></span>
                                    <span class="fw-medium text-on-surface" style="font-size: 13px;">Pending</span>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-pen"></i></button>
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </td>
                        </tr>

                        <!-- Row 4 -->
                        <tr class="transition">
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">AW</div>
                                    <div>
                                        <p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;">Aaron Wright</p>
                                        <p class="m-0 text-on-surface-variant" style="font-size: 12px;">aaron.w@edustand.edu</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-7734</td>
                            <td class="px-4 py-3">
                                <span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill bg-surface-container-highest text-on-surface-variant" style="font-size: 10px;">Student</span>
                            </td>
                            <td class="px-4 py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="status-dot" style="background-color: #dc3545;"></span>
                                    <span class="fw-medium text-on-surface" style="font-size: 13px;">Suspended</span>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-pen"></i></button>
                                    <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
            
            <div class="px-4 py-3 border-top border-outline-variant bg-surface d-flex justify-content-between align-items-center">
                <p class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing 4 of 15,786 users</p>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">Previous</button>
                    <button class="btn btn-primary btn-sm px-3 py-1 rounded-pill fw-medium border-0" style="font-size: 13px;">1</button>
                    <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">2</button>
                    <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">Next</button>
                </div>
            </div>
        </section>

        <footer class="d-flex flex-column flex-sm-row justify-content-between align-items-center px-4 py-4 mt-auto">
            <p class="m-0 small fw-semibold text-on-surface-variant" style="font-size: 12px;">© 2026 EduStand Academic Curator</p>
            <div class="d-flex gap-4 mt-3 mt-sm-0">
                <a href="#" class="text-decoration-none text-on-surface-variant fw-semibold" style="font-size: 12px;">Privacy Policy</a>
                <a href="#" class="text-decoration-none text-on-surface-variant fw-semibold" style="font-size: 12px;">Terms of Service</a>
                <a href="#" class="text-decoration-none text-on-surface-variant fw-semibold" style="font-size: 12px;">Support</a>
            </div>
        </footer>
    </main>

    <!-- Bootstrap bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>