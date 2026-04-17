package com.edustand.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles routing and data processing for the Admin Dashboard.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/AdminDashboard" }) // Matches your old router [cite: 637]
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Loads the Admin Dashboard UI
        req.getRequestDispatcher("/WEB-INF/pages/admin/adminDashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO for next phase: 
        // 1. Catch the 'action' parameter to see if the admin is trying to "add_user", "edit_user", or "delete_user".
        // 2. Grab the input fields (name, email, password, role).
        // 3. Pass the raw password through our Bcrypt PasswordUtil.
        // 4. Send the data to an AdminService class to run the SQL INSERT query.
    }
}