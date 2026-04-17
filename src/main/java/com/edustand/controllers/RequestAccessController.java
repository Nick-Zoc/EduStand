package com.edustand.controllers;

import java.io.IOException;

import com.edustand.model.UserModel;
import com.edustand.service.AdminService;
import com.edustand.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/request-access" })
public class RequestAccessController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        consumeFlashAttributes(req);
        req.getRequestDispatcher("/WEB-INF/pages/request-access.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String roleInput = trim(req.getParameter("role"));
        String reason = trim(req.getParameter("reason"));

        if (fullName.isEmpty() || email.isEmpty() || roleInput.isEmpty() || reason.isEmpty()) {
            storeFlashAttributes(req, "Please complete all required fields.", fullName, email, roleInput, reason,
                    false);
            resp.sendRedirect(req.getContextPath() + "/request-access");
            return;
        }

        if (!"student".equalsIgnoreCase(roleInput) && !"teacher".equalsIgnoreCase(roleInput)) {
            storeFlashAttributes(req, "Please choose a valid role.", fullName, email, roleInput, reason, false);
            resp.sendRedirect(req.getContextPath() + "/request-access");
            return;
        }

        if (adminService.findUserByEmail(email) != null) {
            storeFlashAttributes(req, "An account or request with this email already exists.", fullName, email,
                    roleInput, reason, false);
            resp.sendRedirect(req.getContextPath() + "/request-access");
            return;
        }

        String normalizedRole = "teacher".equalsIgnoreCase(roleInput) ? "TEACHER" : "STUDENT";
        String temporaryPasswordHash = PasswordUtil.hashPassword("TEMP-" + System.currentTimeMillis());

        UserModel requestUser = new UserModel(fullName, email, temporaryPasswordHash, normalizedRole, "PENDING");
        requestUser.setRequestReason(reason);
        boolean saved = adminService.addUser(requestUser);

        if (saved) {
            storeFlashAttributes(req, "Request submitted successfully. Admin will review your access request.", null,
                    null, null, null, true);
        } else {
            storeFlashAttributes(req, "Unable to submit request at the moment. Please try again.", fullName, email,
                    roleInput, reason, false);
        }

        resp.sendRedirect(req.getContextPath() + "/request-access");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void consumeFlashAttributes(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            req.setAttribute("formFullName", "");
            req.setAttribute("formEmail", "");
            req.setAttribute("formRole", "");
            req.setAttribute("formReason", "");
            return;
        }

        req.setAttribute("success", session.getAttribute("requestAccessSuccess"));
        req.setAttribute("error", session.getAttribute("requestAccessError"));
        req.setAttribute("formFullName", session.getAttribute("requestAccessFullName"));
        req.setAttribute("formEmail", session.getAttribute("requestAccessEmail"));
        req.setAttribute("formRole", session.getAttribute("requestAccessRole"));
        req.setAttribute("formReason", session.getAttribute("requestAccessReason"));

        session.removeAttribute("requestAccessSuccess");
        session.removeAttribute("requestAccessError");
        session.removeAttribute("requestAccessFullName");
        session.removeAttribute("requestAccessEmail");
        session.removeAttribute("requestAccessRole");
        session.removeAttribute("requestAccessReason");
    }

    private void storeFlashAttributes(HttpServletRequest req, String message, String fullName, String email,
            String role, String reason, boolean success) {
        HttpSession session = req.getSession(true);
        if (success) {
            session.setAttribute("requestAccessSuccess", message);
            session.removeAttribute("requestAccessError");
            session.removeAttribute("requestAccessFullName");
            session.removeAttribute("requestAccessEmail");
            session.removeAttribute("requestAccessRole");
            session.removeAttribute("requestAccessReason");
            return;
        }

        session.setAttribute("requestAccessError", message);
        session.setAttribute("requestAccessFullName", fullName);
        session.setAttribute("requestAccessEmail", email);
        session.setAttribute("requestAccessRole", role);
        session.setAttribute("requestAccessReason", reason);
        session.removeAttribute("requestAccessSuccess");
    }
}