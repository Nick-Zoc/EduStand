package com.edustand.controllers;

import java.io.IOException;
import java.util.List;

import com.edustand.model.UserModel;
import com.edustand.service.AdminService;
import com.edustand.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminUsers" })
public class AdminUsersController extends HttpServlet {
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
            writeUsersJsonResponse(resp, true, "Users loaded.");
            return;
        }

        populateUsersPage(req, loggedInUser);
        req.getRequestDispatcher("/WEB-INF/pages/admin/users.jsp").forward(req, resp);
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
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"));

        if ("add_user".equals(action)) {
            String fullName = trim(req.getParameter("fullName"));
            String email = trim(req.getParameter("email"));
            String plainPassword = req.getParameter("password");
            String role = trim(req.getParameter("role"));
            String status = trim(req.getParameter("status"));

            if (fullName.isEmpty() || email.isEmpty() || plainPassword == null || plainPassword.isBlank()
                    || role.isEmpty()) {
                respond(req, resp, isAjax, false, "Please complete all required fields.", loggedInUser);
                return;
            }

            if (adminService.findUserByEmail(email) != null) {
                respond(req, resp, isAjax, false, "Email already exists. Use a different email.", loggedInUser);
                return;
            }

            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            UserModel newUser = new UserModel(fullName, email, hashedPassword, role.toUpperCase(),
                    status.isEmpty() ? "ACTIVE" : status.toUpperCase());

            boolean isAdded = adminService.addUser(newUser);
            respond(req, resp, isAjax, isAdded,
                    isAdded ? "User created successfully." : "Failed to create user.", loggedInUser);
            return;
        }

        if ("edit_user".equals(action)) {
            String idValue = req.getParameter("userId");
            String fullName = trim(req.getParameter("fullName"));
            String email = trim(req.getParameter("email"));
            String role = trim(req.getParameter("role"));
            String status = trim(req.getParameter("status"));
            String newPassword = req.getParameter("password");

            int userId;
            try {
                userId = Integer.parseInt(idValue);
            } catch (NumberFormatException e) {
                respond(req, resp, isAjax, false, "Invalid user id.", loggedInUser);
                return;
            }

            if (fullName.isEmpty() || email.isEmpty() || role.isEmpty() || status.isEmpty()) {
                respond(req, resp, isAjax, false, "Please complete all required fields.", loggedInUser);
                return;
            }

            if (adminService.emailExistsForOtherUser(email, userId)) {
                respond(req, resp, isAjax, false, "Email already belongs to another user.", loggedInUser);
                return;
            }

            UserModel updatedUser = new UserModel();
            updatedUser.setUserId(userId);
            updatedUser.setFullName(fullName);
            updatedUser.setEmail(email);
            updatedUser.setRole(role.toUpperCase());
            updatedUser.setStatus(status.toUpperCase());

            String optionalHashedPassword = null;
            if (newPassword != null && !newPassword.isBlank()) {
                optionalHashedPassword = PasswordUtil.hashPassword(newPassword);
            }

            boolean isUpdated = adminService.updateUser(updatedUser, optionalHashedPassword);
            respond(req, resp, isAjax, isUpdated,
                    isUpdated ? "User updated successfully." : "Failed to update user.", loggedInUser);
            return;
        }

        if ("delete_user".equals(action)) {
            String idValue = req.getParameter("userId");
            int userId;
            try {
                userId = Integer.parseInt(idValue);
            } catch (NumberFormatException e) {
                respond(req, resp, isAjax, false, "Invalid user id.", loggedInUser);
                return;
            }

            boolean isDeleted = adminService.deleteUser(userId);
            respond(req, resp, isAjax, isDeleted,
                    isDeleted ? "User deleted successfully." : "Failed to delete user.", loggedInUser);
            return;
        }

        if ("delete_multiple".equals(action)) {
            String ids = req.getParameter("userIds");
            if (ids == null || ids.isBlank()) {
                respond(req, resp, isAjax, false, "No users selected.", loggedInUser);
                return;
            }
            String[] parts = ids.split(",");
            int successCount = 0;
            for (String p : parts) {
                try {
                    int uid = Integer.parseInt(p.trim());
                    if (adminService.deleteUser(uid))
                        successCount++;
                } catch (NumberFormatException ignored) {
                }
            }
            boolean ok = successCount > 0;
            respond(req, resp, isAjax, ok,
                    ok ? ("Deleted " + successCount + " users.") : "Failed to delete selected users.", loggedInUser);
            return;
        }

        respond(req, resp, isAjax, false, "Unsupported action.", loggedInUser);
    }

    private void populateUsersPage(HttpServletRequest req, UserModel loggedInUser) {
        req.setAttribute("users", adminService.getAllUsers());
        req.setAttribute("teacherCount", adminService.countUsersByRole("TEACHER"));
        req.setAttribute("studentCount", adminService.countUsersByRole("STUDENT"));
        req.setAttribute("pendingCount", adminService.countUsersByStatus("PENDING"));
        req.setAttribute("totalUsers", adminService.countAllUsers());
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
    }

    private void respond(HttpServletRequest req, HttpServletResponse resp, boolean isAjax, boolean success,
            String message,
            UserModel loggedInUser) throws ServletException, IOException {
        if (isAjax) {
            writeUsersJsonResponse(resp, success, message);
            return;
        }

        if (success) {
            req.setAttribute("success", message);
        } else {
            req.setAttribute("error", message);
        }
        populateUsersPage(req, loggedInUser);
        req.getRequestDispatcher("/WEB-INF/pages/admin/users.jsp").forward(req, resp);
    }

    private void writeUsersJsonResponse(HttpServletResponse resp, boolean success, String message) throws IOException {
        List<UserModel> users = adminService.getAllUsers();
        int teacherCount = adminService.countUsersByRole("TEACHER");
        int studentCount = adminService.countUsersByRole("STUDENT");
        int pendingCount = adminService.countUsersByStatus("PENDING");
        int totalUsers = adminService.countAllUsers();

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\",");
        json.append("\"teacherCount\":").append(teacherCount).append(",");
        json.append("\"studentCount\":").append(studentCount).append(",");
        json.append("\"pendingCount\":").append(pendingCount).append(",");
        json.append("\"totalUsers\":").append(totalUsers).append(",");
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
            json.append("\"status\":\"").append(escapeJson(user.getStatus())).append("\"");
            json.append("}");
        }

        json.append("]}");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(json.toString());
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
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
