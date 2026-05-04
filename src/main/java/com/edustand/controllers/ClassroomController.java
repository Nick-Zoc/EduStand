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

        if (!"TEACHER".equalsIgnoreCase(loggedInUser.getRole())) {
            writeJsonResponse(resp, false, "Only teachers can access classroom operations");
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = null;

        if (pathInfo != null && pathInfo.length() > 1) {
            action = pathInfo.substring(1);
        }

        if (action != null && action.startsWith("assignment/")) {
            String[] parts = action.split("/");
            if (parts.length >= 3 && "submissions".equals(parts[2])) {
                handleGetSubmissions(req, resp, loggedInUser);
            }
        }
    }

    private void handleCreateFolder(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String folderName = trim(req.getParameter("folderName"));

        if (folderName.isEmpty()) {
            writeJsonResponse(resp, false, "Folder name is required");
            return;
        }

        try {
            // Create folder under assets/resources/{teacherId}/{folderName}
            int userId = loggedInUser.getUserId();
            String assetsDir = req.getServletContext().getRealPath("/assets/resources/teacher_" + userId);
            Path folderPath = Paths.get(assetsDir, folderName);

            if (!Files.exists(folderPath)) {
                Files.createDirectories(folderPath);
            }

            new ActivityLogService().logActivity(userId, "CLASSROOM_FOLDER_CREATE",
                    "Created folder: " + folderName);

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

            new ActivityLogService().logActivity(userId, "CLASSROOM_FILE_UPLOAD",
                    "Uploaded file: " + fileName + " to " + fileDir.toString());

            // Return relative asset path for client
            String relPath = "assets/resources/teacher_" + userId + (folderName.isEmpty() ? "" : "/" + folderName) + "/"
                    + finalFileName;
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
        if (assignmentTitle.isEmpty() || openDate.isEmpty() || dueDate.isEmpty()) {
            writeJsonResponse(resp, false, "Assignment title, open date, and due date are required");
            return;
        }

        try {
            // Create an assignment folder under assets/assignments/{slug}
            String safeTitle = assignmentTitle.replaceAll("[^a-zA-Z0-9 _-]", "").replaceAll("\\s+", "_");
            String slug = "assignment_" + System.currentTimeMillis() + "_" + safeTitle;
            String assignmentsRoot = req.getServletContext().getRealPath("/assets/assignments");
            Path assignmentDir = Paths.get(assignmentsRoot, slug);
            if (!Files.exists(assignmentDir)) {
                Files.createDirectories(assignmentDir);
            }

            // Save metadata file (assignment.json)
            String meta = "{\"title\":\"" + escapeJson(assignmentTitle) + "\",\"openDate\":\"" + escapeJson(openDate)
                    + "\",\"dueDate\":\"" + escapeJson(dueDate) + "\",\"createdAt\":\"" + System.currentTimeMillis()
                    + "\",\"createdBy\":\"" + loggedInUser.getUserId() + "\"}";
            Files.write(assignmentDir.resolve("assignment.json"), meta.getBytes());

            new ActivityLogService().logActivity(loggedInUser.getUserId(), "CLASSROOM_ASSIGNMENT_CREATE",
                    "Created assignment: " + assignmentTitle + " (" + slug + ")");

            writeJsonResponse(resp, true, "Assignment created successfully", slug);
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to create assignment: " + e.getMessage());
        }
    }

    private void handleStudentSubmission(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser,
            String action)
            throws IOException, ServletException {
        // action example: assignment/{slug}/submit
        String[] parts = action.split("/");
        if (parts.length < 3) {
            writeJsonResponse(resp, false, "Invalid assignment submission path");
            return;
        }
        String slug = parts[1];

        String remarks = trim(req.getParameter("remarks"));
        Part filePart = req.getPart("submissionFile");

        if ((filePart == null || filePart.getSize() == 0) && remarks.isEmpty()) {
            writeJsonResponse(resp, false, "Please attach a file or provide remarks before submitting.");
            return;
        }

        try {
            int studentId = loggedInUser.getUserId();
            String assignmentsRoot = req.getServletContext().getRealPath("/assets/assignments");
            Path submissionDir = Paths.get(assignmentsRoot, slug, "submissions", "student_" + studentId);
            if (!Files.exists(submissionDir)) {
                Files.createDirectories(submissionDir);
            }

            String savedFileName = "";
            if (filePart != null && filePart.getSize() > 0) {
                String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String safeName = submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");
                savedFileName = "submission_" + System.currentTimeMillis() + "_" + safeName;
                try (InputStream in = filePart.getInputStream()) {
                    Files.copy(in, submissionDir.resolve(savedFileName), StandardCopyOption.REPLACE_EXISTING);
                }
            }

            // Save remarks if present
            if (!remarks.isEmpty()) {
                Files.write(submissionDir.resolve("remarks.txt"), remarks.getBytes());
            }

            // Write a small submission metadata file
            String meta = "{\"studentId\":\"" + studentId + "\",\"file\":\"" + escapeJson(savedFileName)
                    + "\",\"remarks\":\"" + escapeJson(remarks) + "\",\"submittedAt\":\"" + System.currentTimeMillis()
                    + "\"}";
            Files.write(submissionDir.resolve("submission.json"), meta.getBytes());

            new ActivityLogService().logActivity(studentId, "ASSIGNMENT_SUBMIT", "Submitted to " + slug);

            writeJsonResponse(resp, true, "Submission received successfully", savedFileName);
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to submit assignment: " + e.getMessage());
        }
    }

    private void handleGetSubmissions(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String pathInfo = req.getPathInfo();
        String[] parts = pathInfo.split("/");

        if (parts.length < 2) {
            writeJsonResponse(resp, false, "Assignment ID is required");
            return;
        }

        try {
            // TODO: Fetch submissions from database for this assignment
            // For now, return sample data
            List<SubmissionData> submissions = new ArrayList<>();
            submissions.add(new SubmissionData("John Doe", "SUBMITTED", "2024-01-15 10:30 AM", "submission_1.pdf"));
            submissions.add(new SubmissionData("Jane Smith", "NOT SUBMITTED", "", ""));
            submissions.add(new SubmissionData("Bob Johnson", "SUBMITTED", "2024-01-14 02:15 PM", "submission_3.pdf"));
            submissions
                    .add(new SubmissionData("Alice Williams", "SUBMITTED", "2024-01-13 09:45 AM", "submission_4.pdf"));
            submissions.add(new SubmissionData("Charlie Brown", "NOT SUBMITTED", "", ""));

            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"submissions\":[");
            for (int i = 0; i < submissions.size(); i++) {
                if (i > 0)
                    json.append(",");
                SubmissionData sub = submissions.get(i);
                json.append("{");
                json.append("\"name\":\"").append(escapeJson(sub.name)).append("\",");
                json.append("\"status\":\"").append(escapeJson(sub.status)).append("\",");
                json.append("\"submissionDate\":\"").append(escapeJson(sub.submissionDate)).append("\",");
                json.append("\"fileName\":\"").append(escapeJson(sub.fileName)).append("\"");
                json.append("}");
            }
            json.append("]}");

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            writeJsonResponse(resp, false, "Failed to fetch submissions: " + e.getMessage());
        }
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
