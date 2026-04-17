package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.edustand.model.UserModel;
import com.edustand.service.AdminService;

/**
 * Handles routing and data processing for the Admin Dashboard.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/AdminDashboard" }) // Matches your old router [cite: 637]
public class AdminDashboardController extends HttpServlet {
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

        if (!"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            if ("TEACHER".equalsIgnoreCase(loggedInUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/TeacherDashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/StudentDashboard");
            }
            return;
        }

        req.setAttribute("teacherCount", adminService.countUsersByRole("TEACHER"));
        req.setAttribute("studentCount", adminService.countUsersByRole("STUDENT"));
        req.setAttribute("pendingCount", adminService.countUsersByStatus("PENDING"));

        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());

        req.getRequestDispatcher("/WEB-INF/pages/admin/adminDashboard.jsp").forward(req, resp);
    }
}