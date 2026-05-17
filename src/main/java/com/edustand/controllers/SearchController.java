package com.edustand.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;
import com.edustand.util.QueryUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Global Search Controller.
 * Resolves searches differently depending on the user's role.
 */
@WebServlet("/search")
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String q = req.getParameter("q");
        String safeQ = QueryUtil.likeWrap(q);
        
        req.setAttribute("searchQuery", q);

        if (safeQ == null || q.isBlank()) {
            req.setAttribute("results", new ArrayList<>());
            req.getRequestDispatcher("/WEB-INF/pages/searchResults.jsp").forward(req, resp);
            return;
        }

        List<Map<String, Object>> results = new ArrayList<>();

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            // Admin searches users (including by role)
            String sql = "SELECT user_id, full_name, email, role, status FROM Users WHERE full_name LIKE ? OR email LIKE ? OR role LIKE ? ORDER BY created_at DESC LIMIT 50";
            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, safeQ);
                stmt.setString(2, safeQ);
                stmt.setString(3, safeQ);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("type", "User");
                        map.put("title", rs.getString("full_name"));
                        map.put("subtitle", rs.getString("email"));
                        map.put("badge", rs.getString("role"));
                        map.put("url", req.getContextPath() + "/users"); // Route them to users page
                        results.add(map);
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }

        } else {
            // Teacher / Student searches Resources and Assignments
            String resSql = "SELECT resource_id, title, file_type, category FROM Resources WHERE title LIKE ? OR description LIKE ? LIMIT 25";
            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(resSql)) {
                stmt.setString(1, safeQ);
                stmt.setString(2, safeQ);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("type", "Resource");
                        map.put("title", rs.getString("title"));
                        map.put("subtitle", rs.getString("category"));
                        map.put("badge", rs.getString("file_type"));
                        String folderName = rs.getString("category");
                        String encodedFolder = java.net.URLEncoder.encode(folderName != null ? folderName : "", java.nio.charset.StandardCharsets.UTF_8.toString());
                        map.put("url", req.getContextPath() + ("TEACHER".equals(user.getRole()) ? "/TeacherClassroom" : "/StudentClassroom") + "?folder=" + encodedFolder);
                        results.add(map);
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }

            String assigSql = "SELECT assignment_id, title, due_date FROM Assignments WHERE title LIKE ? LIMIT 25";
            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(assigSql)) {
                stmt.setString(1, safeQ);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("type", "Assignment");
                        map.put("title", rs.getString("title"));
                        map.put("subtitle", "Due: " + rs.getString("due_date"));
                        map.put("badge", "Task");
                        map.put("url", req.getContextPath() + ("TEACHER".equals(user.getRole()) ? "/TeacherClassroom?tab=assignments" : "/StudentClassroom?tab=assignments"));
                        results.add(map);
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }
        }

        req.setAttribute("results", results);
        req.getRequestDispatcher("/WEB-INF/pages/searchResults.jsp").forward(req, resp);
    }
}
