package com.edustand.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.edustand.model.UserModel;

/** Routes the Admin to the dedicated Notices management page. */
@WebServlet(asyncSupported = true, urlPatterns = { "/AdminNotices" })
public class AdminNoticesController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) { resp.sendRedirect(req.getContextPath() + "/AdminDashboard"); return; }

        req.setAttribute("pageRole", "ADMIN");
        req.getRequestDispatcher("/WEB-INF/pages/admin/notices.jsp").forward(req, resp);
    }
}
