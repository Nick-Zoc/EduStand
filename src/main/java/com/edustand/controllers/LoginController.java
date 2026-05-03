package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.edustand.model.UserModel;
import com.edustand.service.LoginService;
import com.edustand.service.RememberMeService;
import com.edustand.util.CookieUtil;
import com.edustand.util.SessionUtil;
import com.edustand.util.RememberMeUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Instantiate our service to talk to the database
    private LoginService loginService = new LoginService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie rememberedEmail = CookieUtil.getCookie(req, "rememberedEmail");
        if (rememberedEmail != null && rememberedEmail.getValue() != null && !rememberedEmail.getValue().isBlank()) {
            req.setAttribute("rememberedEmail", rememberedEmail.getValue());
            req.setAttribute("rememberChecked", true);
        }
        // If they just visit /login, show them the login page
        req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Grab the data the user typed into the HTML form
        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            email = req.getParameter("username");
        }
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe");
        if (rememberMe == null) {
            rememberMe = req.getParameter("remember");
        }

        // 2. Ask the LoginService to verify the credentials
        UserModel loggedInUser = loginService.authenticateUser(email, password);

        if (loggedInUser != null) {
            // SUCCESS! The credentials are valid.

            // 3. Create a Session and store the user's data in it
            SessionUtil.setAttribute(req, "loggedInUser", loggedInUser);
            SessionUtil.setAttribute(req, "userRole", loggedInUser.getRole());

            // 4. Handle "Remember Me" (Token valid for 30 days)
            if (isRememberMeSelected(rememberMe)) {
                RememberMeService rmService = new RememberMeService();
                String token = rmService.createToken(loggedInUser.getUserId());
                if (token != null) {
                    CookieUtil.addCookie(resp, "rememberMeToken", token, 60 * 60 * 24 * 30);
                }
                CookieUtil.addCookie(resp, "rememberedEmail", email, 60 * 60 * 24 * 30);
            } else {
                CookieUtil.deleteCookie(resp, "rememberedEmail");
                CookieUtil.deleteCookie(resp, "rememberMeToken");
            }

            // 5. Role-based routing: Send them to the correct dashboard
            String role = loggedInUser.getRole();
            if (role.equals("ADMIN")) {
                resp.sendRedirect(req.getContextPath() + "/AdminDashboard");
            } else if (role.equals("TEACHER")) {
                resp.sendRedirect(req.getContextPath() + "/TeacherDashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/StudentDashboard");
            }

        } else {
            // FAILURE! Bad email or password.

            // Send an error message back to the JSP to display to the user
            req.setAttribute("error", "Invalid email or password. Please try again.");

            // Forward them back to the login page so they can try again
            req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
        }
    }

    private boolean isRememberMeSelected(String rememberMeValue) {
        if (rememberMeValue == null) {
            return false;
        }
        String normalized = rememberMeValue.trim().toLowerCase();
        return "on".equals(normalized) || "true".equals(normalized) || "1".equals(normalized);
    }
}