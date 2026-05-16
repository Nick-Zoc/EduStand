<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Notices</title>
    <meta name="description" content="Manage and publish notices for the EduStand platform.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="notices" scope="request" />
<c:set var="searchPlaceholder" value="Search notices..." scope="request" />

<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/adminSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">

            <!-- Page header -->
            <div class="users-page-intro d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
                <div>
                    <div class="users-kicker small text-uppercase fw-semibold text-warning mb-1" style="letter-spacing:0.08em;">
                        <i class="fa-solid fa-bullhorn me-1"></i> Announcements
                    </div>
                    <h2 class="users-title fs-1 fw-bold m-0 brand-headline text-on-surface">Notices</h2>
                    <p class="users-subtitle text-on-surface-variant mb-0" style="max-width:46rem;line-height:1.6;">
                        Create and manage platform-wide notices. Active notices appear on all dashboards.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary-edu d-inline-flex align-items-center gap-2 px-4 py-2 fw-semibold text-white border-0 shadow-sm"
                            type="button" data-bs-toggle="modal" data-bs-target="#noticeFormModal" onclick="openCreateModal()">
                        <i class="fa-solid fa-plus"></i> New Notice
                    </button>
                </div>
            </div>

            <!-- Filter / search toolbar -->
            <section class="users-table-wrap">
                <div class="users-toolbar px-3 px-md-4 py-3 d-flex flex-column flex-xl-row align-items-xl-center gap-2 gap-xl-3 border-bottom border-outline-variant">
                    <div class="position-relative flex-grow-1">
                        <i class="fa-solid fa-magnifying-glass position-absolute top-50 translate-middle-y text-on-surface-variant small" style="left:0.85rem;"></i>
                        <input id="noticeSearchInput" class="form-control ps-5 users-search-field" type="text" placeholder="Search notices..." oninput="filterNotices()">
                    </div>
                    <select id="noticeStatusFilter" class="form-select users-select-filter users-compact-filter" onchange="filterNotices()">
                        <option value="ALL">All notices</option>
                        <option value="ACTIVE">Active</option>
                        <option value="EXPIRED">Expired</option>
                        <option value="UPCOMING">Upcoming</option>
                    </select>
                </div>

                <!-- Table -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-index users-flat-table">
                        <thead class="bg-surface">
                            <tr>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">TITLE</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">STATUS</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">ACTIVE PERIOD</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">CREATED BY</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">LAST EDITED BY</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant" style="letter-spacing:.04em;">CREATED</th>
                                <th class="px-3 py-3 fw-bold small text-uppercase text-on-surface-variant text-end" style="letter-spacing:.04em;">ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody id="noticesTableBody">
                            <tr><td colspan="7" class="text-center py-5 text-on-surface-variant">
                                <i class="fa-solid fa-spinner fa-spin me-2"></i> Loading notices...
                            </td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="px-3 py-2 border-top border-outline-variant d-flex justify-content-between align-items-center">
                    <p class="m-0 text-on-surface-variant" style="font-size:12px;" id="noticeCount">—</p>
                </div>
            </section>
        </div>
        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <!-- Create / Edit Notice Modal -->
    <div class="modal fade" id="noticeFormModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius:1rem;">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title fw-bold brand-headline" id="noticeFormModalTitle">
                        <i class="fa-solid fa-bullhorn text-warning me-2"></i>Post a Notice
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="noticeForm" enctype="multipart/form-data">
                    <input type="hidden" id="editNoticeId" name="noticeId" value="">
                    <div class="modal-body px-4 py-3">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Title</label>
                            <input type="text" class="form-control input-ghost" id="noticeTitle" name="noticeTitle" placeholder="Notice title..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Message</label>
                            <textarea class="form-control input-ghost" id="noticeBody" name="noticeBody" rows="5" placeholder="Write your announcement..." required></textarea>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Active From</label>
                                <input type="date" class="form-control input-ghost" id="noticeStartDate" name="noticeStartDate" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Active Until</label>
                                <input type="date" class="form-control input-ghost" id="noticeEndDate" name="noticeEndDate" required>
                            </div>
                        </div>
                        <div class="mb-3" id="attachmentField">
                            <label class="form-label fw-semibold small text-on-surface-variant text-uppercase" style="letter-spacing:.05em">Attachment (Optional)</label>
                            <input type="file" class="form-control input-ghost" name="noticeAttachment" accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.png,.jpg,.jpeg,.zip">
                            <div class="form-text text-on-surface-variant">PDF, Word, PowerPoint, images, ZIP — max 50MB</div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-outline-variant px-4 py-3">
                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-edu rounded-pill px-5 fw-semibold" id="noticeFormSubmitBtn">
                            <i class="fa-solid fa-paper-plane me-2"></i>Post Notice
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View Notice Body Modal -->
    <div class="modal fade" id="viewNoticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg" style="border-radius:1rem;">
                <div class="modal-header border-bottom border-outline-variant px-4 py-3">
                    <h5 class="modal-title fw-bold brand-headline" id="viewNoticeTitle">Notice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 py-4">
                    <div id="viewNoticeBody" class="text-on-surface" style="white-space:pre-wrap;"></div>
                    <div id="viewNoticeAttachment" class="mt-3"></div>
                    <div class="mt-4 pt-3 border-top border-outline-variant d-flex flex-wrap gap-4 text-on-surface-variant small">
                        <div><span class="fw-semibold">Created by:</span> <span id="viewNoticeAuthor"></span></div>
                        <div><span class="fw-semibold">Period:</span> <span id="viewNoticePeriod"></span></div>
                        <div><span class="fw-semibold">Last edited by:</span> <span id="viewNoticeEditor"></span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script>
    const CTX = '${pageContext.request.contextPath}';
    let allNotices = [];

    // ---- Toast ----
    function showToast(msg, type = 'success') {
        const cls = type === 'error' ? 'bg-danger' : 'bg-success';
        const el = document.createElement('div');
        el.className = 'position-fixed bottom-0 end-0 p-3';
        el.style.zIndex = 9999;
        el.innerHTML = `<div class="toast align-items-center text-white ${cls} border-0 show"><div class="d-flex"><div class="toast-body fw-semibold">${msg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.closest('.position-fixed').remove()"></button></div></div>`;
        document.body.appendChild(el);
        setTimeout(() => el.remove(), 3500);
    }

    // ---- Load notices ----
    async function loadNotices() {
        try {
            const resp = await fetch(CTX + '/notice/data');
            const result = await resp.json();
            allNotices = result.data || [];
            renderTable(allNotices);
        } catch (e) {
            document.getElementById('noticesTableBody').innerHTML = '<tr><td colspan="7" class="text-center py-5 text-danger">Failed to load notices.</td></tr>';
        }
    }

    function getStatus(n) {
        const today = new Date().toISOString().slice(0,10);
        if (n.startDate > today) return 'UPCOMING';
        if (n.endDate < today) return 'EXPIRED';
        return 'ACTIVE';
    }

    function renderTable(notices) {
        const tbody = document.getElementById('noticesTableBody');
        document.getElementById('noticeCount').textContent = `Showing ${notices.length} notice${notices.length !== 1 ? 's' : ''}`;
        if (!notices.length) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5 text-on-surface-variant">No notices found.</td></tr>';
            return;
        }
        tbody.innerHTML = notices.map(n => {
            const status = getStatus(n);
            const statusBadge = status === 'ACTIVE'
                ? `<span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill fw-medium">Active</span>`
                : status === 'UPCOMING'
                    ? `<span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill fw-medium">Upcoming</span>`
                    : `<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill fw-medium">Expired</span>`;
            const editor = n.lastEditedBy ? n.lastEditedBy : '<span class="text-on-surface-variant">—</span>';
            const createdDate = n.createdAt ? n.createdAt.substring(0,10) : '—';
            return `<tr>
                <td class="px-3 py-3">
                    <div class="fw-semibold text-on-surface" style="max-width:260px;" title="${escHtml(n.title)}">${escHtml(n.title.length > 40 ? n.title.substring(0,40) + '…' : n.title)}</div>
                    <div class="small text-on-surface-variant mt-1">${escHtml(n.body.length > 60 ? n.body.substring(0,60)+'…' : n.body)}</div>
                </td>
                <td class="px-3 py-3">${statusBadge}</td>
                <td class="px-3 py-3 small text-on-surface-variant">${n.startDate} → ${n.endDate}</td>
                <td class="px-3 py-3 small fw-semibold text-on-surface">${escHtml(n.author)}</td>
                <td class="px-3 py-3 small text-on-surface-variant">${editor}</td>
                <td class="px-3 py-3 small text-on-surface-variant">${createdDate}</td>
                <td class="px-3 py-3 text-end">
                    <div class="d-flex gap-1 justify-content-end flex-wrap">
                        <button class="btn btn-sm btn-outline-secondary px-2" title="View full notice" onclick="viewNotice(${n.id})">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-primary px-2" title="Edit notice" onclick="openEditModal(${n.id})">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger px-2" title="Delete notice" onclick="deleteNotice(${n.id}, '${escHtml(n.title)}')">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>`;
        }).join('');
    }

    function filterNotices() {
        const q = document.getElementById('noticeSearchInput').value.toLowerCase();
        const s = document.getElementById('noticeStatusFilter').value;
        const filtered = allNotices.filter(n => {
            const matchSearch = !q || n.title.toLowerCase().includes(q) || n.body.toLowerCase().includes(q) || (n.author||'').toLowerCase().includes(q);
            const matchStatus = s === 'ALL' || getStatus(n) === s;
            return matchSearch && matchStatus;
        });
        renderTable(filtered);
    }

    function escHtml(s) {
        return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    // ---- Create / Edit Modal ----
    function openCreateModal() {
        document.getElementById('noticeFormModalTitle').innerHTML = '<i class="fa-solid fa-bullhorn text-warning me-2"></i>Post a Notice';
        document.getElementById('noticeFormSubmitBtn').innerHTML = '<i class="fa-solid fa-paper-plane me-2"></i>Post Notice';
        document.getElementById('editNoticeId').value = '';
        document.getElementById('noticeForm').reset();
        document.getElementById('attachmentField').style.display = '';
    }

    function openEditModal(id) {
        const n = allNotices.find(x => x.id === id);
        if (!n) return;
        document.getElementById('noticeFormModalTitle').innerHTML = '<i class="fa-solid fa-pen text-primary me-2"></i>Edit Notice';
        document.getElementById('noticeFormSubmitBtn').innerHTML = '<i class="fa-solid fa-save me-2"></i>Save Changes';
        document.getElementById('editNoticeId').value = id;
        document.getElementById('noticeTitle').value = n.title;
        document.getElementById('noticeBody').value = n.body;
        document.getElementById('noticeStartDate').value = n.startDate;
        document.getElementById('noticeEndDate').value = n.endDate;
        document.getElementById('attachmentField').style.display = 'none'; // hide on edit (keep existing)
        new bootstrap.Modal(document.getElementById('noticeFormModal')).show();
    }

    function viewNotice(id) {
        const n = allNotices.find(x => x.id === id);
        if (!n) return;
        document.getElementById('viewNoticeTitle').textContent = n.title;
        document.getElementById('viewNoticeBody').textContent = n.body;
        document.getElementById('viewNoticeAuthor').textContent = n.author;
        document.getElementById('viewNoticePeriod').textContent = n.startDate + ' → ' + n.endDate;
        document.getElementById('viewNoticeEditor').textContent = n.lastEditedBy || '—';
        const attach = document.getElementById('viewNoticeAttachment');
        if (n.attachmentPath) {
            attach.innerHTML = `<a href="${CTX}/${n.attachmentPath}" target="_blank" class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-paperclip me-1"></i>${n.attachmentName || 'View Attachment'}</a>`;
        } else {
            attach.innerHTML = '';
        }
        new bootstrap.Modal(document.getElementById('viewNoticeModal')).show();
    }

    // ---- Form Submit (create or update) ----
    document.getElementById('noticeForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const editId = document.getElementById('editNoticeId').value;
        const isEdit = editId !== '';
        const url = isEdit ? CTX + '/notice/update' : CTX + '/notice/create';
        const formData = new FormData(this);
        try {
            const resp = await fetch(url, { method: 'POST', body: formData });
            const result = await resp.json();
            if (result.success) {
                bootstrap.Modal.getInstance(document.getElementById('noticeFormModal')).hide();
                showToast(result.message || (isEdit ? 'Notice updated!' : 'Notice posted!'));
                this.reset();
                loadNotices();
            } else {
                showToast(result.message || 'Operation failed.', 'error');
            }
        } catch (err) { showToast('Network error.', 'error'); }
    });

    // ---- Delete ----
    async function deleteNotice(id, title) {
        const result = await Swal.fire({
            title: 'Delete Notice?',
            html: `<span class="text-on-surface">This will permanently delete <strong>${escHtml(title)}</strong>.</span>`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete',
            confirmButtonColor: '#dc2626',
            cancelButtonText: 'Cancel',
            background: 'var(--surface)',
            color: 'var(--on-surface)'
        });
        if (!result.isConfirmed) return;
        const formData = new FormData();
        formData.append('noticeId', id);
        try {
            const resp = await fetch(CTX + '/notice/delete', { method: 'POST', body: formData });
            const data = await resp.json();
            if (data.success) { showToast('Notice deleted.'); loadNotices(); }
            else showToast(data.message || 'Failed to delete.', 'error');
        } catch (err) { showToast('Network error.', 'error'); }
    }

    // ---- Init ----
    loadNotices();
    </script>
</body>
</html>
