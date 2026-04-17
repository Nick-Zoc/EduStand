package com.edustand.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for managing browser Cookies.
 */
public class CookieUtil {

    // Creates a cookie and sends it to the user's browser
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAgeInSeconds) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAgeInSeconds); // How long until the cookie expires
        cookie.setPath("/"); // Makes the cookie readable across the entire application
        response.addCookie(cookie);
    }

    // Searches the user's browser for a specific cookie by name
    public static Cookie getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return cookie;
                }
            }
        }
        return null;
    }

    // Deletes a cookie (used during Logout if they chose "Remember Me")
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, null);
        cookie.setMaxAge(0); // Setting age to 0 instantly deletes it
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}