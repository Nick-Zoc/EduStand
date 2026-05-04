package com.edustand.controllers;

import java.io.IOException;
import java.util.List;

import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;
import com.edustand.service.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminAccessRequests" })
public class AdminAccessRequestsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("data".equals(req.getParameter("action"))) {
            writePendingUsersJson(resp, true, "Requests loaded.");
            return;
        }

        req.setAttribute("pendingUsers", adminService.getPendingUsers());
        req.setAttribute("pendingCount", adminService.countUsersByStatus("PENDING"));
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.getRequestDispatcher("/WEB-INF/pages/admin/accessRequest.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("review_request".equals(action)) {
            handleReviewRequest(req, resp, loggedInUser);
            return;
        }

        if (!"approve_request".equals(action) && !"reject_request".equals(action)) {
            writePendingUsersJson(resp, false, "Unsupported action.");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(req.getParameter("userId"));
        } catch (NumberFormatException e) {
            writePendingUsersJson(resp, false, "Invalid user id.");
            return;
        }

        UserModel pendingRequest = findPendingRequest(userId);
        if (pendingRequest == null) {
            writePendingUsersJson(resp, false, "This request is no longer pending.");
            return;
        }

        String newStatus = "approve_request".equals(action) ? "ACTIVE" : "INACTIVE";
        boolean ok = adminService.updateUserStatus(userId, newStatus);
        if (ok) {
            String actionType = "ACTIVE".equals(newStatus) ? "ACCESS_APPROVE" : "ACCESS_REJECT";
            String actionDesc = "ACTIVE".equals(newStatus)
                    ? "Approved access request for " + pendingRequest.getFullName() + " as " + pendingRequest.getRole()
                    : "Rejected access request for " + pendingRequest.getFullName();
            new ActivityLogService().logActivity(loggedInUser.getUserId(), actionType, actionDesc);
        }
        writePendingUsersJson(resp, ok, ok ? "Request updated." : "Failed to update request.");
    }

    private void handleReviewRequest(HttpServletRequest req, HttpServletResponse resp, UserModel loggedInUser)
            throws IOException {
        String idValue = req.getParameter("userId");
        String status = trim(req.getParameter("status"));
        String newPassword = req.getParameter("password");

        int userId;
        try {
            userId = Integer.parseInt(idValue);
        } catch (NumberFormatException e) {
            writePendingUsersJson(resp, false, "Invalid user id.");
            return;
        }

        UserModel pendingRequest = findPendingRequest(userId);
        if (pendingRequest == null) {
            writePendingUsersJson(resp, false, "This request is no longer pending.");
            return;
        }

        if (status.isEmpty()) {
            writePendingUsersJson(resp, false, "Please choose a decision.");
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(status) && !"INACTIVE".equalsIgnoreCase(status)
                && !"PENDING".equalsIgnoreCase(status)) {
            writePendingUsersJson(resp, false, "Unsupported decision.");
            return;
        }

        String normalizedStatus = status.toUpperCase();
        if ("ACTIVE".equals(normalizedStatus) && (newPassword == null || newPassword.isBlank())) {
            writePendingUsersJson(resp, false, "Password is required when approving a request.");
            return;
        }

        boolean ok;
        String message;
        UserModel updatedUser = new UserModel();
        updatedUser.setUserId(userId);
        updatedUser.setFullName(pendingRequest.getFullName());
        updatedUser.setEmail(pendingRequest.getEmail());
        updatedUser.setRole(pendingRequest.getRole());
        updatedUser.setStatus(normalizedStatus);

        if ("ACTIVE".equals(normalizedStatus)) {
            String hashedPassword = com.edustand.util.PasswordUtil.hashPassword(newPassword);
            ok = adminService.updateUser(updatedUser, hashedPassword);
            message = "Request approved successfully.";
            if (ok) {
                new ActivityLogService().logActivity(loggedInUser.getUserId(), "ACCESS_APPROVE",
                        "Approved access request for " + pendingRequest.getFullName() + " as "
                                + pendingRequest.getRole());
            }
        } else if ("INACTIVE".equals(normalizedStatus)) {
            ok = adminService.updateUserStatus(userId, normalizedStatus);
            message = "Request declined successfully.";
            if (ok) {
                new ActivityLogService().logActivity(loggedInUser.getUserId(), "ACCESS_REJECT",
                        "Rejected access request for " + pendingRequest.getFullName());
            }
        } else {
            ok = adminService.updateUserStatus(userId, normalizedStatus);
            message = "Request left pending.";
        }
        writePendingUsersJson(resp, ok, ok ? message : "Failed to review request.");
    }

    private UserModel findPendingRequest(int userId) {
        UserModel user = adminService.findUserById(userId);
        if (user == null) {
            return null;
        }

        if (!"PENDING".equalsIgnoreCase(user.getStatus())) {
            return null;
        }

        return user;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void writePendingUsersJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        List<UserModel> users = adminService.getPendingUsers();
        int pendingCount = adminService.countUsersByStatus("PENDING");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\",");
        json.append("\"pendingCount\":").append(pendingCount).append(",");
        json.append("\"users\":[");

        for (int i = 0; i < users.size(); i++) {
            UserModel user = users.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{");
            json.append("\"userId\":").append(user.getUserId()).append(",");
            json.append("\"fullName\":\"").append(escapeJson(user.getFullName())).append("\",");
            json.append("\"email\":\"").append(escapeJson(user.getEmail())).append("\",");
            json.append("\"role\":\"").append(escapeJson(user.getRole())).append("\",");
            json.append("\"requestReason\":\"").append(escapeJson(user.getRequestReason())).append("\",");
            json.append("\"status\":\"").append(escapeJson(user.getStatus())).append("\"");
            json.append("}");
        }

        json.append("]}");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
