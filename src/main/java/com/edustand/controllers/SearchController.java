package com.edustand.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;
import com.edustand.util.SearchAndSortUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Global Search Controller.
 * Resolves searches in memory using Linear Search (unsorted filter) and Merge Sort algorithms.
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
        req.setAttribute("searchQuery", q);

        if (q == null || q.isBlank()) {
            req.setAttribute("results", new ArrayList<>());
            req.getRequestDispatcher("/WEB-INF/pages/searchResults.jsp").forward(req, resp);
            return;
        }

        String qLower = q.trim().toLowerCase();
        List<Map<String, Object>> results = new ArrayList<>();

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            // ADMIN searches users. Load ALL users from DB and filter/sort in Java!
            List<Map<String, Object>> allUsers = new ArrayList<>();
            String sql = "SELECT user_id, full_name, email, role, status, created_at FROM Users";
            
            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("type", "User");
                    map.put("title", rs.getString("full_name"));
                    map.put("subtitle", rs.getString("email"));
                    map.put("badge", rs.getString("role"));
                    map.put("url", req.getContextPath() + "/users");
                    map.put("created_at", rs.getTimestamp("created_at"));
                    allUsers.add(map);
                }
            } catch (Exception e) {
                System.err.println("[ERROR] Failed to fetch users for search: " + e.getMessage());
                e.printStackTrace();
            }

            // 1. Custom Linear Search in Java
            List<Map<String, Object>> filteredUsers = SearchAndSortUtil.linearSearch(allUsers, u -> {
                String fullName = (String) u.get("title");
                String email = (String) u.get("subtitle");
                String role = (String) u.get("badge");
                return (fullName != null && fullName.toLowerCase().contains(qLower)) ||
                       (email != null && email.toLowerCase().contains(qLower)) ||
                       (role != null && role.toLowerCase().contains(qLower));
            });

            // 2. Custom Merge Sort in Java (Order by created_at DESC)
            SearchAndSortUtil.mergeSort(filteredUsers, (u1, u2) -> {
                Timestamp t1 = (Timestamp) u1.get("created_at");
                Timestamp t2 = (Timestamp) u2.get("created_at");
                if (t1 == null && t2 == null) return 0;
                if (t1 == null) return 1;
                if (t2 == null) return -1;
                return t2.compareTo(t1); // Descending
            });

            // Limit results to 50
            results = filteredUsers.subList(0, Math.min(filteredUsers.size(), 50));

        } else {
            // TEACHER / STUDENT searches Resources and Assignments. Filter/sort in Java!
            List<Map<String, Object>> allResources = new ArrayList<>();
            String resSql = "SELECT resource_id, title, file_type, category, description, upload_date FROM Resources";
            
            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(resSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("type", "Resource");
                    map.put("title", rs.getString("title"));
                    map.put("subtitle", rs.getString("category"));
                    map.put("badge", rs.getString("file_type"));
                    
                    String folderName = rs.getString("category");
                    String encodedFolder = "";
                    if (folderName != null) {
                        encodedFolder = java.net.URLEncoder.encode(folderName, "UTF-8");
                    }
                    map.put("url", req.getContextPath() + ("TEACHER".equals(user.getRole()) ? "/TeacherClassroom" : "/StudentClassroom") + "?folder=" + encodedFolder);
                    map.put("description", rs.getString("description"));
                    map.put("upload_date", rs.getTimestamp("upload_date"));
                    allResources.add(map);
                }
            } catch (Exception e) {
                System.err.println("[ERROR] Failed to fetch resources for search: " + e.getMessage());
                e.printStackTrace();
            }

            // 1. Custom Linear Search for Resources
            List<Map<String, Object>> filteredResources = SearchAndSortUtil.linearSearch(allResources, r -> {
                String title = (String) r.get("title");
                String description = (String) r.get("description");
                return (title != null && title.toLowerCase().contains(qLower)) ||
                       (description != null && description.toLowerCase().contains(qLower));
            });

            // 2. Custom Merge Sort for Resources (Order by upload_date DESC)
            SearchAndSortUtil.mergeSort(filteredResources, (r1, r2) -> {
                Timestamp t1 = (Timestamp) r1.get("upload_date");
                Timestamp t2 = (Timestamp) r2.get("upload_date");
                if (t1 == null && t2 == null) return 0;
                if (t1 == null) return 1;
                if (t2 == null) return -1;
                return t2.compareTo(t1); // Descending
            });

            // Slice Resources to 25 max
            List<Map<String, Object>> resourcesSlice = filteredResources.subList(0, Math.min(filteredResources.size(), 25));

            // Load all assignments
            List<Map<String, Object>> allAssignments = new ArrayList<>();
            String assigSql = "SELECT assignment_id, title, due_date FROM Assignments";

            try (Connection conn = DbConfig.getDbConnection();
                 PreparedStatement stmt = conn.prepareStatement(assigSql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("type", "Assignment");
                    map.put("title", rs.getString("title"));
                    map.put("subtitle", "Due: " + rs.getString("due_date"));
                    map.put("badge", "Task");
                    map.put("url", req.getContextPath() + ("TEACHER".equals(user.getRole()) ? "/TeacherClassroom?tab=assignments" : "/StudentClassroom?tab=assignments"));
                    
                    // Parse due_date for sorting
                    String dueDateStr = rs.getString("due_date");
                    map.put("due_date_str", dueDateStr != null ? dueDateStr : "");
                    allAssignments.add(map);
                }
            } catch (Exception e) {
                System.err.println("[ERROR] Failed to fetch assignments for search: " + e.getMessage());
                e.printStackTrace();
            }

            // 1. Custom Linear Search for Assignments
            List<Map<String, Object>> filteredAssignments = SearchAndSortUtil.linearSearch(allAssignments, a -> {
                String title = (String) a.get("title");
                return title != null && title.toLowerCase().contains(qLower);
            });

            // 2. Custom Merge Sort for Assignments (Order by due_date ASC)
            SearchAndSortUtil.mergeSort(filteredAssignments, (a1, a2) -> {
                String d1 = (String) a1.get("due_date_str");
                String d2 = (String) a2.get("due_date_str");
                return d1.compareTo(d2); // Ascending order
            });

            // Slice Assignments to 25 max
            List<Map<String, Object>> assignmentsSlice = filteredAssignments.subList(0, Math.min(filteredAssignments.size(), 25));

            // Combine both slices
            results.addAll(resourcesSlice);
            results.addAll(assignmentsSlice);
        }

        req.setAttribute("results", results);
        req.getRequestDispatcher("/WEB-INF/pages/searchResults.jsp").forward(req, resp);
    }
}
