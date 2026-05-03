<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="app-sidebar d-none d-md-flex flex-column position-fixed top-0 start-0 py-4 px-3">
    <div class="d-flex align-items-center gap-3 mb-5 px-2 sidebar-brand-copy">
        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
            <i class="fa-solid fa-graduation-cap fs-6"></i>
        </div>
        <div>
            <h1 class="fs-5 fw-bold text-primary brand-headline m-0 sidebar-brand-text">EduStand</h1>
            <p class="small fw-bold sidebar-subtitle m-0">THE DIGITAL CURATOR</p>
        </div>
    </div>

    <nav class="flex-grow-1 d-flex flex-column gap-2">
        <a href="<c:url value='/StudentDashboard'/>" class="sidebar-nav-link ${activeSidebar eq 'dashboard' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-table-columns fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Dashboard</span>
        </a>
        <a href="#" class="sidebar-nav-link ${activeSidebar eq 'courses' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-book-open fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Courses</span>
        </a>
        <a href="#" class="sidebar-nav-link ${activeSidebar eq 'assignments' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-clipboard-list fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Assignments</span>
        </a>
        <a href="#" class="sidebar-nav-link ${activeSidebar eq 'community' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-users fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Community</span>
        </a>
        <a href="<c:url value='/PanelContact'/>" class="sidebar-nav-link ${activeSidebar eq 'contact' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-address-book fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Contact</span>
        </a>
        <a href="<c:url value='/PanelAbout'/>" class="sidebar-nav-link ${activeSidebar eq 'about' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-circle-info fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">About</span>
        </a>
    </nav>

    <div class="mt-auto pt-4 border-top border-outline-variant d-flex flex-column gap-2">
        <a href="#" class="sidebar-nav-link ${activeSidebar eq 'settings' ? 'active' : ''} d-flex align-items-center gap-3 px-3 py-2 text-decoration-none">
            <i class="fa-solid fa-gear fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Settings</span>
        </a>
        <a href="<c:url value='/logout'/>" class="sidebar-nav-link d-flex align-items-center gap-3 px-3 py-2 text-decoration-none text-danger">
            <i class="fa-solid fa-right-from-bracket fs-6 sidebar-icon"></i>
            <span class="brand-headline small sidebar-label">Logout</span>
        </a>
        <button class="btn sidebar-collapse-btn d-flex align-items-center gap-2 justify-content-center w-100 mt-2 rounded-3 py-2" type="button" onclick="document.body.classList.toggle('sidebar-collapsed');">
            <i class="fa-solid fa-chevron-left"></i>
            <span class="sidebar-collapse-text" style="font-size: 12px; font-weight: 700; text-transform: uppercase;">Collapse</span>
        </button>
    </div>
</aside>