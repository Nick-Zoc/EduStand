package com.edustand.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Technical Test Endpoint to trigger custom 404 and 500 error pages
 * to assist in coursework report documentation and testing screenshots.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/error-test" })
public class ErrorTestController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");

        if ("404".equals(code)) {
            // Programmatically triggers the container-level 404 Not Found error
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Testing Custom 404 page");
        } else if ("500".equals(code)) {
            // Programmatically triggers a server-side runtime exception,
            // which forces Tomcat to invoke the 500 error-page handler.
            throw new RuntimeException("Coursework Report Demonstration: Testing Custom 500 Internal Server Error");
        } else {
            // Default response helper screen
            resp.setContentType("text/html");
            resp.getWriter().write("<html><body style='font-family:sans-serif; padding: 2rem; max-width: 600px; margin: 0 auto; line-height: 1.6;'>"
                + "<h2 style='color:#0f172a;'>EduStand Error Page Testing Panel</h2>"
                + "<p>Click the links below to trigger the custom, premium-styled error pages for your coursework screenshots:</p>"
                + "<ul style='padding-left: 1.5rem;'>"
                + "  <li style='margin-bottom: 0.8rem;'><a href='" + req.getContextPath() + "/error-test?code=404' target='_blank' style='color:#3b82f6; text-decoration:none; font-weight:600;'>Trigger Custom 404 Page &rarr;</a></li>"
                + "  <li style='margin-bottom: 0.8rem;'><a href='" + req.getContextPath() + "/error-test?code=500' target='_blank' style='color:#ef4444; text-decoration:none; font-weight:600;'>Trigger Custom 500 Page &rarr;</a></li>"
                + "</ul>"
                + "<p style='color:#64748b; font-size: 0.9rem; margin-top: 2rem;'>Note: You can also naturally trigger 404 by visiting any random non-existent URL (e.g. <code>" + req.getContextPath() + "/doesnotexist</code>).</p>"
                + "</body></html>");
        }
    }
}
