package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.edustand.model.UserModel;

@WebServlet(asyncSupported = true, urlPatterns = { "/" })
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = loggedInUser.getRole();
        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/AdminDashboard");
        } else if ("TEACHER".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/TeacherDashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/StudentDashboard");
        }
    }
}
