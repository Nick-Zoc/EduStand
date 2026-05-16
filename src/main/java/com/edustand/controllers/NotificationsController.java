package com.edustand.controllers;

import java.io.IOException;
import java.util.List;

import com.edustand.model.ContactRequestModel;
import com.edustand.model.UserModel;
import com.edustand.service.ContactRequestService;
import com.edustand.service.NoticeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Shared notifications endpoint accessible by ALL authenticated roles.
 *
 * GET  /notifications?action=get_json
 *   - ADMIN  → returns recent contact requests (unread count + list)
 *   - TEACHER/STUDENT → returns recent active notices as notification items
 *
 * POST /notifications?action=mark_all_read
 *   - ADMIN only: marks all contact requests as read
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/notifications" })
public class NotificationsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ContactRequestService contactRequestService = new ContactRequestService();
    private final NoticeService noticeService = new NoticeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.setStatus(401);
            writeJson(resp, "{\"error\":\"Unauthorized\"}");
            return;
        }

        String action = req.getParameter("action");
        if (!"get_json".equals(action)) {
            resp.setStatus(400);
            writeJson(resp, "{\"error\":\"Invalid action\"}");
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            // Admin sees contact requests as notifications
            List<ContactRequestModel> requests = contactRequestService.getAllRequests();
            int unreadCount = contactRequestService.countByReadStatus("UNREAD");

            StringBuilder json = new StringBuilder("{\"unreadCount\":").append(unreadCount).append(",\"requests\":[");
            for (int i = 0; i < requests.size(); i++) {
                ContactRequestModel r = requests.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"requestId\":").append(r.getRequestId()).append(",")
                    .append("\"fullName\":\"").append(escapeJson(r.getFullName())).append("\",")
                    .append("\"email\":\"").append(escapeJson(r.getEmail())).append("\",")
                    .append("\"subject\":\"").append(escapeJson(r.getSubject())).append("\",")
                    .append("\"readStatus\":\"").append(r.getReadStatus()).append("\",")
                    .append("\"createdAt\":\"").append(r.getCreatedAt()).append("\"")
                    .append("}");
            }
            json.append("]}");
            resp.getWriter().write(json.toString());

        } else {
            // Teachers and Students see active notices as notifications
            String noticesJson = noticeService.getRecentNoticesAsJson(8);
            // noticesJson is already a JSON array — wrap it in the expected shape
            resp.getWriter().write("{\"unreadCount\":0,\"notices\":" + noticesJson + "}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.setStatus(401);
            writeJson(resp, "{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        String action = req.getParameter("action");
        if ("mark_all_read".equals(action) && "ADMIN".equalsIgnoreCase(user.getRole())) {
            boolean ok = contactRequestService.markAllAsRead();
            writeJson(resp, ok ? "{\"success\":true}" : "{\"success\":false}");
        } else {
            resp.setStatus(400);
            writeJson(resp, "{\"success\":false,\"message\":\"Invalid action or insufficient role\"}");
        }
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(json);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
