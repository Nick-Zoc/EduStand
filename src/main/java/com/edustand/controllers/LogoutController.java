package com.edustand.controllers;

import java.io.IOException;

import com.edustand.model.UserModel;
import com.edustand.service.RememberMeService;
import com.edustand.util.CookieUtil;
import com.edustand.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(asyncSupported = true, urlPatterns = { "/logout" })
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get user before invalidating session
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (loggedInUser != null) {
            // Invalidate all Remember Me tokens for this user
            RememberMeService rmService = new RememberMeService();
            rmService.invalidateUserTokens(loggedInUser.getUserId());
        }

        // Invalidate session and clear remember-me cookies
        SessionUtil.invalidateSession(req);
        CookieUtil.deleteCookie(resp, "rememberMeToken");
        CookieUtil.deleteCookie(resp, "rememberedEmail");

        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
