package com.edustand.controllers;

import java.io.IOException;

import com.edustand.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/PanelAbout" })
public class PanelAboutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("activeSidebar", "about");
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());

        req.getRequestDispatcher("/WEB-INF/pages/panel/about.jsp").forward(req, resp);
    }
}
