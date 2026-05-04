<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduStand | Classroom (Student)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<c:set var="activeSidebar" value="resources" scope="request" />
<c:set var="searchPlaceholder" value="Search the portal..." scope="request" />
<body class="dashboard-shell bg-surface text-on-surface">
    <jsp:include page="/WEB-INF/components/studentSidebar.jsp" />

    <main class="app-main d-flex flex-column min-vh-100">
        <jsp:include page="/WEB-INF/components/navbar.jsp" />

        <div class="px-3 px-md-4 py-3 w-100 users-flat-shell">
            <div class="p-4 mx-auto w-100 d-flex flex-column" style="gap: 2.5rem;">
                <section class="page-header-sleek px-4 py-4 mb-4">
                    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3">
                        <div>
                            <div class="small text-uppercase fw-semibold text-primary mb-1" style="letter-spacing: 0.08em;">Classroom</div>
                            <h2 class="fs-1 fw-bold m-0 brand-headline text-on-surface">Course Resources & Assignments</h2>
                            <p class="text-on-surface-variant mb-0" style="max-width: 50rem; line-height: 1.6;">Browse materials shared by your teacher and submit assignments from here.</p>
                        </div>
                    </div>
                </section>

                <div class="panel-sleek border-0 shadow-sm rounded-4">
                    <ul class="nav nav-tabs border-bottom border-outline-variant px-4 pt-3" id="studentTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-semibold brand-headline" id="res-tab" data-bs-toggle="tab" data-bs-target="#res-content" type="button" role="tab" aria-controls="res-content" aria-selected="true">
                                <i class="fa-solid fa-folder-open me-2"></i>Resources
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-semibold brand-headline" id="assign-tab" data-bs-toggle="tab" data-bs-target="#assign-content" type="button" role="tab" aria-controls="assign-content" aria-selected="false">
                                <i class="fa-solid fa-tasks me-2"></i>Assignments
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content p-4" id="studentTabContent">
                        <div class="tab-pane fade show active" id="res-content" role="tabpanel" aria-labelledby="res-tab">
                            <div class="row g-3">
                                <!-- Example resource card; in future this will be rendered dynamically -->
                                <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                    <div class="card card-sleek h-100">
                                        <div class="card-body d-flex flex-column align-items-start">
                                            <i class="fa-solid fa-file-pdf fs-2 text-primary mb-2"></i>
                                            <h5 class="fw-bold">Lecture 01 - Intro</h5>
                                            <p class="small text-on-surface-variant mb-2">Uploaded: Apr 10, 2026</p>
                                            <a href="#" class="btn btn-sm btn-outline-primary mt-auto">Download</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="assign-content" role="tabpanel" aria-labelledby="assign-tab">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="fw-semibold">Open Assignments</div>
                            </div>

                            <!-- Example assignment row -->
                            <div class="bg-white rounded-3 border border-outline-variant overflow-hidden mb-3 card-sleek">
                                <div class="p-4 d-flex justify-content-between align-items-start gap-3">
                                    <div>
                                        <h6 class="fw-bold mb-2">2nd Milestone</h6>
                                        <div class="small text-on-surface-variant">Open: May 3, 2026 · Due: May 10, 2026</div>
                                        <p class="mt-2 text-on-surface-variant">Description: Implement core algorithms and submit source files.</p>
                                    </div>
                                    <div class="text-end d-flex flex-column align-items-end gap-2">
                                        <button class="btn btn-primary-edu btn-sm" data-assignment-slug="assignment_sample_2ndMilestone" data-bs-toggle="modal" data-bs-target="#studentSubmitModal">Submit Assignment</button>
                                        <a href="#" class="btn btn-sm btn-link">View Details</a>
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

    <!-- Student Submit Modal -->
    <div class="modal fade" id="studentSubmitModal" tabindex="-1" aria-labelledby="studentSubmitLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4">
                <div class="modal-header border-bottom border-outline-variant">
                    <h5 class="modal-title fw-bold brand-headline" id="studentSubmitLabel">Submit Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="submitRemarks" class="form-label fw-semibold">Remarks</label>
                        <textarea id="submitRemarks" class="form-control input-ghost rounded-3" rows="4" placeholder="Enter your name, college id, and any notes"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="submissionFile" class="form-label fw-semibold">Attach File</label>
                        <input id="submissionFile" type="file" class="form-control input-ghost" name="submissionFile">
                        <div class="form-text small text-on-surface-variant">Max file size per attachment = 100 MB</div>
                    </div>
                </div>
                <div class="modal-footer border-top border-outline-variant">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="submitAssignmentBtn" class="btn btn-primary-edu rounded-3">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.js"></script>
    <script>
        function showToast(msg, type='success'){
            Toastify({text: msg, duration: 3000, gravity: 'top', position: 'right', backgroundColor: type==='success' ? '#047857' : '#dc2626'}).showToast();
        }

        let currentAssignmentSlug = null;
        document.addEventListener('DOMContentLoaded', function(){
            const modal = document.getElementById('studentSubmitModal');
            modal.addEventListener('show.bs.modal', function(event){
                const button = event.relatedTarget;
                currentAssignmentSlug = button.getAttribute('data-assignment-slug');
            });

            document.getElementById('submitAssignmentBtn').addEventListener('click', async function(){
                if(!currentAssignmentSlug){
                    showToast('Unable to determine assignment. Refresh and try again.', 'error');
                    return;
                }

                const remarks = document.getElementById('submitRemarks').value.trim();
                const fileInput = document.getElementById('submissionFile');
                if(!remarks && (!fileInput.files || fileInput.files.length === 0)){
                    showToast('Please provide remarks or attach a file before submitting.', 'error');
                    return;
                }

                const formData = new FormData();
                formData.append('remarks', remarks);
                if(fileInput.files && fileInput.files.length > 0){
                    formData.append('submissionFile', fileInput.files[0]);
                }

                try{
                    const resp = await fetch(`${pageContext.request.contextPath}/classroom/assignment/${currentAssignmentSlug}/submit`, {method: 'POST', body: formData});
                    const data = await resp.json();
                    if(data.success){
                        showToast('Submission uploaded successfully');
                        const bsModal = bootstrap.Modal.getInstance(modal);
                        bsModal.hide();
                    } else {
                        showToast(data.message || 'Failed to submit', 'error');
                    }
                } catch(err){
                    console.error(err);
                    showToast('Network error while submitting', 'error');
                }
            });
        });
    </script>
</body>
</html>
