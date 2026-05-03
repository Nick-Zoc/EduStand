<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Contact Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="contactRequests" scope="request" />
<c:set var="searchPlaceholder" value="Search contact requests..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="p-4 p-md-5 mx-auto w-100 d-flex flex-column" style="max-width: 1280px; gap: 1.5rem;">
            <section class="page-header-sleek p-4 p-md-4 d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-2" style="letter-spacing: 0.08em;">Manage Contact Requests</div>
                    <h2 class="fs-1 fw-bold mb-2 brand-headline text-on-surface">Contact Inbox</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 42rem; line-height: 1.6;">Review incoming messages, add response notes, and mark requests as fixed or pending.</p>
                </div>
                <span class="edu-badge edu-badge-status edu-badge-status-pending" id="unreadCountBadge">${unreadCount} Unread</span>
            </section>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-xl-row align-items-xl-center gap-2 gap-xl-3 border-bottom border-outline-variant">
                    <div class="position-relative flex-grow-1 users-search-wrap">
                        <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 0.85rem;"></i>
                        <input id="requestSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search by name, email, subject" />
                    </div>
                </div>

                <div id="requestAlertContainer" aria-live="polite"></div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 px-md-4 py-3">ID</th>
                                <th class="px-3 px-md-4 py-3">SENDER</th>
                                <th class="px-3 px-md-4 py-3">SUBJECT</th>
                                <th class="px-3 px-md-4 py-3">READ</th>
                                <th class="px-3 px-md-4 py-3">STATUS</th>
                                <th class="px-3 px-md-4 py-3">EMAIL</th>
                                <th class="px-3 px-md-4 py-3 text-end">ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody id="contactRequestsTableBody">
                            <c:forEach items="${requests}" var="request">
                                <tr>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">#${request.requestId}</td>
                                    <td class="px-3 px-md-4 py-3 fw-semibold text-on-surface"><c:out value="${request.fullName}" /></td>
                                    <td class="px-3 px-md-4 py-3"><c:out value="${request.subject}" /></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ${request.readStatus eq 'READ' ? 'edu-badge-status-active' : 'edu-badge-status-pending'}"><c:out value="${request.readStatus}" /></span></td>
                                    <td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ${request.requestStatus eq 'FIXED' ? 'edu-badge-status-active' : 'edu-badge-status-pending'}"><c:out value="${request.requestStatus}" /></span></td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant"><c:out value="${request.email}" /></td>
                                    <td class="px-3 px-md-4 py-3 text-end">
                                        <div class="d-inline-flex align-items-center gap-2">
                                            <button type="button" class="btn btn-sm btn-light border-0 text-primary js-open-request" data-request-id="${request.requestId}" data-full-name="<c:out value='${request.fullName}'/>" data-email="<c:out value='${request.email}'/>" data-subject="<c:out value='${request.subject}'/>" data-message="<c:out value='${request.message}'/>" data-read-status="${request.readStatus}" data-request-status="${request.requestStatus}" data-admin-response="<c:out value='${request.adminResponse}'/>"><i class="fa-solid fa-eye"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-success js-request-action" data-action="mark_fixed" data-request-id="${request.requestId}"><i class="fa-solid fa-circle-check"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-warning js-request-action" data-action="mark_pending" data-request-id="${request.requestId}"><i class="fa-solid fa-hourglass-half"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <div class="modal fade" id="requestDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title brand-headline fw-bold">Contact Request Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="requestActionForm">
                    <div class="modal-body p-4">
                        <input type="hidden" id="detailRequestId" />
                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-on-surface-variant">Name</label>
                                <input class="form-control" id="detailName" readonly>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label small fw-semibold text-on-surface-variant">Email</label>
                                <input class="form-control" id="detailEmail" readonly>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-on-surface-variant">Subject</label>
                                <input class="form-control" id="detailSubject" readonly>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-on-surface-variant">Message</label>
                                <textarea class="form-control" rows="4" id="detailMessage" readonly></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-on-surface-variant">Admin Note / Reply</label>
                                <textarea class="form-control" rows="3" id="detailAdminResponse" placeholder="Write internal note or response summary"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3 d-flex justify-content-between">
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary js-detail-action" data-action="mark_unread">Mark Unread</button>
                            <button type="button" class="btn btn-outline-primary js-detail-action" data-action="mark_read">Mark Read</button>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-warning js-detail-action" data-action="mark_pending">Keep Pending</button>
                            <button type="button" class="btn btn-success js-detail-action" data-action="mark_fixed">Mark Fixed & Notify</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            const contextPath = '${pageContext.request.contextPath}';
            const tableBody = document.getElementById('contactRequestsTableBody');
            const searchInput = document.getElementById('requestSearchInput');
            const alertContainer = document.getElementById('requestAlertContainer');
            const unreadCountBadge = document.getElementById('unreadCountBadge');
            const requestDetailModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('requestDetailModal'));
            const detailRequestId = document.getElementById('detailRequestId');
            const detailName = document.getElementById('detailName');
            const detailEmail = document.getElementById('detailEmail');
            const detailSubject = document.getElementById('detailSubject');
            const detailMessage = document.getElementById('detailMessage');
            const detailAdminResponse = document.getElementById('detailAdminResponse');

            let allRequests = [];

            function roleClass(value) {
                return value === 'READ' ? 'edu-badge-status-active' : 'edu-badge-status-pending';
            }

            function statusClass(value) {
                return value === 'FIXED' ? 'edu-badge-status-active' : 'edu-badge-status-pending';
            }

            function render(data) {
                const query = (searchInput.value || '').toLowerCase();
                const filtered = data.filter((item) => {
                    return [item.fullName, item.email, item.subject, item.message].join(' ').toLowerCase().includes(query);
                });

                if (!filtered.length) {
                    tableBody.innerHTML = '<tr><td colspan="7" class="py-5 text-center text-on-surface-variant">No contact requests found.</td></tr>';
                    return;
                }

                tableBody.innerHTML = filtered.map((item) => {
                    return '<tr>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">#' + item.requestId + '</td>'
                        + '<td class="px-3 px-md-4 py-3 fw-semibold text-on-surface">' + escapeHtml(item.fullName) + '</td>'
                        + '<td class="px-3 px-md-4 py-3">' + escapeHtml(item.subject) + '</td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ' + roleClass(item.readStatus) + '">' + escapeHtml(item.readStatus) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3"><span class="edu-badge edu-badge-status ' + statusClass(item.requestStatus) + '">' + escapeHtml(item.requestStatus) + '</span></td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + escapeHtml(item.email) + '</td>'
                        + '<td class="px-3 px-md-4 py-3 text-end"><div class="d-inline-flex align-items-center gap-2">'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-primary js-open-request" data-request-id="' + item.requestId + '" data-full-name="' + escapeAttribute(item.fullName) + '" data-email="' + escapeAttribute(item.email) + '" data-subject="' + escapeAttribute(item.subject) + '" data-message="' + escapeAttribute(item.message) + '" data-admin-response="' + escapeAttribute(item.adminResponse || '') + '"><i class="fa-solid fa-eye"></i></button>'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-success js-request-action" data-action="mark_fixed" data-request-id="' + item.requestId + '"><i class="fa-solid fa-circle-check"></i></button>'
                        + '<button type="button" class="btn btn-sm btn-light border-0 text-warning js-request-action" data-action="mark_pending" data-request-id="' + item.requestId + '"><i class="fa-solid fa-hourglass-half"></i></button>'
                        + '</div></td>'
                        + '</tr>';
                }).join('');
            }

            async function performAction(action, requestId, adminResponse) {
                const payload = new URLSearchParams();
                payload.append('action', action);
                payload.append('requestId', requestId);
                if (adminResponse != null) {
                    payload.append('adminResponse', adminResponse);
                }

                const response = await fetch(contextPath + '/AdminContactRequests', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: payload
                });

                if (!response.ok) {
                    throw new Error('Request update failed.');
                }

                const data = await response.json();
                if (!data.success) {
                    throw new Error(data.message || 'Failed to update.');
                }

                allRequests = data.requests || [];
                unreadCountBadge.textContent = data.unreadCount + ' Unread';
                render(allRequests);
                showAlert('success', data.message || 'Updated');
            }

            function showAlert(type, message) {
                alertContainer.innerHTML = '<div class="alert alert-' + type + ' border-0 rounded-0 m-0" role="alert">' + escapeHtml(message) + '</div>';
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

            tableBody.addEventListener('click', async (event) => {
                const openButton = event.target.closest('.js-open-request');
                if (openButton) {
                    detailRequestId.value = openButton.dataset.requestId;
                    detailName.value = openButton.dataset.fullName;
                    detailEmail.value = openButton.dataset.email;
                    detailSubject.value = openButton.dataset.subject;
                    detailMessage.value = openButton.dataset.message;
                    detailAdminResponse.value = openButton.dataset.adminResponse || '';
                    requestDetailModal.show();
                    return;
                }

                const actionButton = event.target.closest('.js-request-action');
                if (actionButton) {
                    try {
                        await performAction(actionButton.dataset.action, actionButton.dataset.requestId, '');
                    } catch (e) {
                        showAlert('danger', e.message);
                    }
                }
            });

            document.querySelectorAll('.js-detail-action').forEach((button) => {
                button.addEventListener('click', async () => {
                    try {
                        await performAction(button.dataset.action, detailRequestId.value, detailAdminResponse.value);
                        requestDetailModal.hide();
                    } catch (e) {
                        showAlert('danger', e.message);
                    }
                });
            });

            searchInput.addEventListener('input', () => render(allRequests));

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
                    render(allRequests);
                } catch (e) {
                    showAlert('danger', e.message);
                }
            })();
        })();
    </script>
</body>
</html>
