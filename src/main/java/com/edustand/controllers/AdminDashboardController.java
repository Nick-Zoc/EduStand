package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;
import com.edustand.service.AdminService;
import com.edustand.service.ContactRequestService;

import com.edustand.service.NoticeService;

/**
 * Handles routing and data processing for the Admin Dashboard.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/AdminDashboard" }) // Matches your old router [cite: 637]
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AdminService adminService = new AdminService();
    private final ContactRequestService contactRequestService = new ContactRequestService();
    private final ActivityLogService activityLogService = new ActivityLogService();
    private final NoticeService noticeService = new NoticeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            if ("TEACHER".equalsIgnoreCase(loggedInUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/TeacherDashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/StudentDashboard");
            }
            return;
        }

        int teacherCount = adminService.countUsersByRole("TEACHER");
        int studentCount = adminService.countUsersByRole("STUDENT");
        int adminCount   = adminService.countUsersByRole("ADMIN");

        req.setAttribute("teacherCount", teacherCount);
        req.setAttribute("studentCount", studentCount);
        req.setAttribute("pendingCount", adminService.countUsersByStatus("PENDING"));
        req.setAttribute("totalUsers", adminService.countAllUsers());
        req.setAttribute("inactiveCount", adminService.countUsersByStatus("INACTIVE"));
        req.setAttribute("unreadContactCount", contactRequestService.countByReadStatus("UNREAD"));
        // Show only 5 recent logs — makes room for notices panel side by side
        req.setAttribute("recentLogs", activityLogService.getRecentLogs(5));
        // Notices for the notice panel
        req.setAttribute("noticesJson", noticeService.getRecentNoticesAsJson(5));
        // Chart data: role distribution as simple JSON for Chart.js
        req.setAttribute("chartRoleData", "[" + adminCount + "," + teacherCount + "," + studentCount + "]");

        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());

        req.getRequestDispatcher("/WEB-INF/pages/admin/adminDashboard.jsp").forward(req, resp);
    }
}