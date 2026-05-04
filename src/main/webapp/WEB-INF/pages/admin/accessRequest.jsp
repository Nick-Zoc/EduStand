<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Access Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="accessRequests" scope="request" />
<c:set var="searchPlaceholder" value="Search requests, users, or departments..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Manage Requests</div>
                    <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Pending Requests</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Review new user requests and approve or reject access.</p>
                </div>
                <span class="edu-badge edu-badge-status edu-badge-status-pending" id="pendingSummaryCount">${pendingCount} Pending</span>
            </div>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom border-outline-variant gap-3">
                    <div class="d-flex flex-grow-1 gap-2 align-items-center">
                        <div class="position-relative w-100">
                            <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 0.85rem;"></i>
                            <input id="accessSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search by name or email" />
                        </div>
                        <select id="accessRoleFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by role">
                            <option value="ALL">All roles</option>
                            <option value="TEACHER">Teacher</option>
                            <option value="STUDENT">Student</option>
                        </select>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <h3 class="fs-5 fw-bold brand-headline text-on-surface m-0">Review Queue</h3>
                        <span class="small text-on-surface-variant">Newest requests appear first</span>
                    </div>
                </div>

                <div id="requestAlertContainer" aria-live="polite"></div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3 users-th-checkbox"><input type="checkbox" id="selectAllRequests" aria-label="Select all requests"></th>
                                <th class="px-3 px-md-4 py-3">SN</th>
                                <th class="px-3 px-md-4 py-3">APPLICANT</th>
                                <th class="px-3 px-md-4 py-3">EMAIL</th>
                                <th class="px-3 px-md-4 py-3">REQUESTED ROLE</th>
                                <th class="px-3 px-md-4 py-3">STATUS</th>
                                <th class="px-3 px-md-4 py-3 text-end">ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody id="requestsTableBody">
                            <c:forEach items="${pendingUsers}" var="user" varStatus="loop">
                                <tr>
                                    <td class="px-3 px-md-4 py-3"><input type="checkbox" class="request-select" value="${user.userId}"></td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">${loop.count}</td>
                                    <td class="px-3 px-md-4 py-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 32px; height: 32px; font-size: 11px;">${empty user.fullName ? 'U' : fn:toUpperCase(fn:substring(user.fullName, 0, 1))}</div>
                                            <span class="fw-semibold text-on-surface"><c:out value="${user.fullName}" /></span>
                                        </div>
                                    </td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant"><c:out value="${user.email}" /></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge ${user.role eq 'TEACHER' ? 'edu-badge-role-teacher' : 'edu-badge-role-student'}"><c:out value="${user.role}" /></span></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status edu-badge-status-pending">PENDING</span></td>
                                    <td class="px-3 px-md-4 py-3 text-end">
                                        <div class="d-inline-flex align-items-center gap-2">
                                            <button class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold text-white rounded-3 js-open-review" data-user-id="${user.userId}" data-full-name="<c:out value='${user.fullName}'/>" data-email="<c:out value='${user.email}'/>" data-role="${user.role}" data-reason="<c:out value='${user.requestReason}'/>" type="button" title="Review and approve"><i class="fa-solid fa-clipboard-check"></i><span>Review</span></button>
                                            <button class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold text-decoration-none js-request-action rounded-3" data-action="reject_request" data-user-id="${user.userId}" type="button" title="Decline request"><i class="fa-solid fa-xmark"></i><span>Decline</span></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pendingUsers}">
                                <tr>
                                    <td colspan="7" class="py-5 text-center text-on-surface-variant px-3 px-md-4">
                                        <div class="d-flex flex-column align-items-center gap-2">
                                            <i class="fa-regular fa-circle-check fs-3 text-primary"></i>
                                            <strong class="text-on-surface">No pending requests</strong>
                                            <span class="small">New requests will appear here automatically.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="users-pagination-bar px-3 px-md-4 py-3 border-top border-outline-variant d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                    <p id="requestsSummaryText" class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing ${fn:length(pendingUsers)} requests</p>
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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const accessSearchInput = document.getElementById('accessSearchInput');
            const accessRoleFilter = document.getElementById('accessRoleFilter');
            const contextPath = '${pageContext.request.contextPath}';
            const requestsTableBody = document.getElementById('requestsTableBody');
            const pendingSummaryCount = document.getElementById('pendingSummaryCount');
            const requestAlertContainer = document.getElementById('requestAlertContainer');
            const reviewModalElement = document.getElementById('reviewRequestModal');
            const reviewModal = bootstrap.Modal.getOrCreateInstance(reviewModalElement);
            const reviewSaveButton = document.getElementById('reviewSaveButton');
            const reviewRequestForm = document.getElementById('reviewRequestForm');
            const reviewUserId = document.getElementById('reviewUserId');
            const reviewFullName = document.getElementById('reviewFullName');
            const reviewEmail = document.getElementById('reviewEmail');
            const reviewRole = document.getElementById('reviewRole');
            const reviewReason = document.getElementById('reviewReason');
            const reviewStatus = document.getElementById('reviewStatus');
            const reviewPassword = document.getElementById('reviewPassword');
            const reviewInitial = document.getElementById('reviewInitial');
            const reviewSummaryName = document.getElementById('reviewSummaryName');
            const reviewSummaryEmail = document.getElementById('reviewSummaryEmail');
            const reviewSummaryRole = document.getElementById('reviewSummaryRole');
            const prevPageBtn = document.getElementById('prevPageBtn');
            const nextPageBtn = document.getElementById('nextPageBtn');
            const pageIndicator = document.getElementById('pageIndicator');
            const requestsSummaryText = document.getElementById('requestsSummaryText');

            let allRequests = [];
            const state = {
                filteredRequests: [],
                currentPage: 1,
                pageSize: 20
            };

            if (requestsTableBody) {

            // Client-side simple filtering for displayed rows
            function filterAccessRows() {
                const q = (accessSearchInput && accessSearchInput.value || '').toLowerCase();
                const role = (accessRoleFilter && accessRoleFilter.value) || 'ALL';
                state.filteredRequests = allRequests.filter((user) => {
                    const textMatch = [user.fullName, user.email].join(' ').toLowerCase().includes(q);
                    const roleMatch = (role === 'ALL') || (user.role === role);
                    return textMatch && roleMatch;
                });
                state.currentPage = 1;
                renderTable();
            }

            function renderTable() {
                if (state.filteredRequests.length === 0) {
                    requestsTableBody.innerHTML = '<tr><td colspan="7" class="py-5 text-center text-on-surface-variant px-3 px-md-4"><div class="d-flex flex-column align-items-center gap-2"><i class="fa-regular fa-circle-check fs-3 text-primary"></i><strong class="text-on-surface">No pending requests</strong><span class="small">New requests will appear here automatically.</span></div></td></tr>';
                    updatePagination();
                    return;
                }

                const start = (state.currentPage - 1) * state.pageSize;
                const end = start + state.pageSize;
                const pageRequests = state.filteredRequests.slice(start, end);

                requestsTableBody.innerHTML = pageRequests.map((user, idx) => {
                    const globalIdx = start + idx + 1;
                    return '<tr>'
                        + '<td class="px-3 px-md-4 py-3"><input type="checkbox" class="request-select" value="' + user.userId + '"></td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + globalIdx + '</td>'
                        + '<td class="px-3 px-md-4 py-3">'
                        + '<div class="d-flex align-items-center gap-2">'
                        + '<div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 32px; height: 32px; font-size: 11px;">' + escapeHtml(getInitial(user.fullName)) + '</div>'
                        + '<span class="fw-semibold text-on-surface">' + escapeHtml(user.fullName) + '</span>'
                        + '</div>'
                        + '</td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + escapeHtml(user.email) + '</td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge ' + (user.role === 'TEACHER' ? 'edu-badge-role-teacher' : 'edu-badge-role-student') + '">' + escapeHtml(user.role) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status edu-badge-status-pending">PENDING</span></td>'
                        + '<td class="px-3 px-md-4 py-3 text-end">'
                        + '<div class="d-inline-flex align-items-center gap-2">'
                        + '<button class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold text-white rounded-3 js-open-review" data-user-id="' + user.userId + '" data-full-name="' + escapeAttribute(user.fullName) + '" data-email="' + escapeAttribute(user.email) + '" data-role="' + escapeAttribute(user.role) + '" data-reason="' + escapeAttribute(user.requestReason) + '" type="button"><i class="fa-solid fa-clipboard-check"></i><span>Review</span></button>'
                        + '<button class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1 px-3 py-2 fw-semibold text-decoration-none js-request-action rounded-3" data-action="reject_request" data-user-id="' + user.userId + '" type="button"><i class="fa-solid fa-xmark"></i><span>Decline</span></button>'
                        + '</div>'
                        + '</td>'
                        + '</tr>';
                }).join('');

                updatePagination();
            }

            function updatePagination() {
                const totalPages = Math.ceil(state.filteredRequests.length / state.pageSize);
                pageIndicator.textContent = 'Page ' + state.currentPage + ' of ' + (totalPages || 1);
                requestsSummaryText.textContent = 'Showing ' + state.filteredRequests.length + ' requests';
                prevPageBtn.disabled = state.currentPage === 1;
                nextPageBtn.disabled = state.currentPage >= totalPages;
            }

            if (accessSearchInput) accessSearchInput.addEventListener('input', filterAccessRows);
            if (accessRoleFilter) accessRoleFilter.addEventListener('change', filterAccessRows);
            if (prevPageBtn) prevPageBtn.addEventListener('click', () => {
                if (state.currentPage > 1) {
                    state.currentPage--;
                    renderTable();
                }
            });
            if (nextPageBtn) nextPageBtn.addEventListener('click', () => {
                const totalPages = Math.ceil(state.filteredRequests.length / state.pageSize);
                if (state.currentPage < totalPages) {
                    state.currentPage++;
                    renderTable();
                }
            });
                requestsTableBody.addEventListener('click', async (event) => {
                    const reviewButton = event.target.closest('.js-open-review');
                    if (reviewButton) {
                        fillReviewModal(reviewButton.dataset);
                        reviewModal.show();
                        return;
                    }

                    const actionButton = event.target.closest('.js-request-action');
                    if (!actionButton) {
                        return;
                    }

                    const userId = actionButton.dataset.userId;
                    const action = actionButton.dataset.action;
                    setBusy(actionButton, true, action === 'reject_request' ? 'Declining...' : 'Updating...');

                    try {
                        const formData = new URLSearchParams();
                        formData.append('action', action);
                        formData.append('userId', userId);

                        const response = await fetch(contextPath + '/AdminAccessRequests', {
                            method: 'POST',
                            headers: {
                                'X-Requested-With': 'XMLHttpRequest'
                            },
                            body: formData
                        });

                        if (!response.ok) {
                            showAlert('danger', 'Failed to update request. Please retry.');
                            return;
                        }

                        const payload = await response.json();
                        showAlert(payload.success ? 'success' : 'danger', payload.message);
                        if (payload.success) {
                            renderRequests(payload.users || []);
                            pendingSummaryCount.textContent = payload.pendingCount + ' Pending';
                        }
                    } finally {
                        setBusy(actionButton, false);
                    }
                });
            }

            reviewRequestForm.addEventListener('submit', async (event) => {
                event.preventDefault();

                if (reviewStatus.value === 'ACTIVE' && !reviewPassword.value.trim()) {
                    showAlert('danger', 'Password is required when approving a request.');
                    reviewPassword.focus();
                    return;
                }

                setBusy(reviewSaveButton, true, 'Saving...');

                try {
                    const formData = new URLSearchParams(new FormData(event.target));
                    formData.append('action', 'review_request');

                    const response = await fetch(contextPath + '/AdminAccessRequests', {
                        method: 'POST',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                        },
                        body: formData
                    });

                    if (!response.ok) {
                        showAlert('danger', 'Failed to review request. Please retry.');
                        return;
                    }

                    const payload = await response.json();
                    showAlert(payload.success ? 'success' : 'danger', payload.message);
                    if (payload.success) {
                        renderRequests(payload.users || []);
                        pendingSummaryCount.textContent = payload.pendingCount + ' Pending';
                        reviewModal.hide();
                        reviewRequestForm.reset();
                        resetReviewSummary();
                    }
                } finally {
                    setBusy(reviewSaveButton, false);
                }
            });

            function renderRequests(users) {
                allRequests = users || [];
                filterAccessRows();
            }

            function fillReviewModal(dataset) {
                reviewUserId.value = dataset.userId || '';
                reviewFullName.value = dataset.fullName || '';
                reviewEmail.value = dataset.email || '';
                reviewRole.value = dataset.role || '';
                reviewReason.value = dataset.reason || '';
                reviewStatus.value = 'ACTIVE';
                reviewPassword.value = '';

                reviewInitial.textContent = getInitial(dataset.fullName);
                reviewSummaryName.textContent = dataset.fullName || 'Unknown user';
                reviewSummaryEmail.textContent = dataset.email || '';
                reviewSummaryRole.textContent = dataset.role || '-';
            }

            function resetReviewSummary() {
                reviewInitial.textContent = 'U';
                reviewSummaryName.textContent = 'No request selected';
                reviewSummaryEmail.textContent = 'Choose a pending request to review it';
                reviewSummaryRole.textContent = '-';
                reviewUserId.value = '';
                reviewFullName.value = '';
                reviewEmail.value = '';
                reviewRole.value = '';
                reviewReason.value = '';
                reviewStatus.value = 'ACTIVE';
                reviewPassword.value = '';
            }

            function setBusy(button, busy, busyLabel) {
                if (!button) {
                    return;
                }

                if (busy) {
                    if (!button.dataset.originalHtml) {
                        button.dataset.originalHtml = button.innerHTML;
                    }
                    button.disabled = true;
                    button.innerHTML = '<span class="spinner-border spinner-border-sm me-2" aria-hidden="true"></span>' + escapeHtml(busyLabel || 'Working...');
                    return;
                }

                if (button.dataset.originalHtml) {
                    button.innerHTML = button.dataset.originalHtml;
                    delete button.dataset.originalHtml;
                }
                button.disabled = false;
            }

            function getInitial(name) {
                if (!name || !name.trim()) {
                    return 'U';
                }
                return name.trim().charAt(0).toUpperCase();
            }

            function showAlert(type, message) {
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? '#10B981' : '#EF4444';
                Toastify({
                    text: message,
                    duration: 3000,
                    gravity: 'top',
                    position: 'right',
                    backgroundColor: bgColor,
                    className: 'rounded-2'
                }).showToast();
            }

            function escapeAttribute(value) {
                return escapeHtml(value);
            }

            function escapeHtml(value) {
                return String(value ?? '')
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            }

            resetReviewSummary();
        });
    </script>

    <div class="modal fade" id="reviewRequestModal" tabindex="-1" aria-labelledby="reviewRequestModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title brand-headline fw-bold" id="reviewRequestModalLabel">Review Access Request</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="reviewRequestForm" method="post">
                    <input type="hidden" id="reviewUserId" name="userId" />
                    <div class="modal-body p-4">
                        <div class="card-sleek p-3 mb-4 border-0 bg-surface-container-low">
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-primary-container text-primary" id="reviewInitial" style="width: 44px; height: 44px;">U</div>
                                <div class="flex-grow-1">
                                    <div class="fw-bold text-on-surface" id="reviewSummaryName">No request selected</div>
                                    <div class="small text-on-surface-variant" id="reviewSummaryEmail">Choose a pending request to review it</div>
                                </div>
                                <span class="edu-badge edu-badge-teachers" id="reviewSummaryRole">-</span>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label for="reviewFullName" class="form-label small fw-semibold text-on-surface-variant">Name</label>
                                <input type="text" class="form-control" id="reviewFullName" readonly>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="reviewEmail" class="form-label small fw-semibold text-on-surface-variant">Email</label>
                                <input type="email" class="form-control" id="reviewEmail" readonly>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="reviewRole" class="form-label small fw-semibold text-on-surface-variant">Requested Role</label>
                                <input type="text" class="form-control" id="reviewRole" readonly>
                            </div>
                            <div class="col-12">
                                <label for="reviewReason" class="form-label small fw-semibold text-on-surface-variant">Reason for Access</label>
                                <textarea class="form-control request-textarea" id="reviewReason" rows="4" readonly></textarea>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="reviewStatus" class="form-label small fw-semibold text-on-surface-variant">Decision <span class="text-danger">*</span></label>
                                <select class="form-select" id="reviewStatus" name="status" required>
                                    <option value="ACTIVE">Approve</option>
                                    <option value="INACTIVE">Decline</option>
                                    <option value="PENDING">Keep Pending</option>
                                </select>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="reviewPassword" class="form-label small fw-semibold text-on-surface-variant">Set Password for Approved Account <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="reviewPassword" name="password" minlength="8" placeholder="Required when approving">
                                <div class="form-text">Use a real login password if you approve this request.</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-primary-edu fw-semibold px-3" id="reviewSaveButton">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Save Review
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>