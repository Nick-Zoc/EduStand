<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="users" scope="request" />
<c:set var="searchPlaceholder" value="Search users..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="users-page-intro d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="users-kicker small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Manage Users</div>
                    <h2 class="users-title fs-1 fw-bold m-0 brand-headline text-on-surface">All Users</h2>
                    <p class="users-subtitle text-on-surface-variant mb-0" style="max-width: 46rem; line-height: 1.6;">Review accounts, update roles and status, and remove users.</p>
                </div>
                <button class="btn btn-primary-edu d-inline-flex align-items-center gap-2 px-4 py-2 fw-semibold text-white border-0" type="button" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fa-solid fa-user-plus"></i>
                    Add User
                </button>
            </div>

            <div id="usersAlertContainer">
                <c:if test="${not empty success}">
                    <div class="alert alert-success border-0 rounded-0 m-0" role="alert">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger border-0 rounded-0 m-0" role="alert">${error}</div>
                </c:if>
            </div>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-xl-row align-items-xl-center gap-2 gap-xl-3 border-bottom border-outline-variant">
                    <div class="position-relative flex-grow-1 users-search-wrap">
                        <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 0.85rem;"></i>
                        <input id="usersSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search users" />
                    </div>
                    <select id="roleFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by role">
                        <option value="ALL">All roles</option>
                        <option value="ADMIN">Admin</option>
                        <option value="TEACHER">Teacher</option>
                        <option value="STUDENT">Student</option>
                    </select>
                    <select id="statusFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by status">
                        <option value="ALL">All status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="PENDING">Pending</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                    <select id="rowsPerPage" class="form-select users-select-filter users-compact-filter" aria-label="Rows per page">
                        <option value="10">10 rows</option>
                        <option value="15">15 rows</option>
                        <option value="20" selected>20 rows</option>
                        <option value="25">25 rows</option>
                    </select>
                    <button id="bulkDeleteIconBtn" class="btn btn-outline-danger users-delete-icon-btn" type="button" title="Delete selected users" aria-label="Delete selected users">
                        <i class="fa-solid fa-trash"></i>
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3 users-th-checkbox"><input type="checkbox" id="selectAllUsers" aria-label="Select all users on this page"></th>
                                <th class="px-3 px-md-4 py-3">SN</th>
                                <th class="px-3 px-md-4 py-3">USER</th>
                                <th class="px-3 px-md-4 py-3">ROLE</th>
                                <th class="px-3 px-md-4 py-3">STATUS</th>
                                <th class="px-3 px-md-4 py-3">EMAIL</th>
                                <th class="px-3 px-md-4 py-3 text-end">ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody" class="border-top-0">
                            <c:forEach items="${users}" var="user" varStatus="loop">
                                <tr>
                                    <td class="px-3 px-md-4 py-3"><input type="checkbox" class="user-select" value="${user.userId}"></td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">${loop.count}</td>
                                    <td class="px-3 px-md-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 34px; height: 34px; font-size: 12px;">${empty user.fullName ? 'U' : fn:toUpperCase(fn:substring(user.fullName, 0, 1))}</div>
                                            <span class="fw-semibold text-on-surface"><c:out value="${user.fullName}" /></span>
                                        </div>
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <span class="edu-badge edu-badge-role ${user.role eq 'ADMIN' ? 'edu-badge-role-admin' : user.role eq 'TEACHER' ? 'edu-badge-role-teacher' : 'edu-badge-role-student'}"><c:out value="${user.role}" /></span>
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <span class="edu-badge edu-badge-status ${user.status eq 'ACTIVE' ? 'edu-badge-status-active' : (user.status eq 'PENDING' ? 'edu-badge-status-pending' : 'edu-badge-status-inactive')}"><c:out value="${user.status}" /></span>
                                    </td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant"><c:out value="${user.email}" /></td>
                                    <td class="px-3 px-md-4 py-3 text-end">
                                        <div class="d-inline-flex align-items-center gap-2">
                                            <button class="btn btn-sm btn-light border-0 text-on-surface-variant js-edit-user"
                                                data-user-id="${user.userId}"
                                                data-full-name="<c:out value='${user.fullName}'/>"
                                                data-email="<c:out value='${user.email}'/>"
                                                data-role="${user.role}"
                                                data-status="${user.status}"
                                                type="button">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <button class="btn btn-sm btn-light border-0 text-danger js-delete-user"
                                                data-user-id="${user.userId}"
                                                data-full-name="<c:out value='${user.fullName}'/>"
                                                type="button">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="users-pagination-bar px-3 px-md-4 py-3 border-top border-outline-variant d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                    <p id="usersSummaryText" class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing ${totalUsers} users</p>
                    <div class="d-flex align-items-center gap-2">
                        <button id="prevPageBtn" class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" type="button">Previous</button>
                        <span id="pageIndicator" class="small fw-semibold text-on-surface-variant">Page 1</span>
                        <button id="nextPageBtn" class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" type="button">Next</button>
                    </div>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title brand-headline fw-bold" id="addUserModalLabel">Add Admin User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addUserForm" action="${pageContext.request.contextPath}/AdminUsers" method="post">
                    <input type="hidden" name="action" value="add_user" />
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label for="fullName" class="form-label small fw-semibold text-on-surface-variant">Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter full name" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="email" class="form-label small fw-semibold text-on-surface-variant">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter email" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="password" class="form-label small fw-semibold text-on-surface-variant">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="At least 8 characters" minlength="8" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="role" class="form-label small fw-semibold text-on-surface-variant">Role <span class="text-danger">*</span></label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="ADMIN" selected>Admin</option>
                                    <option value="TEACHER">Teacher</option>
                                    <option value="STUDENT">Student</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="status" class="form-label small fw-semibold text-on-surface-variant">Status <span class="text-danger">*</span></label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="ACTIVE" selected>Active</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <p class="small text-on-surface-variant mt-3 mb-0">Password will be securely hashed before saving.</p>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-primary-edu fw-semibold px-3">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Save User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title brand-headline fw-bold" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editUserForm" action="${pageContext.request.contextPath}/AdminUsers" method="post">
                    <input type="hidden" name="action" value="edit_user" />
                    <input type="hidden" name="userId" id="editUserId" />
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label for="editFullName" class="form-label small fw-semibold text-on-surface-variant">Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="editFullName" name="fullName" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="editEmail" class="form-label small fw-semibold text-on-surface-variant">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="editEmail" name="email" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="editRole" class="form-label small fw-semibold text-on-surface-variant">Role <span class="text-danger">*</span></label>
                                <select class="form-select" id="editRole" name="role" required>
                                    <option value="ADMIN">Admin</option>
                                    <option value="TEACHER">Teacher</option>
                                    <option value="STUDENT">Student</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="editStatus" class="form-label small fw-semibold text-on-surface-variant">Status <span class="text-danger">*</span></label>
                                <select class="form-select" id="editStatus" name="status" required>
                                    <option value="ACTIVE">Active</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="editPassword" class="form-label small fw-semibold text-on-surface-variant">Set New Password (Optional)</label>
                                <input type="password" class="form-control" id="editPassword" name="password" placeholder="Leave blank to keep current password">
                                <p class="small text-on-surface-variant mt-2 mb-0">Current password is never displayed.</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-primary-edu fw-semibold px-3">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Update User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        (() => {
            const contextPath = '${pageContext.request.contextPath}';
            const usersTableBody = document.getElementById('usersTableBody');
            const usersAlertContainer = document.getElementById('usersAlertContainer');
            const usersSummaryText = document.getElementById('usersSummaryText');
            const searchInput = document.getElementById('usersSearchInput');
            const roleFilter = document.getElementById('roleFilter');
            const statusFilter = document.getElementById('statusFilter');
            const rowsPerPage = document.getElementById('rowsPerPage');
            const selectAllUsers = document.getElementById('selectAllUsers');
            const bulkDeleteIconBtn = document.getElementById('bulkDeleteIconBtn');
            const prevPageBtn = document.getElementById('prevPageBtn');
            const nextPageBtn = document.getElementById('nextPageBtn');
            const pageIndicator = document.getElementById('pageIndicator');

            const addUserModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('addUserModal'));
            const editUserModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editUserModal'));

            const state = {
                allUsers: [],
                filteredUsers: [],
                selectedIds: new Set(),
                currentPage: 1,
                pageSize: Number(rowsPerPage.value || 20),
                query: '',
                role: 'ALL',
                status: 'ALL'
            };

            const getInitialsSafe = (value) => {
                if (window.getInitials) {
                    return window.getInitials(value || 'U');
                }
                if (!value) {
                    return 'U';
                }
                return String(value).trim().charAt(0).toUpperCase() || 'U';
            };

            const escapeHtmlSafe = (value) => {
                if (window.escapeHtml) {
                    return window.escapeHtml(value == null ? '' : String(value));
                }
                return String(value == null ? '' : value)
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            };

            const escapeAttrSafe = (value) => {
                if (window.escapeAttribute) {
                    return window.escapeAttribute(value == null ? '' : String(value));
                }
                return escapeHtmlSafe(value);
            };

            function applyFilters() {
                const query = state.query.toLowerCase();
                state.filteredUsers = state.allUsers.filter((user) => {
                    const roleOk = state.role === 'ALL' || user.role === state.role;
                    const statusOk = state.status === 'ALL' || user.status === state.status;
                    if (!roleOk || !statusOk) {
                        return false;
                    }

                    if (!query) {
                        return true;
                    }

                    const haystack = [
                        user.fullName,
                        user.email,
                        user.role,
                        user.status,
                        String(user.userId)
                    ].join(' ').toLowerCase();

                    return haystack.includes(query);
                });

                const totalPages = Math.max(1, Math.ceil(state.filteredUsers.length / state.pageSize));
                if (state.currentPage > totalPages) {
                    state.currentPage = totalPages;
                }
                if (state.currentPage < 1) {
                    state.currentPage = 1;
                }
            }

            function getPagedUsers() {
                const startIndex = (state.currentPage - 1) * state.pageSize;
                return state.filteredUsers.slice(startIndex, startIndex + state.pageSize);
            }

            function roleBadgeClass(role) {
                if (role === 'ADMIN') {
                    return 'edu-badge-role-admin';
                }
                if (role === 'TEACHER') {
                    return 'edu-badge-role-teacher';
                }
                return 'edu-badge-role-student';
            }

            function statusBadgeClass(status) {
                if (status === 'ACTIVE') {
                    return 'edu-badge-status-active';
                }
                if (status === 'PENDING') {
                    return 'edu-badge-status-pending';
                }
                return 'edu-badge-status-inactive';
            }

            function renderTable() {
                const pageUsers = getPagedUsers();
                const startIndex = (state.currentPage - 1) * state.pageSize;

                if (!pageUsers.length) {
                    usersTableBody.innerHTML = '<tr><td colspan="7" class="py-5 text-center text-on-surface-variant">No users found for current filters.</td></tr>';
                    selectAllUsers.checked = false;
                    selectAllUsers.indeterminate = false;
                    return;
                }

                usersTableBody.innerHTML = pageUsers.map((user, index) => {
                    const sn = startIndex + index + 1;
                    const checked = state.selectedIds.has(String(user.userId)) ? 'checked' : '';
                    const initials = getInitialsSafe(user.fullName);

                    return '<tr>'
                        + '<td class="px-3 px-md-4 py-3"><input type="checkbox" class="user-select" value="' + user.userId + '" ' + checked + '></td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + sn + '</td>'
                        + '<td class="px-3 px-md-4 py-3"><div class="d-flex align-items-center gap-3"><div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 34px; height: 34px; font-size: 12px;">' + escapeHtmlSafe(initials) + '</div><span class="fw-semibold text-on-surface">' + escapeHtmlSafe(user.fullName) + '</span></div></td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-role ' + roleBadgeClass(user.role) + '">' + escapeHtmlSafe(user.role) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ' + statusBadgeClass(user.status) + '">' + escapeHtmlSafe(user.status) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + escapeHtmlSafe(user.email) + '</td>'
                        + '<td class="px-3 px-md-4 py-3 text-end"><div class="d-inline-flex align-items-center gap-2">'
                        + '<button class="btn btn-sm btn-light border-0 text-on-surface-variant js-edit-user" data-user-id="' + user.userId + '" data-full-name="' + escapeAttrSafe(user.fullName) + '" data-email="' + escapeAttrSafe(user.email) + '" data-role="' + escapeAttrSafe(user.role) + '" data-status="' + escapeAttrSafe(user.status) + '" type="button"><i class="fa-solid fa-pen"></i></button>'
                        + '<button class="btn btn-sm btn-light border-0 text-danger js-delete-user" data-user-id="' + user.userId + '" data-full-name="' + escapeAttrSafe(user.fullName) + '" type="button"><i class="fa-solid fa-trash"></i></button>'
                        + '</div></td>'
                        + '</tr>';
                }).join('');

                syncSelectAllCheckbox(pageUsers);
            }

            function syncSelectAllCheckbox(pageUsers) {
                if (!pageUsers.length) {
                    selectAllUsers.checked = false;
                    selectAllUsers.indeterminate = false;
                    return;
                }

                const selectedCount = pageUsers.filter((user) => state.selectedIds.has(String(user.userId))).length;
                selectAllUsers.checked = selectedCount === pageUsers.length;
                selectAllUsers.indeterminate = selectedCount > 0 && selectedCount < pageUsers.length;
            }

            function renderPaginationAndSummary() {
                const total = state.filteredUsers.length;
                const totalPages = Math.max(1, Math.ceil(total / state.pageSize));
                const start = total === 0 ? 0 : ((state.currentPage - 1) * state.pageSize) + 1;
                const end = Math.min(total, state.currentPage * state.pageSize);

                usersSummaryText.textContent = total === 0
                    ? 'Showing 0 users'
                    : ('Showing ' + start + ' to ' + end + ' of ' + total + ' users');

                pageIndicator.textContent = 'Page ' + state.currentPage + ' of ' + totalPages;
                prevPageBtn.disabled = state.currentPage <= 1;
                nextPageBtn.disabled = state.currentPage >= totalPages;
                bulkDeleteIconBtn.disabled = state.selectedIds.size === 0;
            }

            function rerender() {
                applyFilters();
                renderTable();
                renderPaginationAndSummary();
            }

            function setUsers(users, showToastMessage, message) {
                state.allUsers = (users || []).map((user) => ({
                    userId: Number(user.userId),
                    fullName: user.fullName || '',
                    email: user.email || '',
                    role: user.role || '',
                    status: user.status || ''
                }));
                state.selectedIds.clear();
                state.currentPage = 1;
                rerender();

                if (showToastMessage && window.showToast) {
                    window.showToast('success', message || 'Users loaded.');
                }
            }

            async function fetchUsers(showToastMessage) {
                try {
                    const response = await fetch(contextPath + '/AdminUsers?action=data', {
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    });
                    if (!response.ok) {
                        throw new Error('Failed to load users data.');
                    }
                    const payload = await response.json();
                    setUsers(payload.users || [], showToastMessage, payload.message || 'Users loaded.');
                } catch (error) {
                    showAlert('danger', error.message || 'Failed to load users.');
                }
            }

            function showAlert(type, message) {
                usersAlertContainer.innerHTML = '<div class="alert alert-' + type + ' border-0 rounded-0 m-0" role="alert">'
                    + escapeHtmlSafe(message)
                    + '</div>';
            }

            document.getElementById('addUserForm').addEventListener('submit', async (event) => {
                event.preventDefault();
                const formParams = new URLSearchParams(new FormData(event.target));
                const payload = await window.postFormData(contextPath + '/AdminUsers', formParams);
                if (!payload) {
                    return;
                }
                if (payload.success) {
                    event.target.reset();
                    addUserModal.hide();
                    setUsers(payload.users || [], false);
                }
                if (window.showToast) {
                    window.showToast(payload.success ? 'success' : 'error', payload.message || 'Operation completed.');
                }
            });

            document.getElementById('editUserForm').addEventListener('submit', async (event) => {
                event.preventDefault();
                const formParams = new URLSearchParams(new FormData(event.target));
                const payload = await window.postFormData(contextPath + '/AdminUsers', formParams);
                if (!payload) {
                    return;
                }
                if (payload.success) {
                    event.target.reset();
                    editUserModal.hide();
                    setUsers(payload.users || [], false);
                }
                if (window.showToast) {
                    window.showToast(payload.success ? 'success' : 'error', payload.message || 'Operation completed.');
                }
            });

            usersTableBody.addEventListener('click', async (event) => {
                const editButton = event.target.closest('.js-edit-user');
                if (editButton) {
                    document.getElementById('editUserId').value = editButton.dataset.userId;
                    document.getElementById('editFullName').value = editButton.dataset.fullName;
                    document.getElementById('editEmail').value = editButton.dataset.email;
                    document.getElementById('editRole').value = editButton.dataset.role;
                    document.getElementById('editStatus').value = editButton.dataset.status;
                    document.getElementById('editPassword').value = '';
                    editUserModal.show();
                    return;
                }

                const deleteButton = event.target.closest('.js-delete-user');
                if (deleteButton) {
                    const fullName = deleteButton.dataset.fullName;
                    const userId = deleteButton.dataset.userId;
                    const confirmed = await window.showConfirm('Delete user', 'Delete ' + fullName + '? This action cannot be undone.');
                    if (!confirmed) {
                        return;
                    }

                    const formData = new URLSearchParams();
                    formData.append('action', 'delete_user');
                    formData.append('userId', userId);

                    const payload = await window.postFormData(contextPath + '/AdminUsers', formData);
                    if (!payload) {
                        return;
                    }
                    if (payload.success) {
                        setUsers(payload.users || [], false);
                    }
                    if (window.showToast) {
                        window.showToast(payload.success ? 'success' : 'error', payload.message || 'Operation completed.');
                    }
                    return;
                }

                const checkbox = event.target.closest('.user-select');
                if (checkbox) {
                    const id = String(checkbox.value);
                    if (checkbox.checked) {
                        state.selectedIds.add(id);
                    } else {
                        state.selectedIds.delete(id);
                    }
                    rerender();
                }
            });

            selectAllUsers.addEventListener('change', () => {
                const pageUsers = getPagedUsers();
                if (selectAllUsers.checked) {
                    pageUsers.forEach((user) => state.selectedIds.add(String(user.userId)));
                } else {
                    pageUsers.forEach((user) => state.selectedIds.delete(String(user.userId)));
                }
                rerender();
            });

            bulkDeleteIconBtn.addEventListener('click', async () => {
                const ids = Array.from(state.selectedIds);
                if (!ids.length) {
                    if (window.showToast) {
                        window.showToast('info', 'No users selected.');
                    }
                    return;
                }

                const confirmed = await window.showConfirm('Delete users', 'Delete ' + ids.length + ' selected users?');
                if (!confirmed) {
                    return;
                }

                const formData = new URLSearchParams();
                formData.append('action', 'delete_multiple');
                formData.append('userIds', ids.join(','));

                const payload = await window.postFormData(contextPath + '/AdminUsers', formData);
                if (!payload) {
                    return;
                }

                if (payload.success) {
                    setUsers(payload.users || [], false);
                }
                if (window.showToast) {
                    window.showToast(payload.success ? 'success' : 'error', payload.message || 'Operation completed.');
                }
            });

            searchInput.addEventListener('input', () => {
                state.query = searchInput.value.trim();
                state.currentPage = 1;
                rerender();
            });

            roleFilter.addEventListener('change', () => {
                state.role = roleFilter.value;
                state.currentPage = 1;
                rerender();
            });

            statusFilter.addEventListener('change', () => {
                state.status = statusFilter.value;
                state.currentPage = 1;
                rerender();
            });

            rowsPerPage.addEventListener('change', () => {
                state.pageSize = Number(rowsPerPage.value || 20);
                state.currentPage = 1;
                rerender();
            });

            prevPageBtn.addEventListener('click', () => {
                state.currentPage = Math.max(1, state.currentPage - 1);
                rerender();
            });

            nextPageBtn.addEventListener('click', () => {
                const totalPages = Math.max(1, Math.ceil(state.filteredUsers.length / state.pageSize));
                state.currentPage = Math.min(totalPages, state.currentPage + 1);
                rerender();
            });

            fetchUsers(false);
        })();
    </script>
</body>
</html>
