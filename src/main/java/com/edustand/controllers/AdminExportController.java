package com.edustand.controllers;

import java.io.*;
import java.sql.*;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * AdminExportController — CSV export for admin data.
 *
 * GET /AdminExport?type=users      → exports Users table
 * GET /AdminExport?type=logs       → exports ActivityLogs table
 * GET /AdminExport?type=submissions → exports all Submissions with student names
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/AdminExport" })
public class AdminExportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserModel user = session == null ? null : (UserModel) session.getAttribute("loggedInUser");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String type = req.getParameter("type");
        if (type == null) type = "users";

        switch (type) {
            case "users":      exportUsers(resp);      break;
            case "logs":       exportLogs(resp);       break;
            case "submissions": exportSubmissions(resp); break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown export type: " + type);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Users Export                                                        */
    /* ------------------------------------------------------------------ */
    private void exportUsers(HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"edustand_users.csv\"");

        try (PrintWriter writer = resp.getWriter();
             Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT user_id, full_name, email, role, status, phone_number, address, created_at FROM Users ORDER BY user_id")) {

            writer.println("ID,Full Name,Email,Role,Status,Phone,Address,Created At");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    writer.println(
                        rs.getInt("user_id") + "," +
                        csvCell(rs.getString("full_name")) + "," +
                        csvCell(rs.getString("email")) + "," +
                        csvCell(rs.getString("role")) + "," +
                        csvCell(rs.getString("status")) + "," +
                        csvCell(rs.getString("phone_number")) + "," +
                        csvCell(rs.getString("address")) + "," +
                        csvCell(rs.getString("created_at"))
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("ERROR," + e.getMessage());
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Activity Logs Export                                                */
    /* ------------------------------------------------------------------ */
    private void exportLogs(HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"edustand_activity_logs.csv\"");

        try (PrintWriter writer = resp.getWriter();
             Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT l.log_id, u.full_name, u.email, l.action, l.description, l.created_at " +
                 "FROM ActivityLogs l JOIN Users u ON l.user_id = u.user_id ORDER BY l.created_at DESC")) {

            writer.println("Log ID,User Name,Email,Action,Description,Timestamp");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    writer.println(
                        rs.getInt("log_id") + "," +
                        csvCell(rs.getString("full_name")) + "," +
                        csvCell(rs.getString("email")) + "," +
                        csvCell(rs.getString("action")) + "," +
                        csvCell(rs.getString("description")) + "," +
                        csvCell(rs.getString("created_at"))
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("ERROR," + e.getMessage());
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Submissions Export                                                  */
    /* ------------------------------------------------------------------ */
    private void exportSubmissions(HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"edustand_submissions.csv\"");

        try (PrintWriter writer = resp.getWriter();
             Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT s.submission_id, u.full_name AS student_name, u.email AS student_email, " +
                 "a.title AS assignment_title, s.status, s.score, s.submitted_at " +
                 "FROM Submissions s " +
                 "JOIN Users u ON s.student_id = u.user_id " +
                 "JOIN Assignments a ON s.assignment_id = a.assignment_id " +
                 "ORDER BY s.submitted_at DESC")) {

            writer.println("Submission ID,Student Name,Student Email,Assignment,Status,Score,Submitted At");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object score = rs.getObject("score");
                    writer.println(
                        rs.getInt("submission_id") + "," +
                        csvCell(rs.getString("student_name")) + "," +
                        csvCell(rs.getString("student_email")) + "," +
                        csvCell(rs.getString("assignment_title")) + "," +
                        csvCell(rs.getString("status")) + "," +
                        (score != null ? score.toString() : "") + "," +
                        csvCell(rs.getString("submitted_at"))
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("ERROR," + e.getMessage());
        }
    }

    /**
     * Wraps a cell value in quotes and escapes internal quotes for safe CSV output.
     */
    private String csvCell(String value) {
        if (value == null) return "";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}
