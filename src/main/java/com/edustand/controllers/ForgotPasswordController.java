package com.edustand.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Manages the multi-step OTP process for resetting a password.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/forgot-password" })
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Just loads the UI where they enter their email
        req.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO for next phase (The OTP Logic):
        // 1. Check if the request is an AJAX call asking to "send_otp" or "verify_otp".
        // 2. If "send_otp": Generate a 6-digit random string. 
        //    - Save it to the database with a 10-minute expiration timestamp.
        //    - Use JavaMail API to email it to the user.
        // 3. If "verify_otp": Compare the code they typed with the database.
        //    - If valid, let them set a new password, run it through Bcrypt, and UPDATE the DB.
    }
}