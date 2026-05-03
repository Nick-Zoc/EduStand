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
<c:set var="searchPlaceholder" value="Search users, roles, or status..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 2.5rem;">
            <section class="position-relative overflow-hidden rounded-4 p-4 p-md-5 text-white shadow-sm" style="background: linear-gradient(135deg, var(--primary) 0%, rgba(0, 86, 179, 1) 100%);">
                <div class="position-relative z-1" style="max-width: 650px;">
                    <h2 class="fs-1 fw-bold mb-3 brand-headline">User management</h2>
                    <p class="fs-5 opacity-75 mb-0" style="line-height: 1.6;">Review student and teacher accounts, approve access, and keep the platform organised.</p>
                </div>
            </section>

            <section class="row g-4">
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 text-primary bg-primary-container d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                                <i class="fa-solid fa-chalkboard-user fs-4"></i>
                            </div>
                            <span class="badge fw-bold text-primary bg-primary-container p-2 rounded-2" style="font-size: 11px;">Teachers</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0" id="teacherCountValue">${teacherCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Total active educators</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #e0f2fe; color: #0284c7; width: 44px; height: 44px;">
                                <i class="fa-solid fa-user-graduate fs-4"></i>
                            </div>
                            <span class="badge fw-bold p-2 rounded-2" style="background-color: #e0f2fe; color: #0284c7; font-size: 11px;">Students</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0" id="studentCountValue">${studentCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Enrolled learners</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="card-sleek p-4 h-100 d-flex flex-column justify-content-center">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="p-2 rounded-3 d-flex align-items-center justify-content-center" style="background-color: #fef3c7; color: #d97706; width: 44px; height: 44px;">
                                <i class="fa-solid fa-user-clock fs-4"></i>
                            </div>
                            <span class="badge fw-bold p-2 rounded-2" style="background-color: #fef3c7; color: #d97706; font-size: 11px;">Pending</span>
                        </div>
                        <h3 class="brand-headline fs-2 fw-bold text-on-surface m-0" id="pendingCountValue">${pendingCount}</h3>
                        <p class="small text-on-surface-variant m-0 mt-1">Awaiting profile approval</p>
                    </div>
                </div>
            </section>

            <section class="card-curator overflow-hidden">
                <div class="px-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant bg-surface gap-3">
                    <h2 class="fs-5 fw-bold brand-headline text-on-surface m-0">Manage Users</h2>
                    <button class="btn btn-primary-edu d-flex align-items-center justify-content-center gap-2 px-4 py-2 fw-bold small text-white border-0 shadow-sm" style="font-size: 13px;" type="button" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fa-solid fa-user-plus fs-6"></i>
                        Add New User
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
                        <tbody class="border-top-0" style="font-family: 'Inter', sans-serif;" id="usersTableBody">
                            <c:forEach items="${users}" var="user">
                                <tr class="transition">
                                    <td class="px-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">${empty user.fullName ? 'U' : fn:toUpperCase(fn:substring(user.fullName, 0, 1))}</div>
                                            <div>
                                                <p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;"><c:out value="${user.fullName}" /></p>
                                                <p class="m-0 text-on-surface-variant" style="font-size: 12px;"><c:out value="${user.email}" /></p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-${user.userId}</td>
                                    <td class="px-4 py-3">
                                        <span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill ${user.role eq 'TEACHER' ? 'bg-primary-container text-primary' : 'bg-surface-container-highest text-on-surface-variant'}" style="font-size: 10px;"><c:out value="${user.role}" /></span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="status-dot" style="background-color: ${user.status eq 'ACTIVE' ? '#198754' : user.status eq 'PENDING' ? '#f59e0b' : '#dc3545'};"></span>
                                            <span class="fw-medium text-on-surface" style="font-size: 13px;"><c:out value="${user.status}" /></span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-end">
                                        <div class="d-flex justify-content-end gap-2">
                                            <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3 js-edit-user"
                                                data-user-id="${user.userId}"
                                                data-full-name="<c:out value='${user.fullName}'/>"
                                                data-email="<c:out value='${user.email}'/>"
                                                data-role="${user.role}"
                                                data-status="${user.status}"
                                                type="button">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-danger rounded-3 js-delete-user"
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

                <div class="px-4 py-3 border-top border-outline-variant bg-surface d-flex justify-content-between align-items-center">
                    <p class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;" id="usersSummaryText">Showing ${totalUsers} users</p>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">Previous</button>
                        <button class="btn btn-primary btn-sm px-3 py-1 rounded-pill fw-medium border-0" style="font-size: 13px;">1</button>
                        <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">2</button>
                        <button class="btn btn-outline-secondary btn-sm px-3 py-1 rounded-pill" style="font-size: 13px;">Next</button>
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
        const contextPath = '${pageContext.request.contextPath}';
        const usersTableBody = document.getElementById('usersTableBody');
        const usersAlertContainer = document.getElementById('usersAlertContainer');
        const teacherCountValue = document.getElementById('teacherCountValue');
        const studentCountValue = document.getElementById('studentCountValue');
        const pendingCountValue = document.getElementById('pendingCountValue');
        const usersSummaryText = document.getElementById('usersSummaryText');

        const addUserModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('addUserModal'));
        const editUserModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('editUserModal'));

        document.getElementById('addUserForm').addEventListener('submit', async (event) => {
            event.preventDefault();
            const payload = await submitForm(event.target);
            if (!payload) {
                return;
            }
            applyPayload(payload);
            if (payload.success) {
                event.target.reset();
                addUserModal.hide();
            }
        });

        document.getElementById('editUserForm').addEventListener('submit', async (event) => {
            event.preventDefault();
            const payload = await submitForm(event.target);
            if (!payload) {
                return;
            }
            applyPayload(payload);
            if (payload.success) {
                event.target.reset();
                editUserModal.hide();
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
            if (!deleteButton) {
                return;
            }

            const fullName = deleteButton.dataset.fullName;
            const userId = deleteButton.dataset.userId;
            if (!confirm('Delete ' + fullName + '? This action cannot be undone.')) {
                return;
            }

            const formData = new URLSearchParams();
            formData.append('action', 'delete_user');
            formData.append('userId', userId);

            const payload = await postFormData(formData);
            if (!payload) {
                return;
            }
            applyPayload(payload);
        });

        async function submitForm(form) {
            const formData = new FormData(form);
            return postFormData(new URLSearchParams(formData));
        }

        async function postFormData(formData) {
            try {
                const response = await fetch(contextPath + '/AdminUsers', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                    },
                    body: formData
                });

                if (!response.ok) {
                    showAlert('danger', 'Request failed. Please try again.');
                    return null;
                }

                return await response.json();
            } catch (error) {
                showAlert('danger', 'Network error. Please check your connection and retry.');
                return null;
            }
        }

        function applyPayload(payload) {
            showAlert(payload.success ? 'success' : 'danger', payload.message);
            if (!payload.users) {
                return;
            }
            renderUsers(payload.users);
            teacherCountValue.textContent = payload.teacherCount;
            studentCountValue.textContent = payload.studentCount;
            pendingCountValue.textContent = payload.pendingCount;
            usersSummaryText.textContent = 'Showing ' + payload.totalUsers + ' users';
        }

        function renderUsers(users) {
            usersTableBody.innerHTML = users.map((user) => {
                const initials = getInitials(user.fullName);
                const roleClass = user.role === 'TEACHER' ? 'bg-primary-container text-primary' : 'bg-surface-container-highest text-on-surface-variant';
                const statusColor = user.status === 'ACTIVE' ? '#198754' : (user.status === 'PENDING' ? '#f59e0b' : '#dc3545');
                return '<tr class="transition">'
                    + '<td class="px-4 py-3">'
                    + '<div class="d-flex align-items-center gap-3">'
                    + '<div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 36px; height: 36px; font-size: 12px;">' + escapeHtml(initials) + '</div>'
                    + '<div>'
                    + '<p class="m-0 fw-semibold text-on-surface" style="font-size: 14px;">' + escapeHtml(user.fullName) + '</p>'
                    + '<p class="m-0 text-on-surface-variant" style="font-size: 12px;">' + escapeHtml(user.email) + '</p>'
                    + '</div>'
                    + '</div>'
                    + '</td>'
                    + '<td class="px-4 py-3 small text-on-surface-variant" style="font-family: monospace;">#EDU-' + user.userId + '</td>'
                    + '<td class="px-4 py-3"><span class="badge fw-bold text-uppercase px-2 py-1 rounded-pill ' + roleClass + '" style="font-size: 10px;">' + escapeHtml(user.role) + '</span></td>'
                    + '<td class="px-4 py-3"><div class="d-flex align-items-center gap-2"><span class="status-dot" style="background-color: ' + statusColor + ';"></span><span class="fw-medium text-on-surface" style="font-size: 13px;">' + escapeHtml(user.status) + '</span></div></td>'
                    + '<td class="px-4 py-3 text-end">'
                    + '<div class="d-flex justify-content-end gap-2">'
                    + '<button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-on-surface-variant rounded-3 js-edit-user"'
                    + ' data-user-id="' + user.userId + '"'
                    + ' data-full-name="' + escapeAttribute(user.fullName) + '"'
                    + ' data-email="' + escapeAttribute(user.email) + '"'
                    + ' data-role="' + escapeAttribute(user.role) + '"'
                    + ' data-status="' + escapeAttribute(user.status) + '"'
                    + ' type="button">'
                    + '<i class="fa-solid fa-pen"></i>'
                    + '</button>'
                    + '<button class="btn btn-sm btn-light p-2 d-flex align-items-center justify-content-center border-0 text-danger rounded-3 js-delete-user"'
                    + ' data-user-id="' + user.userId + '"'
                    + ' data-full-name="' + escapeAttribute(user.fullName) + '"'
                    + ' type="button">'
                    + '<i class="fa-solid fa-trash"></i>'
                    + '</button>'
                    + '</div>'
                    + '</td>'
                    + '</tr>';
            }).join('');
        }

        function getInitials(name) {
            if (!name || !name.trim()) {
                return 'U';
            }
            const parts = name.trim().split(/\s+/);
            if (parts.length === 1) {
                return parts[0].charAt(0).toUpperCase();
            }
            return (parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
        }

        function showAlert(type, message) {
            usersAlertContainer.innerHTML = '<div class="alert alert-' + type + ' border-0 rounded-0 m-0" role="alert">'
                + escapeHtml(message)
                + '</div>';
        }

        function escapeHtml(value) {
            return String(value ?? '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function escapeAttribute(value) {
            return escapeHtml(value);
        }
    </script>
</body>
</html>
