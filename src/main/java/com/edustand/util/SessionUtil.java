package com.edustand.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for managing HTTP sessions. 
 * Provides methods to set, get, remove session attributes and invalidate sessions.
 */
public class SessionUtil {

    // Sets a value in the session (e.g., storing the logged-in user's ID or Role)
    public static void setAttribute(HttpServletRequest request, String key, Object value) {
        // request.getSession() creates a new session if one doesn't exist
        HttpSession session = request.getSession();
        session.setAttribute(key, value);
    }

    // Retrieves a value from the session
    public static Object getAttribute(HttpServletRequest request, String key) {
        // getSession(false) returns the current session, or null if none exists
        HttpSession session = request.getSession(false);
        if (session != null) {
            return session.getAttribute(key);
        }
        return null;
    }

    // Destroys the session entirely (used for Logging Out)
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}