<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Contact Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="contactRequests" scope="request" />
<c:set var="searchPlaceholder" value="Search contact requests..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Manage Contact Requests</div>
                    <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Contact Inbox</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Review incoming contact messages and mark as read or resolved.</p>
                </div>
                <span class="edu-badge edu-badge-status edu-badge-status-pending" id="unreadCountBadge">${unreadCount} Unread</span>
            </div>

            <div id="requestAlertContainer" aria-live="polite"></div>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-xl-row align-items-xl-center gap-2 gap-xl-3 border-bottom border-outline-variant">
                    <div class="position-relative flex-grow-1 users-search-wrap">
                        <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 0.85rem;"></i>
                        <input id="requestSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search by name, email, subject" />
                    </div>
                    <select id="readStatusFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by read status">
                        <option value="ALL">All read status</option>
                        <option value="UNREAD">Unread</option>
                        <option value="READ">Read</option>
                    </select>
                    <select id="requestStatusFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by request status">
                        <option value="ALL">All status</option>
                        <option value="PENDING">Pending</option>
                        <option value="FIXED">Fixed</option>
                    </select>
                    <select id="rowsPerPage" class="form-select users-select-filter users-compact-filter" aria-label="Rows per page">
                        <option value="10">10 rows</option>
                        <option value="15">15 rows</option>
                        <option value="20" selected>20 rows</option>
                        <option value="25">25 rows</option>
                    </select>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3 users-th-checkbox"><input type="checkbox" id="selectAllRequests" aria-label="Select all requests"></th>
                                <th class="px-3 px-md-4 py-3">SN</th>
                                <th class="px-3 px-md-4 py-3">SENDER</th>
                                <th class="px-3 px-md-4 py-3">SUBJECT</th>
                                <th class="px-3 px-md-4 py-3">READ</th>
                                <th class="px-3 px-md-4 py-3">STATUS</th>
                                <th class="px-3 px-md-4 py-3 text-end">ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody id="contactRequestsTableBody">
                            <c:forEach items="${requests}" var="request" varStatus="loop">
                                <tr>
                                    <td class="px-3 px-md-4 py-3"><input type="checkbox" class="request-select" value="${request.requestId}"></td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">${loop.count}</td>
                                    <td class="px-3 px-md-4 py-3 fw-semibold text-on-surface"><c:out value="${request.fullName}" /></td>
                                    <td class="px-3 px-md-4 py-3"><c:out value="${request.subject}" /></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ${request.readStatus eq 'READ' ? 'edu-badge-status-active' : 'edu-badge-status-pending'}"><c:out value="${request.readStatus}" /></span></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ${request.requestStatus eq 'FIXED' ? 'edu-badge-status-active' : 'edu-badge-status-pending'}"><c:out value="${request.requestStatus}" /></span></td>
                                    <td class="px-3 px-md-4 py-3 text-end">
                                        <div class="d-inline-flex align-items-center gap-2">
                                            <button type="button" class="btn btn-sm btn-light border-0 text-primary js-view-message" data-request-id="${request.requestId}" data-full-name="<c:out value='${request.fullName}'/>" data-email="<c:out value='${request.email}'/>" data-subject="<c:out value='${request.subject}'/>" data-message="<c:out value='${request.message}'/>" title="View message" aria-label="View message"><i class="fa-solid fa-envelope-open"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-secondary js-request-action" data-action="mark_read" data-request-id="${request.requestId}" title="Mark as read" aria-label="Mark as read"><i class="fa-solid fa-check"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-success js-request-action" data-action="mark_fixed" data-request-id="${request.requestId}" title="Mark as fixed" aria-label="Mark as fixed"><i class="fa-solid fa-circle-check"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-danger js-delete-request" data-request-id="${request.requestId}" title="Delete request" aria-label="Delete request"><i class="fa-solid fa-trash"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="users-pagination-bar px-3 px-md-4 py-3 border-top border-outline-variant d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                    <p id="requestsSummaryText" class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing ${fn:length(requests)} requests</p>
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

    <div class="modal fade" id="messageDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title brand-headline fw-bold">Message Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold text-on-surface-variant">From</label>
                            <input class="form-control" id="modalFullName" readonly>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label small fw-semibold text-on-surface-variant">Email</label>
                            <input class="form-control" id="modalEmail" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold text-on-surface-variant">Subject</label>
                            <input class="form-control" id="modalSubject" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold text-on-surface-variant">Message</label>
                            <textarea class="form-control" rows="6" id="modalMessage" readonly></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top border-outline-variant px-4 py-3 d-flex justify-content-between align-items-center">
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary" id="modalMarkUnread">Mark Unread</button>
                        <button type="button" class="btn btn-sm btn-secondary" id="modalMarkRead">Mark Read</button>
                        <button type="button" class="btn btn-sm btn-outline-warning" id="modalMarkPending">Mark Pending</button>
                        <button type="button" class="btn btn-sm btn-warning" id="modalMarkFixed">Mark Fixed</button>
                    </div>
                    <div>
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <script>
        (() => {
            const contextPath = '${pageContext.request.contextPath}';
            const tableBody = document.getElementById('contactRequestsTableBody');
            const searchInput = document.getElementById('requestSearchInput');
            const alertContainer = document.getElementById('requestAlertContainer');
            const rowsPerPageSelect = document.getElementById('rowsPerPage');
            const readStatusFilter = document.getElementById('readStatusFilter');
            const requestStatusFilter = document.getElementById('requestStatusFilter');
            const unreadCountBadge = document.getElementById('unreadCountBadge');
            const selectAllRequests = document.getElementById('selectAllRequests');
            const prevPageBtn = document.getElementById('prevPageBtn');
            const nextPageBtn = document.getElementById('nextPageBtn');
            const pageIndicator = document.getElementById('pageIndicator');
            const requestsSummaryText = document.getElementById('requestsSummaryText');
            const messageDetailModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('messageDetailModal'));
            const modalFullName = document.getElementById('modalFullName');
            const modalEmail = document.getElementById('modalEmail');
            const modalSubject = document.getElementById('modalSubject');
            const modalMessage = document.getElementById('modalMessage');

            let allRequests = [];
            const state = {
                filteredRequests: [],
                selectedIds: new Set(),
                currentPage: 1,
                pageSize: parseInt(rowsPerPageSelect.value || 20)
            };

            function escapeHtml(value) {
                return String(value ?? '')
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            }

            function filter() {
                const query = (searchInput.value || '').toLowerCase();
                const readFilter = (readStatusFilter && readStatusFilter.value) ? readStatusFilter.value : 'ALL';
                const reqFilter = (requestStatusFilter && requestStatusFilter.value) ? requestStatusFilter.value : 'ALL';
                state.filteredRequests = allRequests.filter((item) => {
                    const textMatch = [item.fullName, item.email, item.subject].join(' ').toLowerCase().includes(query);
                    const readMatch = (readFilter === 'ALL') || (item.readStatus === readFilter);
                    const reqMatch = (reqFilter === 'ALL') || (item.requestStatus === reqFilter);
                    return textMatch && readMatch && reqMatch;
                });
                state.currentPage = 1;
                renderTable();
            }

            function renderTable() {
                if (state.filteredRequests.length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="7" class="py-5 text-center text-on-surface-variant">No contact requests found.</td></tr>';
                    updatePagination();
                    return;
                }

                const start = (state.currentPage - 1) * state.pageSize;
                const end = start + state.pageSize;
                const pageRequests = state.filteredRequests.slice(start, end);

                tableBody.innerHTML = pageRequests.map((item, idx) => {
                    const readBadgeClass = item.readStatus === 'READ' ? 'edu-badge-status-active' : 'edu-badge-status-pending';
                    const statusBadgeClass = item.requestStatus === 'FIXED' ? 'edu-badge-status-active' : 'edu-badge-status-pending';
                    const globalIdx = start + idx + 1;

                    return '<tr>'
                        + '<td class="px-3 px-md-4 py-3"><input type="checkbox" class="request-select" value="' + item.requestId + '"></td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + globalIdx + '</td>'
                        + '<td class="px-3 px-md-4 py-3 fw-semibold text-on-surface">' + escapeHtml(item.fullName) + '</td>'
                        + '<td class="px-3 px-md-4 py-3">' + escapeHtml(item.subject) + '</td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ' + readBadgeClass + '">' + escapeHtml(item.readStatus) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ' + statusBadgeClass + '">' + escapeHtml(item.requestStatus) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3 text-end"><div class="d-inline-flex align-items-center gap-2">'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-primary js-view-message" data-request-id="' + item.requestId + '" data-full-name="' + escapeHtml(item.fullName) + '" data-email="' + escapeHtml(item.email) + '" data-subject="' + escapeHtml(item.subject) + '" data-message="' + escapeHtml(item.message) + '" title="View message"><i class="fa-solid fa-envelope-open"></i></button>'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-secondary js-request-action" data-action="mark_read" data-request-id="' + item.requestId + '" title="Mark as read"><i class="fa-solid fa-check"></i></button>'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-success js-request-action" data-action="mark_fixed" data-request-id="' + item.requestId + '" title="Mark as fixed"><i class="fa-solid fa-circle-check"></i></button>'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-danger js-delete-request" data-request-id="' + item.requestId + '" title="Delete request"><i class="fa-solid fa-trash"></i></button>'
                        + '</div></td>'
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

            async function performAction(action, requestId) {
                const payload = new URLSearchParams();
                payload.append('action', action);
                payload.append('requestId', requestId);

                const response = await fetch(contextPath + '/AdminContactRequests', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: payload
                });

                if (!response.ok) {
                    throw new Error('Failed to update request.');
                }

                const data = await response.json();
                if (!data.success) {
                    throw new Error(data.message || 'Failed to update.');
                }

                allRequests = data.requests || [];
                unreadCountBadge.textContent = data.unreadCount + ' Unread';
                filter();
                showAlert('success', data.message || 'Updated');
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

            tableBody.addEventListener('click', async (event) => {
                const viewButton = event.target.closest('.js-view-message');
                    if (viewButton) {
                        modalFullName.value = viewButton.dataset.fullName;
                        modalEmail.value = viewButton.dataset.email;
                        modalSubject.value = viewButton.dataset.subject;
                        modalMessage.value = viewButton.dataset.message;
                        // store the id for modal actions
                        messageDetailModal._requestId = viewButton.dataset.requestId || '';
                        messageDetailModal.show();
                        return;
                    }

                const actionButton = event.target.closest('.js-request-action');
                if (actionButton) {
                    try {
                        await performAction(actionButton.dataset.action, actionButton.dataset.requestId);
                    } catch (e) {
                        showAlert('danger', e.message);
                    }
                    return;
                }

                const deleteButton = event.target.closest('.js-delete-request');
                if (deleteButton) {
                    Swal.fire({
                        title: 'Delete Request?',
                        text: 'This action cannot be undone.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Delete',
                        confirmButtonColor: '#EF4444',
                        cancelButtonText: 'Cancel',
                        background: '#F8F9FA'
                    }).then(async (result) => {
                        if (result.isConfirmed) {
                            try {
                                await performAction('delete_request', deleteButton.dataset.requestId);
                            } catch (e) {
                                showAlert('danger', e.message);
                            }
                        }
                    });
                }
            });

            searchInput.addEventListener('input', filter);
            rowsPerPageSelect.addEventListener('change', () => {
                state.pageSize = parseInt(rowsPerPageSelect.value);
                state.currentPage = 1;
                renderTable();
            });

            prevPageBtn.addEventListener('click', () => {
                if (state.currentPage > 1) {
                    state.currentPage--;
                    renderTable();
                }
            });

            nextPageBtn.addEventListener('click', () => {
                const totalPages = Math.ceil(state.filteredRequests.length / state.pageSize);
                if (state.currentPage < totalPages) {
                    state.currentPage++;
                    renderTable();
                }
            });

            selectAllRequests.addEventListener('change', (e) => {
                const checkboxes = document.querySelectorAll('.request-select');
                checkboxes.forEach((cb) => {
                    cb.checked = e.target.checked;
                    if (e.target.checked) {
                        state.selectedIds.add(parseInt(cb.value));
                    } else {
                        state.selectedIds.delete(parseInt(cb.value));
                    }
                });
            });

            tableBody.addEventListener('change', (e) => {
                if (e.target.classList.contains('request-select')) {
                    if (e.target.checked) {
                        state.selectedIds.add(parseInt(e.target.value));
                    } else {
                        state.selectedIds.delete(parseInt(e.target.value));
                    }
                }
            });

            (async function bootstrapData() {
                try {
                    const response = await fetch(contextPath + '/AdminContactRequests?action=data', {
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    });
                    if (!response.ok) {
                        throw new Error('Failed to load contact requests.');
                    }
                    const data = await response.json();
                    allRequests = data.requests || [];
                    unreadCountBadge.textContent = data.unreadCount + ' Unread';
                    filter();
                } catch (e) {
                    showAlert('danger', e.message);
                }
            })();

            // Modal action buttons
            const modalMarkRead = document.getElementById('modalMarkRead');
            const modalMarkUnread = document.getElementById('modalMarkUnread');
            const modalMarkFixed = document.getElementById('modalMarkFixed');
            const modalMarkPending = document.getElementById('modalMarkPending');

            async function modalAction(action) {
                const rid = messageDetailModal._requestId;
                if (!rid) return;
                try {
                    await performAction(action, rid);
                    messageDetailModal.hide();
                } catch (e) {
                    showAlert('danger', e.message);
                }
            }

            if (modalMarkRead) modalMarkRead.addEventListener('click', () => modalAction('mark_read'));
            if (modalMarkUnread) modalMarkUnread.addEventListener('click', () => modalAction('mark_unread'));
            if (modalMarkFixed) modalMarkFixed.addEventListener('click', () => modalAction('mark_fixed'));
            if (modalMarkPending) modalMarkPending.addEventListener('click', () => modalAction('mark_pending'));

            // filters change
            if (readStatusFilter) readStatusFilter.addEventListener('change', filter);
            if (requestStatusFilter) requestStatusFilter.addEventListener('change', filter);
        })();
    </script>
</body>
</html>
