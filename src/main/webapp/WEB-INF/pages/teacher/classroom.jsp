<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Classroom</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="resources" scope="request" />
<c:set var="searchPlaceholder" value="Search the portal..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/teacherSidebar.jsp" />
    
    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
        <div class="p-4 mx-auto w-100 d-flex flex-column" style="gap: 2.5rem;">
            <!-- Page Header -->
            <section class="page-header-sleek px-4 py-4 mb-4">
                <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3">
                    <div>
                        <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Teacher Hub</div>
                        <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Teaching Management</h2>
                        <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Manage your course content, assignments, and track student submissions.</p>
                    </div>
                </div>
            </section>

            <!-- Tabbed Interface -->
            <div class="panel-sleek border-0 shadow-sm rounded-4">
                <!-- Navigation Tabs -->
                <ul class="nav nav-tabs border-bottom border-outline-variant px-4 pt-3" id="teacherTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active fw-semibold brand-headline" id="content-tab" data-bs-toggle="tab" data-bs-target="#content-content" type="button" role="tab" aria-controls="content-content" aria-selected="true">
                            <i class="fa-solid fa-folder-open me-2"></i>Teacher's Content
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link fw-semibold brand-headline" id="assignments-tab" data-bs-toggle="tab" data-bs-target="#assignments-content" type="button" role="tab" aria-controls="assignments-content" aria-selected="false">
                            <i class="fa-solid fa-tasks me-2"></i>Assignments
                        </button>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content p-4" id="teacherTabContent">
                    
                    <!-- TAB 1: Teacher's Content -->
                    <div class="tab-pane fade show active" id="content-content" role="tabpanel" aria-labelledby="content-tab">
                        
                        <!-- Breadcrumb & Actions -->
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom border-outline-variant">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item"><a href="#" class="text-primary text-decoration-none"><i class="fa-solid fa-arrow-left me-2"></i>Back to Courses</a></li>
                                    <li class="breadcrumb-item active text-on-surface-variant">Prof. Miller's Content</li>
                                </ol>
                            </nav>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-primary btn-sm px-3 py-2 rounded-3" type="button" data-bs-toggle="modal" data-bs-target="#createFolderModal">
                                    <i class="fa-solid fa-folder-plus me-2"></i>Create Folder
                                </button>
                                <button class="btn btn-primary-edu btn-sm px-3 py-2 rounded-3" type="button" data-bs-toggle="modal" data-bs-target="#uploadFileModal">
                                    <i class="fa-solid fa-arrow-up-from-bracket me-2"></i>Upload File
                                </button>
                            </div>
                        </div>

                        <!-- Folder Grid View (Root Level) -->
                        <div class="row g-3 mb-4">
                            <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                <div class="card card-sleek h-100 cursor-pointer" style="transition: all 0.3s ease;">
                                    <div class="card-body d-flex flex-column align-items-center text-center">
                                        <i class="fa-solid fa-folder-open fs-1 text-primary mb-3" style="opacity: 0.8;"></i>
                                        <h5 class="card-title fw-bold mb-1">Week 1</h5>
                                        <p class="card-text small text-on-surface-variant">5 files</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                <div class="card card-sleek h-100 cursor-pointer" style="transition: all 0.3s ease;">
                                    <div class="card-body d-flex flex-column align-items-center text-center">
                                        <i class="fa-solid fa-folder-open fs-1 text-primary mb-3" style="opacity: 0.8;"></i>
                                        <h5 class="card-title fw-bold mb-1">Lecture Notes</h5>
                                        <p class="card-text small text-on-surface-variant">8 files</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                <div class="card card-sleek h-100 cursor-pointer" style="transition: all 0.3s ease;">
                                    <div class="card-body d-flex flex-column align-items-center text-center">
                                        <i class="fa-solid fa-folder-open fs-1 text-primary mb-3" style="opacity: 0.8;"></i>
                                        <h5 class="card-title fw-bold mb-1">Resources</h5>
                                        <p class="card-text small text-on-surface-variant">12 files</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                <div class="card card-sleek h-100 cursor-pointer" style="transition: all 0.3s ease;">
                                    <div class="card-body d-flex flex-column align-items-center text-center">
                                        <i class="fa-solid fa-folder-open fs-1 text-primary mb-3" style="opacity: 0.8;"></i>
                                        <h5 class="card-title fw-bold mb-1">Exam Papers</h5>
                                        <p class="card-text small text-on-surface-variant">3 files</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- File Table (Inside Folder View) -->
                        <div class="table-responsive bg-white rounded-3 border border-outline-variant overflow-hidden" style="display: none;" id="fileTableContainer">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-surface-container-high">
                                    <tr>
                                        <th class="px-4 py-3 fw-bold small text-on-surface-variant" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Resource Name</th>
                                        <th class="px-4 py-3 fw-bold small text-on-surface-variant" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Shared On</th>
                                        <th class="px-4 py-3 fw-bold small text-on-surface-variant d-none d-md-table-cell" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Size</th>
                                        <th class="px-4 py-3 fw-bold small text-on-surface-variant text-end d-none d-lg-table-cell" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="px-4 py-3">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fa-regular fa-file-pdf text-danger"></i>
                                                <span class="fw-semibold text-on-surface">Lecture_01.pdf</span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3 small text-on-surface-variant">March 19, 2026</td>
                                        <td class="px-4 py-3 small text-on-surface-variant d-none d-md-table-cell">2.4 MB</td>
                                        <td class="px-4 py-3 text-end d-none d-lg-table-cell">
                                            <button class="btn btn-sm btn-link text-primary p-0">Edit</button>
                                            <button class="btn btn-sm btn-link text-danger p-0">Delete</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="px-4 py-3">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fa-regular fa-file-word text-primary"></i>
                                                <span class="fw-semibold text-on-surface">Instruction.docx</span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3 small text-on-surface-variant">March 29, 2026</td>
                                        <td class="px-4 py-3 small text-on-surface-variant d-none d-md-table-cell">770 KB</td>
                                        <td class="px-4 py-3 text-end d-none d-lg-table-cell">
                                            <button class="btn btn-sm btn-link text-primary p-0">Edit</button>
                                            <button class="btn btn-sm btn-link text-danger p-0">Delete</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- TAB 2: Assignments -->
                    <div class="tab-pane fade" id="assignments-content" role="tabpanel" aria-labelledby="assignments-tab">
                        
                        <!-- Search and Create -->
                        <div class="d-flex gap-3 mb-4 flex-column flex-md-row">
                            <div class="flex-grow-1">
                                <input type="text" class="form-control input-ghost rounded-3" placeholder="Search assignments..." style="min-height: 44px;">
                            </div>
                            <button class="btn btn-primary-edu px-4 py-2 rounded-3 fw-semibold" type="button" data-bs-toggle="modal" data-bs-target="#createAssignmentModal">
                                <i class="fa-solid fa-plus me-2"></i>Create Assignment
                            </button>
                        </div>

                        <!-- Open Assignments -->
                        <div class="mb-4">
                            <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-clock text-warning"></i>
                                Open Assignments <span class="badge bg-warning text-warning-emphasis">(1)</span>
                            </h5>
                            <div class="bg-white rounded-3 border border-outline-variant overflow-hidden">
                                <div class="p-4 border-bottom border-outline-variant d-flex justify-content-between align-items-start gap-3 card-sleek" style="cursor: pointer; transition: all 0.3s ease;" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-2">2nd Milestone</h6>
                                        <div class="d-flex gap-4 flex-wrap small text-on-surface-variant">
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Open: <strong>May 3, 2026, 10:54 AM NPT</strong></span>
                                            </div>
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Due: <strong>May 4, 2026, 6:00 PM NPT</strong></span>
                                            </div>
                                        </div>
                                        <div class="mt-3 d-flex gap-2">
                                            <span class="edu-badge" style="background: #fef3c7; color: #92400e; border-color: #fcd34d; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em; font-size: 10px;">PENDING</span>
                                            <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">1 Submission</span>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0 mb-2" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">View Submissions</a>
                                        <br>
                                        <a href="#" class="btn btn-sm btn-link text-on-surface-variant p-0">Edit</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Closed Assignments -->
                        <div>
                            <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-check-circle text-success"></i>
                                Closed Assignments <span class="badge bg-success text-success-emphasis">(3)</span>
                            </h5>
                            
                            <!-- Assignment 1 -->
                            <div class="bg-white rounded-3 border border-outline-variant overflow-hidden mb-3 card-sleek" style="cursor: pointer; transition: all 0.3s ease;" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">
                                <div class="p-4 border-bottom border-outline-variant d-flex justify-content-between align-items-start gap-3">
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-2">First Milestone DSA Coursework</h6>
                                        <div class="d-flex gap-4 flex-wrap small text-on-surface-variant">
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Open: <strong>Apr 16, 2026, 11:08 AM NPT</strong></span>
                                            </div>
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Due: <strong>Apr 17, 2026, 6:00 PM NPT</strong></span>
                                            </div>
                                        </div>
                                        <div class="mt-3 d-flex gap-2">
                                            <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">SUBMITTED</span>
                                            <span class="edu-badge edu-badge-role-student" style="font-size: 10px;">5/5 Graded</span>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0 mb-2" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">View Submissions</a>
                                        <br>
                                        <a href="#" class="btn btn-sm btn-link text-on-surface-variant p-0">Edit</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Assignment 2 -->
                            <div class="bg-white rounded-3 border border-outline-variant overflow-hidden mb-3 card-sleek" style="cursor: pointer; transition: all 0.3s ease;" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">
                                <div class="p-4 border-bottom border-outline-variant d-flex justify-content-between align-items-start gap-3">
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-2">Final CourseWork 1 Submission</h6>
                                        <div class="d-flex gap-4 flex-wrap small text-on-surface-variant">
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Open: <strong>Jan 11, 2026, 3:30 PM NPT</strong></span>
                                            </div>
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Due: <strong>Jan 16, 2026, 6:00 PM NPT</strong></span>
                                            </div>
                                        </div>
                                        <div class="mt-3 d-flex gap-2">
                                            <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">SUBMITTED</span>
                                            <span class="edu-badge edu-badge-role-teacher" style="font-size: 10px;">3/5 Graded</span>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0 mb-2" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">View Submissions</a>
                                        <br>
                                        <a href="#" class="btn btn-sm btn-link text-on-surface-variant p-0">Edit</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Assignment 3 -->
                            <div class="bg-white rounded-3 border border-outline-variant overflow-hidden card-sleek" style="cursor: pointer; transition: all 0.3s ease;" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">
                                <div class="p-4 border-bottom border-outline-variant d-flex justify-content-between align-items-start gap-3">
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-2">Assignment Topic Research</h6>
                                        <div class="d-flex gap-4 flex-wrap small text-on-surface-variant">
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Open: <strong>Feb 15, 2026, 9:00 AM NPT</strong></span>
                                            </div>
                                            <div>
                                                <i class="fa-regular fa-calendar me-2"></i>
                                                <span>Due: <strong>Feb 22, 2026, 6:00 PM NPT</strong></span>
                                            </div>
                                        </div>
                                        <div class="mt-3 d-flex gap-2">
                                            <span class="edu-badge" style="background: #f3f4f6; color: #6b7280; border-color: #d1d5db; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em; font-size: 10px;">NO SUBMISSIONS</span>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0 mb-2" data-bs-toggle="modal" data-bs-target="#viewSubmissionsModal">View Submissions</a>
                                        <br>
                                        <a href="#" class="btn btn-sm btn-link text-on-surface-variant p-0">Edit</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div>
        </div>

        <jsp:include page="/WEB-INF/components/footer.jsp" />
    </main>

    <!-- MODALS -->

    <!-- Create Folder Modal -->
    <div class="modal fade" id="createFolderModal" tabindex="-1" aria-labelledby="createFolderLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4">
                <div class="modal-header border-bottom border-outline-variant">
                    <h5 class="modal-title fw-bold brand-headline" id="createFolderLabel">Create Folder</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="folderName" class="form-label fw-semibold">Folder Name</label>
                        <input type="text" class="form-control input-ghost rounded-3" id="folderName" placeholder="e.g., Week 1, Resources...">
                    </div>
                    <div class="mb-3">
                        <label for="folderDescription" class="form-label fw-semibold">Description (Optional)</label>
                        <textarea class="form-control input-ghost rounded-3" id="folderDescription" rows="3" placeholder="Add a description..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top border-outline-variant">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary-edu rounded-3">Create Folder</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Upload File Modal -->
    <div class="modal fade" id="uploadFileModal" tabindex="-1" aria-labelledby="uploadFileLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4">
                <div class="modal-header border-bottom border-outline-variant">
                    <h5 class="modal-title fw-bold brand-headline" id="uploadFileLabel">Upload File</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="fileName" class="form-label fw-semibold">File Name</label>
                        <input type="text" class="form-control input-ghost rounded-3" id="fileName" placeholder="Enter file name...">
                    </div>
                    <div class="mb-3">
                        <label for="fileInput" class="form-label fw-semibold">Choose File</label>
                        <input type="file" class="form-control input-ghost rounded-3" id="fileInput">
                        <small class="text-on-surface-variant">Supported formats: PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX, ZIP</small>
                    </div>
                    <div class="mb-3">
                        <label for="fileDescription" class="form-label fw-semibold">Description (Optional)</label>
                        <textarea class="form-control input-ghost rounded-3" id="fileDescription" rows="3" placeholder="Add file description..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top border-outline-variant">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary-edu rounded-3">Upload File</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Assignment Modal -->
    <div class="modal fade" id="createAssignmentModal" tabindex="-1" aria-labelledby="createAssignmentLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4">
                <div class="modal-header border-bottom border-outline-variant">
                    <h5 class="modal-title fw-bold brand-headline" id="createAssignmentLabel">Create Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="assignmentTitle" class="form-label fw-semibold">Assignment Title</label>
                        <input type="text" class="form-control input-ghost rounded-3" id="assignmentTitle" placeholder="e.g., 2nd Milestone...">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="assignmentOpenDate" class="form-label fw-semibold">Open Date & Time</label>
                            <input type="datetime-local" class="form-control input-ghost rounded-3" id="assignmentOpenDate">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="assignmentDueDate" class="form-label fw-semibold">Due Date & Time</label>
                            <input type="datetime-local" class="form-control input-ghost rounded-3" id="assignmentDueDate">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="assignmentDescription" class="form-label fw-semibold">Description</label>
                        <textarea class="form-control input-ghost rounded-3" id="assignmentDescription" rows="4" placeholder="Add assignment instructions..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-top border-outline-variant">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary-edu rounded-3">Create Assignment</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Submissions Modal -->
    <div class="modal fade" id="viewSubmissionsModal" tabindex="-1" aria-labelledby="viewSubmissionsLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4">
                <div class="modal-header border-bottom border-outline-variant">
                    <h5 class="modal-title fw-bold brand-headline" id="viewSubmissionsLabel">2nd Milestone - Student Submissions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-surface-container-high">
                                <tr>
                                    <th class="px-4 py-3 fw-bold small text-on-surface-variant" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Student Name</th>
                                    <th class="px-4 py-3 fw-bold small text-on-surface-variant" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Status</th>
                                    <th class="px-4 py-3 fw-bold small text-on-surface-variant" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Submitted</th>
                                    <th class="px-4 py-3 fw-bold small text-on-surface-variant text-end" style="letter-spacing: 0.05em; text-transform: uppercase; font-size: 11px;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="px-4 py-3">
                                        <span class="fw-semibold text-on-surface">Raj Sharma</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">SUBMITTED</span>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant">May 4, 2026</td>
                                    <td class="px-4 py-3 text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0"><i class="fa-solid fa-download"></i></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-4 py-3">
                                        <span class="fw-semibold text-on-surface">Priya Patel</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="edu-badge" style="background: #f3f4f6; color: #6b7280; border-color: #d1d5db; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em; font-size: 10px;">NOT SUBMITTED</span>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant">—</td>
                                    <td class="px-4 py-3 text-end">
                                        <span class="text-on-surface-variant small">—</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-4 py-3">
                                        <span class="fw-semibold text-on-surface">Amit Kumar</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">SUBMITTED</span>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant">May 3, 2026</td>
                                    <td class="px-4 py-3 text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0"><i class="fa-solid fa-download"></i></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-4 py-3">
                                        <span class="fw-semibold text-on-surface">Neha Singh</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="edu-badge" style="background: #f3f4f6; color: #6b7280; border-color: #d1d5db; border: 1px solid; border-radius: 999px; padding: 0.32rem 0.72rem; font-weight: 700; letter-spacing: 0.04em; font-size: 10px;">NOT SUBMITTED</span>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant">—</td>
                                    <td class="px-4 py-3 text-end">
                                        <span class="text-on-surface-variant small">—</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-4 py-3">
                                        <span class="fw-semibold text-on-surface">Aarav Gupta</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="edu-badge edu-badge-status edu-badge-status-active" style="font-size: 10px;">SUBMITTED</span>
                                    </td>
                                    <td class="px-4 py-3 small text-on-surface-variant">May 2, 2026</td>
                                    <td class="px-4 py-3 text-end">
                                        <a href="#" class="btn btn-sm btn-link text-primary p-0"><i class="fa-solid fa-download"></i></a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.js"></script>
    <script>
        // Helper function to show toast notification
        function showToast(message, type = 'success') {
            Toastify({
                text: message,
                duration: 3000,
                gravity: "top",
                position: "right",
                backgroundColor: type === 'success' ? '#047857' : '#dc2626',
                className: "info"
            }).showToast();
        }

        // Create Folder Modal Handler
        document.addEventListener('DOMContentLoaded', function() {
            const createFolderBtn = document.querySelector('#createFolderModal .modal-footer .btn-primary-edu');
            if (createFolderBtn) {
                createFolderBtn.addEventListener('click', function() {
                    const folderName = document.getElementById('folderName').value.trim();
                    const folderDescription = document.getElementById('folderDescription').value.trim();

                    if (!folderName) {
                        showToast('Folder name is required', 'error');
                        return;
                    }

                    const formData = new FormData();
                    formData.append('folderName', folderName);
                    formData.append('folderDescription', folderDescription);

                    fetch('${pageContext.request.contextPath}/classroom/folder/create', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('Folder created successfully!');
                            document.getElementById('folderName').value = '';
                            document.getElementById('folderDescription').value = '';
                            const modal = bootstrap.Modal.getInstance(document.getElementById('createFolderModal'));
                            modal.hide();
                            // TODO: Reload folder grid or add new folder to UI
                        } else {
                            showToast(data.message, 'error');
                        }
                    })
                    .catch(error => {
                        showToast('Failed to create folder: ' + error, 'error');
                        console.error('Error:', error);
                    });
                });
            }

            // Upload File Modal Handler
            const uploadFileBtn = document.querySelector('#uploadFileModal .modal-footer .btn-primary-edu');
            if (uploadFileBtn) {
                uploadFileBtn.addEventListener('click', function() {
                    const fileName = document.getElementById('fileName').value.trim();
                    const fileInput = document.getElementById('fileInput');
                    const fileDescription = document.getElementById('fileDescription').value.trim();

                    if (!fileName || !fileInput.files.length) {
                        showToast('File name and file are required', 'error');
                        return;
                    }

                    const formData = new FormData();
                    formData.append('fileName', fileName);
                    formData.append('fileDescription', fileDescription);
                    formData.append('fileInput', fileInput.files[0]);

                    fetch('${pageContext.request.contextPath}/classroom/file/upload', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('File uploaded successfully!');
                            document.getElementById('fileName').value = '';
                            document.getElementById('fileInput').value = '';
                            document.getElementById('fileDescription').value = '';
                            const modal = bootstrap.Modal.getInstance(document.getElementById('uploadFileModal'));
                            modal.hide();
                            // TODO: Reload file table or add new file to UI
                        } else {
                            showToast(data.message, 'error');
                        }
                    })
                    .catch(error => {
                        showToast('Failed to upload file: ' + error, 'error');
                        console.error('Error:', error);
                    });
                });
            }

            // Create Assignment Modal Handler
            const createAssignmentBtn = document.querySelector('#createAssignmentModal .modal-footer .btn-primary-edu');
            if (createAssignmentBtn) {
                createAssignmentBtn.addEventListener('click', function() {
                    const assignmentTitle = document.getElementById('assignmentTitle').value.trim();
                    const assignmentOpenDate = document.getElementById('assignmentOpenDate').value;
                    const assignmentDueDate = document.getElementById('assignmentDueDate').value;
                    const assignmentDescription = document.getElementById('assignmentDescription').value.trim();

                    if (!assignmentTitle || !assignmentOpenDate || !assignmentDueDate) {
                        showToast('Assignment title, open date, and due date are required', 'error');
                        return;
                    }

                    const formData = new FormData();
                    formData.append('assignmentTitle', assignmentTitle);
                    formData.append('assignmentOpenDate', assignmentOpenDate);
                    formData.append('assignmentDueDate', assignmentDueDate);
                    formData.append('assignmentDescription', assignmentDescription);

                    fetch('${pageContext.request.contextPath}/classroom/assignment/create', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('Assignment created successfully!');
                            document.getElementById('assignmentTitle').value = '';
                            document.getElementById('assignmentOpenDate').value = '';
                            document.getElementById('assignmentDueDate').value = '';
                            document.getElementById('assignmentDescription').value = '';
                            const modal = bootstrap.Modal.getInstance(document.getElementById('createAssignmentModal'));
                            modal.hide();
                            // TODO: Reload assignments list or add new assignment to UI
                        } else {
                            showToast(data.message, 'error');
                        }
                    })
                    .catch(error => {
                        showToast('Failed to create assignment: ' + error, 'error');
                        console.error('Error:', error);
                    });
                });
            }

            // View Submissions Modal Handler - Load submissions when button is clicked
            const viewSubmissionsButtons = document.querySelectorAll('[data-bs-target="#viewSubmissionsModal"]');
            viewSubmissionsButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // TODO: Get assignment ID from the card and load submissions dynamically
                    // For now, sample data is hardcoded in the modal
                });
            });
        });
    </script>
