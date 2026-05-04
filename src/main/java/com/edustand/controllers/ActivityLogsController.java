package com.edustand.controllers;

import java.io.IOException;
import java.util.List;

import com.edustand.model.ActivityLogModel;
import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = { "/AdminActivityLogs" })
public class ActivityLogsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ActivityLogService activityLogService = new ActivityLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        List<ActivityLogModel> logs;

        if ("by_action".equals(action)) {
            String actionType = req.getParameter("actionType");
            logs = activityLogService.getLogsByAction(actionType);
        } else {
            logs = activityLogService.getAllLogs();
        }

        req.setAttribute("activeSidebar", "activityLogs");
        req.setAttribute("logs", logs);
        req.setAttribute("totalLogs", activityLogService.countLogs());
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.getRequestDispatcher("/WEB-INF/pages/admin/activityLogs.jsp").forward(req, resp);
    }
}
