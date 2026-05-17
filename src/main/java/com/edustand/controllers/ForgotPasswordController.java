package com.edustand.controllers;

import java.io.IOException;
import com.edustand.service.ForgotPasswordService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Manages the multi-step OTP process for resetting a password.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/forgot-password" })
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ForgotPasswordService forgotPasswordService = new ForgotPasswordService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Load the beautiful forgot password view
        req.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"success\":false,\"message\":\"Missing action parameter\"}");
            return;
        }

        switch (action) {
            case "send_otp":
                handleSendOtp(req, resp);
                break;
            case "verify_otp":
                handleVerifyOtp(req, resp);
                break;
            case "reset_password":
                handleResetPassword(req, resp);
                break;
            default:
                resp.setStatus(400);
                resp.getWriter().write("{\"success\":false,\"message\":\"Invalid action\"}");
        }
    }

    private void handleSendOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Please enter your email address\"}");
            return;
        }

        String otp = forgotPasswordService.sendOtp(email);
        if (otp != null) {
            // Success: save email to session as pending verification
            HttpSession session = req.getSession(true);
            session.setAttribute("pendingResetEmail", email);
            resp.getWriter().write("{\"success\":true,\"message\":\"Verification code sent successfully!\"}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"This email ID is not registered in our system.\"}");
        }
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String pendingEmail = session == null ? null : (String) session.getAttribute("pendingResetEmail");
        if (pendingEmail == null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired. Please request a new OTP.\"}");
            return;
        }

        String otp = req.getParameter("otp");
        if (otp == null || otp.length() != 6) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Please enter a valid 6-digit code\"}");
            return;
        }

        boolean isValid = forgotPasswordService.verifyOtp(pendingEmail, otp);
        if (isValid) {
            session.setAttribute("otpVerified", true);
            resp.getWriter().write("{\"success\":true,\"message\":\"OTP verified! Please set your new password.\"}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired verification code\"}");
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("pendingResetEmail") == null || session.getAttribute("otpVerified") == null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Unauthorized. Please verify your OTP first.\"}");
            return;
        }

        String email = (String) session.getAttribute("pendingResetEmail");
        String password = req.getParameter("password");
        if (password == null || password.length() < 6) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Password must be at least 6 characters long\"}");
            return;
        }

        boolean success = forgotPasswordService.resetPassword(email, password);
        if (success) {
            // Reset successful: invalidate session so it is clean
            session.invalidate();
            resp.getWriter().write("{\"success\":true,\"message\":\"Password reset successful! You can now log in.\"}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Failed to reset password. Please try again.\"}");
        }
    }
}