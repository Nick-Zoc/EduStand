package com.edustand.controllers;

import java.io.IOException;
import java.util.List;

import com.edustand.model.ContactRequestModel;
import com.edustand.model.UserModel;
import com.edustand.service.ContactRequestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/AdminContactRequests" })
public class AdminContactRequestsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ContactRequestService contactRequestService = new ContactRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("data".equals(req.getParameter("action"))) {
            writeJson(resp, true, "Requests loaded.");
            return;
        }

        req.setAttribute("activeSidebar", "contactRequests");
        req.setAttribute("requests", contactRequestService.getAllRequests());
        req.setAttribute("unreadCount", contactRequestService.countByReadStatus("UNREAD"));
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.getRequestDispatcher("/WEB-INF/pages/admin/contactRequests.jsp").forward(req, resp);
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
        int requestId;
        try {
            requestId = Integer.parseInt(req.getParameter("requestId"));
        } catch (Exception e) {
            writeJson(resp, false, "Invalid request id.");
            return;
        }

        ContactRequestModel current = contactRequestService.findById(requestId);
        if (current == null) {
            writeJson(resp, false, "Request not found.");
            return;
        }

        String readStatus = current.getReadStatus();
        String requestStatus = current.getRequestStatus();
        String adminResponse = trim(req.getParameter("adminResponse"));
        boolean emailNotified = current.isEmailNotified();

        if ("mark_read".equals(action)) {
            readStatus = "READ";
        } else if ("mark_unread".equals(action)) {
            readStatus = "UNREAD";
        } else if ("mark_pending".equals(action)) {
            requestStatus = "PENDING";
        } else if ("mark_fixed".equals(action)) {
            requestStatus = "FIXED";
            readStatus = "READ";
            emailNotified = true;
            if (adminResponse.isEmpty()) {
                adminResponse = "Issue resolved by admin. Follow-up completed.";
            }
        } else if ("save_note".equals(action)) {
            if (adminResponse.isEmpty()) {
                adminResponse = current.getAdminResponse();
            }
        } else {
            writeJson(resp, false, "Unsupported action.");
            return;
        }

        boolean updated = contactRequestService.updateRequest(requestId, readStatus, requestStatus, adminResponse,
                emailNotified);
        if (!updated) {
            writeJson(resp, false, "Failed to update request.");
            return;
        }

        String message = "Request updated.";
        if ("mark_fixed".equals(action)) {
            message = "Request marked as fixed and notification queued to " + current.getEmail() + ".";
        }
        writeJson(resp, true, message);
    }

    private void writeJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        List<ContactRequestModel> requests = contactRequestService.getAllRequests();
        int unreadCount = contactRequestService.countByReadStatus("UNREAD");

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\",");
        json.append("\"unreadCount\":").append(unreadCount).append(",");
        json.append("\"requests\":[");

        for (int i = 0; i < requests.size(); i++) {
            ContactRequestModel request = requests.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{");
            json.append("\"requestId\":").append(request.getRequestId()).append(",");
            json.append("\"fullName\":\"").append(escapeJson(request.getFullName())).append("\",");
            json.append("\"email\":\"").append(escapeJson(request.getEmail())).append("\",");
            json.append("\"subject\":\"").append(escapeJson(request.getSubject())).append("\",");
            json.append("\"message\":\"").append(escapeJson(request.getMessage())).append("\",");
            json.append("\"readStatus\":\"").append(escapeJson(request.getReadStatus())).append("\",");
            json.append("\"requestStatus\":\"").append(escapeJson(request.getRequestStatus())).append("\",");
            json.append("\"adminResponse\":\"").append(escapeJson(request.getAdminResponse())).append("\",");
            json.append("\"emailNotified\":").append(request.isEmailNotified());
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
