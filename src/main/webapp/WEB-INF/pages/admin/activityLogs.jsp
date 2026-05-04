<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Activity Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="activityLogs" scope="request" />
<c:set var="searchPlaceholder" value="Search activity logs..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">System Monitoring</div>
                    <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Activity Logs</h2>
                    <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Monitor backend user actions securely.</p>
                </div>
                <span class="edu-badge edu-badge-status edu-badge-status-active" id="totalLogsBadge">${totalLogs} Total</span>
            </div>

            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-xl-row align-items-xl-center gap-2 gap-xl-3 border-bottom border-outline-variant">
                    <div class="position-relative flex-grow-1 users-search-wrap">
                        <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left: 0.85rem;"></i>
                        <input id="logSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search by user, description, or action" />
                    </div>
                    <select id="actionFilter" class="form-select users-select-filter users-compact-filter" aria-label="Filter by action">
                        <option value="ALL">All actions</option>
                        <option value="LOGIN">Login</option>
                        <option value="LOGOUT">Logout</option>
                        <option value="USER_CREATE">User create</option>
                        <option value="USER_UPDATE">User update</option>
                        <option value="USER_DELETE">User delete</option>
                        <option value="ACCESS_APPROVE">Access approve</option>
                        <option value="ACCESS_REJECT">Access reject</option>
                        <option value="CONTACT_READ">Contact read</option>
                        <option value="CONTACT_FIXED">Contact fixed</option>
                        <option value="PROFILE_UPDATE">Profile update</option>
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
                                <th class="px-3 px-md-4 py-3">SN</th>
                                <th class="px-3 px-md-4 py-3">DATE</th>
                                <th class="px-3 px-md-4 py-3">USER</th>
                                <th class="px-3 px-md-4 py-3">ACTION</th>
                                <th class="px-3 px-md-4 py-3">DESCRIPTION</th>
                            </tr>
                        </thead>
                        <tbody id="activityTableBody">
                            <c:forEach items="${logs}" var="log" varStatus="loop">
                                <tr>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant">${loop.count}</td>
                                    <td class="px-3 px-md-4 py-3 text-on-surface-variant" style="font-size: 13px;">
                                        <fmt:formatDate value="${log.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 32px; height: 32px; font-size: 11px;">${empty log.userName ? 'U' : fn:toUpperCase(fn:substring(log.userName, 0, 1))}</div>
                                            <div>
                                                <span class="fw-semibold text-on-surface d-block"><c:out value="${log.userName}" /></span>
                                                <span class="small text-on-surface-variant"><c:out value="${log.userEmail}" /></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-3 px-md-4 py-3">
                                        <c:choose>
                                            <c:when test="${log.action eq 'LOGIN'}">
                                                <span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-arrow-right-to-bracket me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'LOGOUT'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-arrow-right-from-bracket me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_CREATE'}">
                                                <span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-solid fa-plus me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_UPDATE'}">
                                                <span class="badge bg-warning bg-opacity-20 text-warning fw-semibold"><i class="fa-solid fa-pen me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'USER_DELETE'}">
                                                <span class="badge bg-danger bg-opacity-20 text-danger fw-semibold"><i class="fa-solid fa-trash me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'ACCESS_APPROVE'}">
                                                <span class="badge bg-info bg-opacity-20 text-info fw-semibold"><i class="fa-solid fa-check-circle me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'ACCESS_REJECT'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-circle-xmark me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'CONTACT_READ'}">
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-envelope-open me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'CONTACT_FIXED'}">
                                                <span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-circle-check me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action eq 'PROFILE_UPDATE'}">
                                                <span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-regular fa-user-pen me-1"></i> ${log.action}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold">${log.action}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-3 px-md-4 py-3"><c:out value="${log.description}" /></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="5" class="py-5 text-center text-on-surface-variant px-3 px-md-4">
                                        <div class="d-flex flex-column align-items-center gap-2">
                                            <i class="fa-regular fa-circle-check fs-3 text-primary"></i>
                                            <strong class="text-on-surface">No activity logs found</strong>
                                            <span class="small">Logs will appear here as users interact with the system.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="users-pagination-bar px-3 px-md-4 py-3 border-top border-outline-variant d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                    <p id="logsSummaryText" class="m-0 fw-medium text-on-surface-variant" style="font-size: 12px;">Showing ${fn:length(logs)} logs</p>
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
    <script src="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.js"></script>
    <script>
        (() => {
            const tableBody = document.getElementById('activityTableBody');
            const searchInput = document.getElementById('logSearchInput');
            const actionFilter = document.getElementById('actionFilter');
            const rowsPerPageSelect = document.getElementById('rowsPerPage');
            const prevPageBtn = document.getElementById('prevPageBtn');
            const nextPageBtn = document.getElementById('nextPageBtn');
            const pageIndicator = document.getElementById('pageIndicator');
            const logsSummaryText = document.getElementById('logsSummaryText');

            let allLogs = [];
            const state = {
                filteredLogs: [],
                currentPage: 1,
                pageSize: parseInt(rowsPerPageSelect.value || 20)
            };

            function filter() {
                const query = (searchInput.value || '').toLowerCase();
                const action = (actionFilter && actionFilter.value) ? actionFilter.value : 'ALL';
                state.filteredLogs = allLogs.filter((item) => {
                    const textMatch = (item.userName + ' ' + item.userEmail + ' ' + item.description).toLowerCase().includes(query);
                    const actionMatch = (action === 'ALL') || (item.action === action);
                    return textMatch && actionMatch;
                });
                state.currentPage = 1;
                renderTable();
            }

            function renderTable() {
                if (state.filteredLogs.length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="5" class="py-5 text-center text-on-surface-variant">No activity logs found.</td></tr>';
                    updatePagination();
                    return;
                }

                const start = (state.currentPage - 1) * state.pageSize;
                const end = start + state.pageSize;
                const pageItems = state.filteredLogs.slice(start, end);

                tableBody.innerHTML = pageItems.map((item, idx) => {
                    const globalIdx = start + idx + 1;
                    const date = new Date(item.createdAt);
                    const dateStr = date.toLocaleDateString('en-US', {year: 'numeric', month: 'short', day: '2-digit'}) 
                                  + ' ' + date.toLocaleTimeString('en-US', {hour: '2-digit', minute: '2-digit'});
                    
                    let badge = '';
                    if (item.action === 'LOGIN') badge = '<span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-arrow-right-to-bracket me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'LOGOUT') badge = '<span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-arrow-right-from-bracket me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'USER_CREATE') badge = '<span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-solid fa-plus me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'USER_UPDATE') badge = '<span class="badge bg-warning bg-opacity-20 text-warning fw-semibold"><i class="fa-solid fa-pen me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'USER_DELETE') badge = '<span class="badge bg-danger bg-opacity-20 text-danger fw-semibold"><i class="fa-solid fa-trash me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'ACCESS_APPROVE') badge = '<span class="badge bg-info bg-opacity-20 text-info fw-semibold"><i class="fa-solid fa-check-circle me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'ACCESS_REJECT') badge = '<span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-circle-xmark me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'CONTACT_READ') badge = '<span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold"><i class="fa-solid fa-envelope-open me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'CONTACT_FIXED') badge = '<span class="badge bg-success bg-opacity-20 text-success fw-semibold"><i class="fa-solid fa-circle-check me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else if (item.action === 'PROFILE_UPDATE') badge = '<span class="badge bg-primary bg-opacity-20 text-primary fw-semibold"><i class="fa-regular fa-user-pen me-1"></i> ' + escapeHtml(item.action) + '</span>';
                    else badge = '<span class="badge bg-secondary bg-opacity-20 text-secondary fw-semibold">' + escapeHtml(item.action) + '</span>';

                    return '<tr>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant">' + globalIdx + '</td>'
                        + '<td class="px-3 px-md-4 py-3 text-on-surface-variant" style="font-size: 13px;">' + dateStr + '</td>'
                        + '<td class="px-3 px-md-4 py-3">'
                        + '<div class="d-flex align-items-center gap-2">'
                        + '<div class="rounded-circle d-flex align-items-center justify-content-center fw-bold bg-surface-container text-on-surface-variant" style="width: 32px; height: 32px; font-size: 11px;">' + escapeHtml(item.userName.charAt(0).toUpperCase()) + '</div>'
                        + '<div>'
                        + '<span class="fw-semibold text-on-surface d-block">' + escapeHtml(item.userName) + '</span>'
                        + '<span class="small text-on-surface-variant">' + escapeHtml(item.userEmail) + '</span>'
                        + '</div>'
                        + '</div>'
                        + '</td>'
                        + '<td class="px-3 px-md-4 py-3">' + badge + '</td>'
                        + '<td class="px-3 px-md-4 py-3">' + escapeHtml(item.description) + '</td>'
                        + '</tr>';
                }).join('');

                updatePagination();
            }

            function updatePagination() {
                const totalPages = Math.ceil(state.filteredLogs.length / state.pageSize);
                pageIndicator.textContent = 'Page ' + state.currentPage + ' of ' + (totalPages || 1);
                logsSummaryText.textContent = 'Showing ' + state.filteredLogs.length + ' logs';
                prevPageBtn.disabled = state.currentPage === 1;
                nextPageBtn.disabled = state.currentPage >= totalPages;
            }

            function escapeHtml(value) {
                return String(value ?? '')
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            }

            searchInput.addEventListener('input', filter);
            if (actionFilter) actionFilter.addEventListener('change', filter);
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
                const totalPages = Math.ceil(state.filteredLogs.length / state.pageSize);
                if (state.currentPage < totalPages) {
                    state.currentPage++;
                    renderTable();
                }
            });

            // Bootstrap logs from page data
            (function() {
                const rows = Array.from(tableBody.querySelectorAll('tr'));
                rows.forEach((row, idx) => {
                    if (row.querySelector('td[colspan]')) return;
                    const tds = row.querySelectorAll('td');
                    if (tds.length < 5) return;
                    const dateStr = tds[1]?.textContent || '';
                    const userName = tds[2]?.textContent?.split('\n')[0] || '';
                    const userEmail = tds[2]?.textContent?.split('\n')[1] || '';
                    const action = tds[3]?.textContent?.trim().split('\n')[0] || '';
                    const description = tds[4]?.textContent || '';
                    
                    allLogs.push({
                        userName: userName,
                        userEmail: userEmail,
                        action: action,
                        description: description,
                        createdAt: dateStr
                    });
                });
                filter();
            })();
        })();
    </script>
</body>
</html>
