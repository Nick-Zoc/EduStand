package com.edustand.service;

import java.sql.*;
import com.edustand.config.DbConfig;

public class AssignmentService {
    public boolean addAssignment(int teacherId, String title, String instructions, String dueDate) {
        String query = "INSERT INTO Assignments (teacher_id, title, instructions, due_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, teacherId);
            stmt.setString(2, title);
            stmt.setString(3, instructions);
            stmt.setString(4, dueDate);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean submitAssignment(int assignmentId, int studentId, String filePath) {
        String query = "INSERT INTO Submissions (assignment_id, student_id, file_path, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, assignmentId);
            stmt.setInt(2, studentId);
            stmt.setString(3, filePath);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public String getAllAssignmentsAsJson(int studentId) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT a.*, (SELECT status FROM Submissions s WHERE s.assignment_id = a.assignment_id AND s.student_id = ?) AS student_status FROM Assignments a ORDER BY a.due_date ASC";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(rs.getInt("assignment_id")).append(",")
                        .append("\"title\":\"").append(rs.getString("title")).append("\",")
                        .append("\"desc\":\"").append(rs.getString("instructions")).append("\",")
                        .append("\"due\":\"").append(rs.getString("due_date")).append("\",")
                        .append("\"status\":\"").append(rs.getString("student_status") != null ? rs.getString("student_status") : "UNSUBMITTED").append("\"")
                        .append("}");
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    public String getSubmissionsAsJson(int assignmentId) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT s.*, u.full_name FROM Submissions s JOIN Users u ON s.student_id = u.user_id WHERE s.assignment_id = ?";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    Object scoreObj = rs.getObject("score");
                    json.append("{")
                        .append("\"submissionId\":").append(rs.getInt("submission_id")).append(",")
                        .append("\"name\":\"").append(rs.getString("full_name")).append("\",")
                        .append("\"status\":\"").append(rs.getString("status")).append("\",")
                        .append("\"submissionDate\":\"").append(rs.getTimestamp("submitted_at") != null ? rs.getTimestamp("submitted_at").toString() : "").append("\",")
                        .append("\"path\":\"").append(rs.getString("file_path")).append("\",")
                        .append("\"score\":").append(scoreObj != null ? scoreObj.toString() : "null")
                        .append("}");
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    /**
     * Grades a submission: sets status to GRADED and saves the score.
     * @return true on success
     */
    public boolean gradeSubmission(int submissionId, double score) {
        String query = "UPDATE Submissions SET status = 'GRADED', score = ? WHERE submission_id = ?";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDouble(1, score);
            stmt.setInt(2, submissionId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    /**
     * Returns all assignments with the student's submission status + score (if graded).
     */
    public String getStudentAssignmentsAsJson(int studentId) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT a.*, s.status AS student_status, s.score AS student_score, s.submission_id "
                + "FROM Assignments a "
                + "LEFT JOIN Submissions s ON s.assignment_id = a.assignment_id AND s.student_id = ? "
                + "ORDER BY a.due_date ASC";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    Object score = rs.getObject("student_score");
                    json.append("{")
                        .append("\"id\":").append(rs.getInt("assignment_id")).append(",")
                        .append("\"title\":\"").append(rs.getString("title")).append("\",")
                        .append("\"desc\":\"").append(rs.getString("instructions") != null ? rs.getString("instructions").replace("\"", "\\\"").replace("\n","\\n") : "").append("\",")
                        .append("\"due\":\"").append(rs.getString("due_date")).append("\",")
                        .append("\"status\":\"").append(rs.getString("student_status") != null ? rs.getString("student_status") : "UNSUBMITTED").append("\",")
                        .append("\"score\":").append(score != null ? score.toString() : "null")
                        .append("}");
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }
}