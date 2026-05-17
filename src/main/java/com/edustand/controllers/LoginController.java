package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;
import com.edustand.service.LoginService;
import com.edustand.service.RememberMeService;
import com.edustand.util.CookieUtil;
import com.edustand.util.SessionUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Instantiate our service to talk to the database
    private LoginService loginService = new LoginService();
    private final ActivityLogService activityLogService = new ActivityLogService();

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
        String email = req.getParameter("email");
        if (email == null || email.isBlank()) email = req.getParameter("username");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe");
        if (rememberMe == null) rememberMe = req.getParameter("remember");

        // Use the new structured authenticate() method
        LoginService.AuthResult result = loginService.authenticate(email, password);

        switch (result.status) {
            case SUCCESS:
                UserModel loggedInUser = result.user;

                SessionUtil.setAttribute(req, "loggedInUser", loggedInUser);
                SessionUtil.setAttribute(req, "userRole", loggedInUser.getRole());

                if (isRememberMeSelected(rememberMe)) {
                    RememberMeService rmService = new RememberMeService();
                    String token = rmService.createToken(loggedInUser.getUserId());
                    if (token != null) CookieUtil.addCookie(resp, "rememberMeToken", token, 60 * 60 * 24 * 30);
                    CookieUtil.addCookie(resp, "rememberedEmail", email, 60 * 60 * 24 * 30);
                } else {
                    CookieUtil.deleteCookie(resp, "rememberedEmail");
                    CookieUtil.deleteCookie(resp, "rememberMeToken");
                }

                activityLogService.logActivity(loggedInUser.getUserId(), "LOGIN",
                        "Logged in as " + loggedInUser.getRole());

                String role = loggedInUser.getRole();
                if ("ADMIN".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/AdminDashboard");
                } else if ("TEACHER".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/TeacherDashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/StudentDashboard");
                }
                break;

            case ACCOUNT_LOCKED:
                String unlockTime = result.lockedUntil != null
                        ? new java.text.SimpleDateFormat("HH:mm").format(result.lockedUntil)
                        : "soon";
                req.setAttribute("error",
                        "Your account has been temporarily locked after 5 failed attempts. Please try again after " + unlockTime + ".");
                req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
                break;

            case WRONG_PASSWORD:
                String attemptsMsg = result.remainingAttempts > 0
                        ? " You have " + result.remainingAttempts + " attempt(s) remaining before your account is locked."
                        : " Your account has been locked for 10 minutes.";
                req.setAttribute("error", "Invalid email or password." + attemptsMsg);
                req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
                break;

            case ACCOUNT_INACTIVE:
                req.setAttribute("error", "Your account is inactive. Please contact an administrator to activate your account.");
                req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
                break;

            case USER_NOT_FOUND:
            default:
                req.setAttribute("error", "Invalid email or password. Please try again.");
                req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
                break;
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