package com.edustand.controllers;

import java.io.IOException;

import com.edustand.model.ContactRequestModel;
import com.edustand.model.UserModel;
import com.edustand.service.ContactRequestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/PanelContact" })
public class PanelContactController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ContactRequestService contactRequestService = new ContactRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("activeSidebar", "contact");
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.setAttribute("prefillName", loggedInUser.getFullName());
        req.setAttribute("prefillEmail", loggedInUser.getEmail());

        req.getRequestDispatcher("/WEB-INF/pages/panel/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String subject = trim(req.getParameter("subject"));
        String message = trim(req.getParameter("message"));

        if (fullName.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            req.setAttribute("error", "Please complete all required fields.");
            req.setAttribute("prefillName", fullName);
            req.setAttribute("prefillEmail", email);
            req.setAttribute("prefillSubject", subject);
            req.setAttribute("prefillMessage", message);
            req.setAttribute("activeSidebar", "contact");
            req.setAttribute("userName", loggedInUser.getFullName());
            req.setAttribute("userRole", loggedInUser.getRole());
            req.getRequestDispatcher("/WEB-INF/pages/panel/contact.jsp").forward(req, resp);
            return;
        }

        ContactRequestModel contactRequest = new ContactRequestModel();
        contactRequest.setUserId(loggedInUser.getUserId());
        contactRequest.setFullName(fullName);
        contactRequest.setEmail(email);
        contactRequest.setSubject(subject);
        contactRequest.setMessage(message);

        boolean saved = contactRequestService.createRequest(contactRequest);

        req.setAttribute(saved ? "success" : "error",
                saved ? "Your contact request has been sent successfully." : "Unable to submit request right now.");
        req.setAttribute("prefillName", loggedInUser.getFullName());
        req.setAttribute("prefillEmail", loggedInUser.getEmail());
        req.setAttribute("activeSidebar", "contact");
        req.setAttribute("userName", loggedInUser.getFullName());
        req.setAttribute("userRole", loggedInUser.getRole());
        req.getRequestDispatcher("/WEB-INF/pages/panel/contact.jsp").forward(req, resp);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
