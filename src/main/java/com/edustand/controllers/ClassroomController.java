package com.edustand.controllers;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(asyncSupported = true, urlPatterns = { "/classroom/*" })
@MultipartConfig(maxFileSize = 52428800) // 50MB max file size
public class ClassroomController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            writeJsonResponse(resp, false, "Unauthorized access");
            return;
        }
        String pathInfo = req.getPathInfo();
        String action = null;
        if (pathInfo != null && pathInfo.length() > 1) {
            action = pathInfo.substring(1); // e.g. folder/create or assignment/{slug}/submit
        }

        if (action == null) {
            writeJsonResponse(resp, false, "Invalid action");
            return;
        }

        // Student submission: POST /classroom/assignment/{slug}/submit
        if (action.startsWith("assignment/") && action.endsWith("/submit")) {
            // allow students to submit
            if (!"STUDENT".equalsIgnoreCase(loggedInUser.getRole())) {
                writeJsonResponse(resp, false, "Only students can submit assignments");
                return;
            }
            handleStudentSubmission(req, resp, loggedInUser, action);
            return;
        }

        // Teacher-only actions
        if (!"TEACHER".equalsIgnoreCase(loggedInUser.getRole())) {
            writeJsonResponse(resp, false, "Only teachers can access classroom operations");
            return;
        }

        if ("folder/create".equals(action)) {
            handleCreateFolder(req, resp, loggedInUser);
        } else if ("file/upload".equals(action)) {
            handleFileUpload(req, resp, loggedInUser);
        } else if ("assignment/create".equals(action)) {
            handleCreateAssignment(req, resp, loggedInUser);
        } else {
            writeJsonResponse(resp, false, "Invalid action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            writeJsonResponse(resp, false, "Unauthorized access");
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "";

        // API Endpoints for real data
        if ("data/resources".equals(action)) {
            handleGetResources(req, resp, loggedInUser);
        } else if ("data/assignments".equals(action)) {
            handleGetAssignments(req, resp, loggedInUser);
        } else if (action.startsWith("assignment/") && action.endsWith("submissions")) {
            handleGetSubmissions(req, resp, loggedInUser);
        } else {
            writeJsonResponse(resp, false, "Invalid action");
        }
    }

    private void handleGetResources(HttpServletRequest req, HttpServletResponse resp, UserModel user) throws IOException {
        com.edustand.service.ResourceService resourceService = new com.edustand.service.ResourceService();
        String jsonArray = resourceService.getAllResourcesAsJson();
        resp.setContentType("application/json");
        resp.getWriter().write("{\"success\":true, \"data\":" + jsonArray + "}");
    }

    private void handleGetAssignments(HttpServletRequest req, HttpServletResponse resp, UserModel user) throws IOException {
        com.edustand.service.AssignmentService assignmentService = new com.edustand.service.AssignmentService();
        String jsonArray = assignmentService.getAllAssignmentsAsJson(user.getUserId());
        resp.setContentType("application/json");
        resp.getWriter().write("{\"success\":true, \"data\":" + jsonArray + "}");
    }

    private void handleCreateFolder(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String folderName = trim(req.getParameter("folderName"));
        if (folderName.isEmpty()) {
            writeJsonResponse(resp, false, "Folder name is required");
            return;
        }
        try {
            int userId = loggedInUser.getUserId();
            String assetsDir = req.getServletContext().getRealPath("/assets/resources/teacher_" + userId);
            Path folderPath = Paths.get(assetsDir, folderName);
            if (!Files.exists(folderPath)) {
                Files.createDirectories(folderPath);
            }
            com.edustand.service.ResourceService rs = new com.edustand.service.ResourceService();
            rs.addResource(userId, folderName, "", "", "FOLDER", "ROOT");

            new ActivityLogService().logActivity(userId, "CLASSROOM_FOLDER_CREATE", "Created folder: " + folderName);
            writeJsonResponse(resp, true, "Folder created successfully", folderName);
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to create folder: " + e.getMessage());
        }
    }

    private void handleFileUpload(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException, ServletException {
        String fileName = trim(req.getParameter("fileName"));
        Part filePart = req.getPart("fileInput");
        String folderName = trim(req.getParameter("folderName")); // optional

        if (fileName.isEmpty() || filePart == null || filePart.getSize() == 0) {
            writeJsonResponse(resp, false, "File name and file are required");
            return;
        }

        try {
            // Extract file extension from uploaded file if not in provided name
            String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = "";
            int lastDot = submittedName.lastIndexOf('.');
            if (lastDot > 0) {
                fileExtension = submittedName.substring(lastDot);
            }

            // Sanitize file name
            String safeName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
            if (!safeName.endsWith(fileExtension)) {
                safeName += fileExtension;
            }

            String finalFileName = "file_" + System.currentTimeMillis() + "_" + safeName;

            // Save file to assets/resources/teacher_{id}/{folderName?}
            int userId = loggedInUser.getUserId();
            String baseAssets = req.getServletContext().getRealPath("/assets/resources/teacher_" + userId);
            Path fileDir = folderName.isEmpty() ? Paths.get(baseAssets) : Paths.get(baseAssets, folderName);
            if (!Files.exists(fileDir)) {
                Files.createDirectories(fileDir);
            }

            Path target = fileDir.resolve(finalFileName);
            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
            }
            
            try {
                String sourceDir = "/Users/nick/Dev/College/Year 2/Semester 4/CS5005 Data Structures and Specialist Programming/Coursework/code/src/main/webapp/assets/resources/teacher_" + userId + (folderName.isEmpty() ? "" : "/" + folderName);
                Path sourcePath = Paths.get(sourceDir);
                if (!Files.exists(sourcePath)) {
                    Files.createDirectories(sourcePath);
                }
                Files.copy(target, sourcePath.resolve(finalFileName), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {}

            new ActivityLogService().logActivity(userId, "CLASSROOM_FILE_UPLOAD",
                    "Uploaded file: " + fileName + " to " + fileDir.toString());

            // Return relative asset path for client
            String relPath = "assets/resources/teacher_" + userId + (folderName.isEmpty() ? "" : "/" + folderName) + "/"
                    + finalFileName;

            // Add to database
            com.edustand.service.ResourceService rs = new com.edustand.service.ResourceService();
            String fileDesc = trim(req.getParameter("fileDescription"));
            rs.addResource(userId, fileName, fileDesc, relPath, "FILE", folderName.isEmpty() ? "ROOT" : folderName);

            writeJsonResponse(resp, true, "File uploaded successfully", relPath);
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to upload file: " + e.getMessage());
        }
    }

    private void handleCreateAssignment(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String assignmentTitle = trim(req.getParameter("assignmentTitle"));
        String openDate = trim(req.getParameter("assignmentOpenDate"));
        String dueDate = trim(req.getParameter("assignmentDueDate"));
        String assignmentDescription = trim(req.getParameter("assignmentDescription"));
        if (assignmentTitle.isEmpty() || dueDate.isEmpty()) {
            writeJsonResponse(resp, false, "Assignment title and due date are required");
            return;
        }
        try {
            com.edustand.service.AssignmentService as = new com.edustand.service.AssignmentService();
            as.addAssignment(loggedInUser.getUserId(), assignmentTitle, assignmentDescription, dueDate);
            
            new ActivityLogService().logActivity(loggedInUser.getUserId(), "CLASSROOM_ASSIGNMENT_CREATE",
                    "Created assignment: " + assignmentTitle);

            writeJsonResponse(resp, true, "Assignment created successfully", "success");
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to create assignment: " + e.getMessage());
        }
    }

    private void handleStudentSubmission(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser,
            String action)
            throws IOException, ServletException {
        // action example: assignment/{id}/submit
        String[] parts = action.split("/");
        if (parts.length < 3) {
            writeJsonResponse(resp, false, "Invalid assignment submission path");
            return;
        }
        int assignmentId = 0;
        try {
            assignmentId = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            writeJsonResponse(resp, false, "Invalid assignment ID");
            return;
        }

        Part filePart = req.getPart("submissionFile");

        if (filePart == null || filePart.getSize() == 0) {
            writeJsonResponse(resp, false, "Please attach a file before submitting.");
            return;
        }

        try {
            int studentId = loggedInUser.getUserId();
            String assignmentsRoot = req.getServletContext().getRealPath("/assets/assignments");
            Path submissionDir = Paths.get(assignmentsRoot, "assignment_" + assignmentId, "submissions", "student_" + studentId);
            if (!Files.exists(submissionDir)) {
                Files.createDirectories(submissionDir);
            }

            String savedFileName = "";
            String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String safeName = submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");
            savedFileName = "submission_" + System.currentTimeMillis() + "_" + safeName;
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, submissionDir.resolve(savedFileName), StandardCopyOption.REPLACE_EXISTING);
            }
            
            try {
                String sourceDir = "/Users/nick/Dev/College/Year 2/Semester 4/CS5005 Data Structures and Specialist Programming/Coursework/code/src/main/webapp/assets/assignments/assignment_" + assignmentId + "/submissions/student_" + studentId;
                Path sourcePath = Paths.get(sourceDir);
                if (!Files.exists(sourcePath)) {
                    Files.createDirectories(sourcePath);
                }
                Files.copy(submissionDir.resolve(savedFileName), sourcePath.resolve(savedFileName), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {}

            String relPath = "assets/assignments/assignment_" + assignmentId + "/submissions/student_" + studentId + "/" + savedFileName;
            
            com.edustand.service.AssignmentService as = new com.edustand.service.AssignmentService();
            as.submitAssignment(assignmentId, studentId, relPath);

            new ActivityLogService().logActivity(studentId, "ASSIGNMENT_SUBMIT", "Submitted to assignment " + assignmentId);

            writeJsonResponse(resp, true, "Submission received successfully", savedFileName);
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to submit assignment: " + e.getMessage());
        }
    }

    private void handleGetSubmissions(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String pathInfo = req.getPathInfo();
        String[] parts = pathInfo.split("/");

        if (parts.length < 3) {
            writeJsonResponse(resp, false, "Assignment ID is required");
            return;
        }
        int assignmentId = 0;
        try {
            assignmentId = Integer.parseInt(parts[2]);
        } catch (NumberFormatException e) {
            writeJsonResponse(resp, false, "Invalid assignment ID");
            return;
        }

        com.edustand.service.AssignmentService as = new com.edustand.service.AssignmentService();
        String jsonArray = as.getSubmissionsAsJson(assignmentId);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\":true,\"submissions\":" + jsonArray + "}");
    }

    private void writeJsonResponse(HttpServletResponse resp, boolean success, String message) throws IOException {
        writeJsonResponse(resp, success, message, null);
    }

    private void writeJsonResponse(HttpServletResponse resp, boolean success, String message, String data)
            throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\"");
        if (data != null) {
            json.append(",\"data\":\"").append(escapeJson(data)).append("\"");
        }
        json.append("}");

        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String value) {
        if (value == null)
            return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class SubmissionData {
        String name;
        String status;
        String submissionDate;
        String fileName;

        SubmissionData(String name, String status, String submissionDate, String fileName) {
            this.name = name;
            this.status = status;
            this.submissionDate = submissionDate;
            this.fileName = fileName;
        }
    }
}
