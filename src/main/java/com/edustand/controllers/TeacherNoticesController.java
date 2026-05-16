package com.edustand.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.edustand.model.UserModel;

/** Routes a Teacher to their dedicated Notices management page. */
@WebServlet(asyncSupported = true, urlPatterns = { "/TeacherNotices" })
public class TeacherNoticesController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!"TEACHER".equalsIgnoreCase(user.getRole())) { resp.sendRedirect(req.getContextPath() + "/TeacherDashboard"); return; }

        req.setAttribute("pageRole", "TEACHER");
        req.getRequestDispatcher("/WEB-INF/pages/teacher/notices.jsp").forward(req, resp);
    }
}
