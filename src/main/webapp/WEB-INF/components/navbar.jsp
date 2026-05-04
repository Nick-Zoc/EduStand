<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="resolvedName" value="${not empty userName ? userName : (not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.fullName : 'EduStand User')}" />
<c:set var="resolvedRole" value="${not empty userRole ? userRole : (not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : 'Member')}" />
<c:set var="resolvedInitials" value="${not empty userInitials ? userInitials : fn:toUpperCase(fn:substring(resolvedName, 0, 1))}" />

<header class="dashboard-topbar d-flex justify-content-between align-items-center w-100 px-4 px-lg-5 py-3 sticky-top" style="z-index: 1030;">
    <div class="d-flex align-items-center flex-grow-1 gap-3" style="max-width: 560px;">
        <button class="btn d-md-none sidebar-toggle-btn p-1" type="button" onclick="document.querySelector('.app-sidebar').classList.toggle('show');">
            <i class="fa-solid fa-bars fs-5"></i>
        </button>
        <div class="position-relative w-100">
            <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 1rem;"></i>
            <input class="form-control dashboard-search w-100" placeholder="${empty searchPlaceholder ? 'Search resources, users, or pages...' : searchPlaceholder}" type="text"/>
        </div>
    </div>

    <div class="d-flex align-items-center gap-3 ms-auto">
        <div class="dropdown">
            <button class="btn btn-link notification-trigger p-0 text-decoration-none" type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" aria-label="Open notifications">
                <i class="fa-regular fa-bell fs-5"></i>
                <span class="notification-badge"></span>
            </button>
            <div class="dropdown-menu dropdown-menu-end notification-dropdown p-0 border-0 shadow-lg">
                <div class="p-3 border-bottom border-outline-variant d-flex justify-content-between align-items-center">
                    <h6 class="brand-headline fw-bold mb-0">Notifications</h6>
                    <button id="markAllReadBtn" class="btn btn-sm btn-link p-0 text-on-surface-variant" title="Mark all as read" style="display: none;">
                        <i class="fa-solid fa-check-double small"></i>
                    </button>
                </div>
                <div id="notificationList" class="p-3 d-flex flex-column gap-3" style="max-height: 400px; overflow-y: auto; overflow-x: hidden; word-break: break-word;">
                    <div class="text-center text-on-surface-variant py-3">
                        <i class="fa-regular fa-clock"></i>
                        <p class="small mt-2 mb-0">Loading notifications...</p>
                    </div>
                </div>
                <div class="text-center p-3 border-top border-outline-variant">
                    <a href="#" class="fw-semibold text-decoration-none" style="color: #0f766e;">See All Notifications</a>
                </div>
            </div>
        </div>

        <div class="dropdown">
            <button class="btn btn-link p-0 text-decoration-none d-flex align-items-center gap-3 profile-trigger" type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" aria-label="Open profile menu">
                <div class="text-end d-none d-md-block">
                    <p class="m-0 fw-bold brand-headline text-on-surface" style="font-size: 14px; line-height: 1;">${resolvedName}</p>
                    <p class="m-0 text-uppercase fw-bold mt-1 text-on-surface-variant" style="font-size: 10px; letter-spacing: 0.05em;">${resolvedRole}</p>
                </div>
                <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser.profilePicturePath}">
                            <c:choose>
                                <c:when test="${not empty sessionScope.profilePictureCacheBuster}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.profilePicturePath}?v=${sessionScope.profilePictureCacheBuster}" alt="Profile" class="profile-avatar" style="width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 2px solid var(--outline-variant);">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.profilePicturePath}" alt="Profile" class="profile-avatar" style="width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 2px solid var(--outline-variant);">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                    <c:otherwise>
                        <div class="profile-avatar">${resolvedInitials}</div>
                    </c:otherwise>
                </c:choose>
            </button>
            <div class="dropdown-menu dropdown-menu-end profile-dropdown p-0 border-0 shadow-lg overflow-hidden">
                <div class="p-3 border-bottom border-outline-variant d-flex align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser.profilePicturePath}">
                            <c:choose>
                                <c:when test="${not empty sessionScope.profilePictureCacheBuster}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.profilePicturePath}?v=${sessionScope.profilePictureCacheBuster}" alt="Profile" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid var(--outline-variant);">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.profilePicturePath}" alt="Profile" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid var(--outline-variant);">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="profile-avatar-lg d-flex align-items-center justify-content-center fw-bold" style="width: 54px; height: 54px; font-size: 18px; background: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%); color: #fff;">
                                ${resolvedInitials}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="min-w-0 flex-grow-1">
                        <div class="fw-bold brand-headline text-on-surface text-truncate">${resolvedName}</div>
                        <div class="mt-1">
                            <span class="edu-badge ${resolvedRole eq 'ADMIN' ? 'bg-danger' : resolvedRole eq 'TEACHER' ? 'edu-badge-teachers' : 'edu-badge-students'} text-uppercase text-white">
                                ${resolvedRole}
                            </span>
                        </div>
                    </div>
                </div>
                <div class="p-2">
                    <a href="${pageContext.request.contextPath}/profile" class="dropdown-item rounded-3 py-2 px-3 d-flex align-items-center gap-3">
                        <i class="fa-regular fa-user text-primary"></i>
                        <span>View Profile</span>
                    </a>
                </div>
                <div class="p-2 border-top border-outline-variant">
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item rounded-3 py-2 px-3 d-flex align-items-center gap-3 text-danger">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const notificationBadge = document.querySelector('.notification-badge');
    const notificationTrigger = document.querySelector('.notification-trigger');
    const notificationList = document.getElementById('notificationList');
    const markAllReadBtn = document.getElementById('markAllReadBtn');
    const contextPath = '${pageContext.request.contextPath}';

    // Load contact requests when notification button is clicked
    if (notificationTrigger) {
        notificationTrigger.addEventListener('click', async () => {
            await loadContactRequests();
        });
    }

    // Mark all as read button
    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', async () => {
            await markAllAsRead();
        });
    }

    async function loadContactRequests() {
        try {
            const response = await fetch(contextPath + '/AdminContactRequests?action=get_unread_json', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (!response.ok) throw new Error('Failed to load notifications');

            const data = await response.json();
            displayNotifications(data);
        } catch (error) {
            console.error('Error loading notifications:', error);
            notificationList.innerHTML = `
                <div class="text-center text-on-surface-variant py-3 text-danger">
                    <i class="fa-regular fa-triangle-exclamation"></i>
                    <p class="small mt-2 mb-0">Failed to load notifications</p>
                </div>
            `;
        }
    }

    async function markAllAsRead() {
        try {
            const response = await fetch(contextPath + '/AdminContactRequests?action=mark_all_read', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (!response.ok) throw new Error('Failed to mark all as read');

            await loadContactRequests();
        } catch (error) {
            console.error('Error marking all as read:', error);
        }
    }

    function displayNotifications(data) {
        if (!data.requests || data.requests.length === 0) {
            notificationList.innerHTML = `
                <div class="text-center text-on-surface-variant py-3">
                    <i class="fa-regular fa-inbox"></i>
                    <p class="small mt-2 mb-0">No notifications</p>
                </div>
            `;
            if (notificationBadge) notificationBadge.style.display = 'none';
            if (markAllReadBtn) markAllReadBtn.style.display = 'none';
            return;
        }

        // Show or hide mark all read button based on unread count
        if (markAllReadBtn) {
            markAllReadBtn.style.display = data.unreadCount > 0 ? 'block' : 'none';
        }

        // Show red dot if there are unread notifications
        if (notificationBadge) {
            notificationBadge.style.display = data.unreadCount > 0 ? 'block' : 'none';
        }

        // Build notification list with professional badge styling
        const notificationHTML = data.requests.map(req => {
            let badgeHTML = '';
            if (req.readStatus === 'UNREAD') {
                badgeHTML = '<span class="edu-badge" style="font-size: 10px; background: #fff1f2; color: #be123c; border-color: #fda4af; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em;">UNREAD</span>';
            } else {
                badgeHTML = '<span class="edu-badge" style="font-size: 10px; background: #ecfdf5; color: #047857; border-color: #a7f3d0; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em;">READ</span>';
            }
            return ''
                + '<div class="notification-item p-2 d-flex gap-2 align-items-start border-bottom border-outline-variant">'
                + '<i class="fa-regular fa-envelope text-primary mt-1" style="min-width: 20px;"></i>'
                + '<div class="flex-grow-1 min-w-0">'
                + '<div class="fw-semibold text-on-surface small notification-title">' + escapeHtml(req.fullName) + '</div>'
                + '<div class="text-on-surface-variant small mt-1 notification-subject">' + escapeHtml(req.subject) + '</div>'
                + '<div class="d-flex gap-2 mt-2 align-items-center">'
                + badgeHTML
                + '<span class="text-on-surface-variant notification-meta" style="font-size: 12px;">' + formatTime(req.createdAt) + '</span>'
                + '</div>'
                + '</div>'
                + '</div>';
        }).join('');

        notificationList.innerHTML = notificationHTML;
    }

    function formatTime(dateStr) {
        const date = new Date(dateStr);
        const now = new Date();
        const diffMs = now - date;
        const diffMins = Math.floor(diffMs / 60000);

        if (diffMins < 1) return 'just now';
        if (diffMins < 60) return diffMins + 'm ago';
        if (diffMins < 1440) return Math.floor(diffMins / 60) + 'h ago';
        return Math.floor(diffMins / 1440) + 'd ago';
    }

    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }
});
</script>