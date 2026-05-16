package com.edustand.controllers;

import java.io.*;
import java.nio.file.*;

import com.edustand.model.UserModel;
import com.edustand.service.NoticeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * NoticeController handles all notice CRUD operations and data fetching.
 *
 * GET  /notice/data              → all notices (admin) or author-filtered (teacher/student)
 * GET  /notice/recent            → 5 most recent active notices
 * GET  /notice/chart-data?days=N → login counts per day for activity chart
 * POST /notice/create            → create new notice
 * POST /notice/update            → update existing notice (admin or owner)
 * POST /notice/delete            → delete notice (admin or owner)
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/notice/*" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024 * 100)
public class NoticeController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final NoticeService noticeService = new NoticeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) { writeJson(resp, 401, "{\"success\":false,\"message\":\"Unauthorized\"}"); return; }

        String pathInfo = req.getPathInfo();
        String action = (pathInfo != null && pathInfo.length() > 1) ? pathInfo.substring(1) : "";
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        switch (action) {
            case "recent":
                resp.getWriter().write("{\"success\":true,\"data\":" + noticeService.getRecentNoticesAsJson(5) + "}");
                break;
            case "data":
                // Admin gets all; teachers get only their own
                String json = "ADMIN".equalsIgnoreCase(user.getRole())
                        ? noticeService.getAllNoticesAsJson()
                        : noticeService.getNoticesByAuthorAsJson(user.getUserId());
                resp.getWriter().write("{\"success\":true,\"data\":" + json + "}");
                break;
            case "chart-data":
                String daysParam = req.getParameter("days");
                int days = 7;
                try { days = Integer.parseInt(daysParam); } catch (Exception ignored) {}
                resp.getWriter().write("{\"success\":true,\"data\":" + noticeService.getLoginCountsAsJson(days) + "}");
                break;
            default:
                writeJson(resp, 400, "{\"success\":false,\"message\":\"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) { writeJson(resp, 401, "{\"success\":false,\"message\":\"Unauthorized\"}"); return; }

        String role = user.getRole();
        if (!"ADMIN".equalsIgnoreCase(role) && !"TEACHER".equalsIgnoreCase(role)) {
            writeJson(resp, 403, "{\"success\":false,\"message\":\"Forbidden\"}"); return;
        }

        String pathInfo = req.getPathInfo();
        String action = (pathInfo != null && pathInfo.length() > 1) ? pathInfo.substring(1) : "";

        switch (action) {
            case "create": handleCreateNotice(req, resp, user); break;
            case "update": handleUpdateNotice(req, resp, user); break;
            case "delete": handleDeleteNotice(req, resp, user); break;
            default: writeJson(resp, 400, "{\"success\":false,\"message\":\"Invalid action\"}");
        }
    }

    private void handleCreateNotice(HttpServletRequest req, HttpServletResponse resp, UserModel user) throws IOException, ServletException {
        String title = trim(req.getParameter("noticeTitle"));
        String body = trim(req.getParameter("noticeBody"));
        String startDate = trim(req.getParameter("noticeStartDate"));
        String endDate = trim(req.getParameter("noticeEndDate"));

        if (title.isBlank() || body.isBlank() || startDate.isBlank() || endDate.isBlank()) {
            writeJson(resp, 400, "{\"success\":false,\"message\":\"Title, body, start date, and end date are required.\"}"); return;
        }

        String attachmentPath = null;
        String attachmentName = null;
        Part filePart = req.getPart("noticeAttachment");
        if (filePart != null && filePart.getSize() > 0) {
            String rawName = filePart.getSubmittedFileName();
            if (rawName != null && !rawName.isBlank()) {
                if (rawName.contains("/")) rawName = rawName.substring(rawName.lastIndexOf("/") + 1);
                if (rawName.contains("\\")) rawName = rawName.substring(rawName.lastIndexOf("\\") + 1);
                String safeName = rawName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
                String fileName = "notice_" + System.currentTimeMillis() + "_" + safeName;

                String uploadDir = req.getServletContext().getRealPath("/assets/notices");
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);
                Path target = uploadPath.resolve(fileName);
                try (InputStream in = filePart.getInputStream()) { Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING); }

                // Dual-write to src
                try {
                    String projectBase = System.getProperty("user.home") + "/Dev/College/Year 2/Semester 4/CS5005 Data Structures and Specialist Programming/Coursework/code/src/main/webapp/assets/notices";
                    Path srcPath = Paths.get(projectBase);
                    if (!Files.exists(srcPath)) Files.createDirectories(srcPath);
                    Files.copy(target, srcPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
                } catch (Exception ignored) {}

                attachmentPath = "assets/notices/" + fileName;
                attachmentName = rawName;
            }
        }

        int noticeId = noticeService.createNotice(user.getUserId(), title, body, attachmentPath, attachmentName, startDate, endDate);
        if (noticeId > 0) {
            writeJson(resp, 200, "{\"success\":true,\"message\":\"Notice created successfully\",\"id\":" + noticeId + "}");
        } else {
            writeJson(resp, 500, "{\"success\":false,\"message\":\"Failed to create notice\"}");
        }
    }

    private void handleUpdateNotice(HttpServletRequest req, HttpServletResponse resp, UserModel user) throws IOException {
        String idStr = trim(req.getParameter("noticeId"));
        String title = trim(req.getParameter("noticeTitle"));
        String body = trim(req.getParameter("noticeBody"));
        String startDate = trim(req.getParameter("noticeStartDate"));
        String endDate = trim(req.getParameter("noticeEndDate"));

        if (idStr.isBlank() || title.isBlank() || body.isBlank()) {
            writeJson(resp, 400, "{\"success\":false,\"message\":\"Missing required fields.\"}"); return;
        }

        int noticeId;
        try { noticeId = Integer.parseInt(idStr); } catch (NumberFormatException e) {
            writeJson(resp, 400, "{\"success\":false,\"message\":\"Invalid notice ID.\"}"); return;
        }

        // Permission: admin can edit any, teacher can only edit their own
        if (!"ADMIN".equalsIgnoreCase(user.getRole()) && !noticeService.isAuthor(noticeId, user.getUserId())) {
            writeJson(resp, 403, "{\"success\":false,\"message\":\"You can only edit your own notices.\"}"); return;
        }

        boolean ok = noticeService.updateNotice(noticeId, title, body, startDate, endDate, user.getUserId());
        writeJson(resp, ok ? 200 : 500, ok
                ? "{\"success\":true,\"message\":\"Notice updated successfully\"}"
                : "{\"success\":false,\"message\":\"Failed to update notice\"}");
    }

    private void handleDeleteNotice(HttpServletRequest req, HttpServletResponse resp, UserModel user) throws IOException {
        String idStr = trim(req.getParameter("noticeId"));
        if (idStr.isBlank()) { writeJson(resp, 400, "{\"success\":false,\"message\":\"Notice ID required.\"}"); return; }

        int noticeId;
        try { noticeId = Integer.parseInt(idStr); } catch (NumberFormatException e) {
            writeJson(resp, 400, "{\"success\":false,\"message\":\"Invalid notice ID.\"}"); return;
        }

        if (!"ADMIN".equalsIgnoreCase(user.getRole()) && !noticeService.isAuthor(noticeId, user.getUserId())) {
            writeJson(resp, 403, "{\"success\":false,\"message\":\"You can only delete your own notices.\"}"); return;
        }

        boolean ok = noticeService.deleteNotice(noticeId);
        writeJson(resp, ok ? 200 : 500, ok
                ? "{\"success\":true,\"message\":\"Notice deleted\"}"
                : "{\"success\":false,\"message\":\"Failed to delete notice\"}");
    }

    private void writeJson(HttpServletResponse resp, int status, String json) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(json);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
