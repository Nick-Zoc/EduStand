package com.edustand.controllers;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.edustand.model.UserModel;
import com.edustand.service.AssignmentService;
import com.edustand.service.NoticeService;
import com.edustand.service.ResourceService;

@WebServlet(asyncSupported = true, urlPatterns = { "/StudentDashboard" })
public class StudentDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!"STUDENT".equalsIgnoreCase(loggedInUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + resolveDashboardByRole(loggedInUser.getRole()));
            return;
        }

        // Pass real data to the view
        AssignmentService assignmentService = new AssignmentService();
        ResourceService resourceService = new ResourceService();
        NoticeService noticeService = new NoticeService();

        // Student-specific: assignments with their submission status and scores
        String assignmentsJson = assignmentService.getStudentAssignmentsAsJson(loggedInUser.getUserId());
        // Recent resources
        String resourcesJson = resourceService.getAllResourcesAsJson();
        // Recent notices
        String noticesJson = noticeService.getRecentNoticesAsJson(5);

        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.setAttribute("assignmentsJson", assignmentsJson);
        req.setAttribute("resourcesJson", resourcesJson);
        req.setAttribute("noticesJson", noticesJson);
        req.getRequestDispatcher("/WEB-INF/pages/student/studentDashboard.jsp").forward(req, resp);
    }

    private String resolveDashboardByRole(String role) {
        if ("ADMIN".equalsIgnoreCase(role)) return "/AdminDashboard";
        if ("TEACHER".equalsIgnoreCase(role)) return "/TeacherDashboard";
        return "/StudentDashboard";
    }
}