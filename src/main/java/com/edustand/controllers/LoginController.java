package com.edustand.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.edustand.model.UserModel;
import com.edustand.service.LoginService;
import com.edustand.util.CookieUtil;
import com.edustand.util.SessionUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Instantiate our service to talk to the database
    private LoginService loginService = new LoginService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If they just visit /login, show them the login page
        req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Grab the data the user typed into the HTML form
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe"); // Checkbox from your HTML

        // 2. Ask the LoginService to verify the credentials
        UserModel loggedInUser = loginService.authenticateUser(email, password);

        if (loggedInUser != null) {
            // SUCCESS! The credentials are valid.
            
            // 3. Create a Session and store the user's data in it
            SessionUtil.setAttribute(req, "loggedInUser", loggedInUser);
            SessionUtil.setAttribute(req, "userRole", loggedInUser.getRole());

            // 4. Handle "Remember Me" (Cookie lasts for 30 days)
            if (rememberMe != null && rememberMe.equals("on")) {
                CookieUtil.addCookie(resp, "rememberedEmail", email, 60 * 60 * 24 * 30);
            }

            // 5. Role-based routing: Send them to the correct dashboard
            String role = loggedInUser.getRole();
            if (role.equals("ADMIN")) {
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            } else if (role.equals("TEACHER")) {
                resp.sendRedirect(req.getContextPath() + "/teacher-dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student-dashboard");
            }

        } else {
            // FAILURE! Bad email or password.
            
            // Send an error message back to the JSP to display to the user
            req.setAttribute("error", "Invalid email or password. Please try again.");
            
            // Forward them back to the login page so they can try again
            req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
        }
    }
}