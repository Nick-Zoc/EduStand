package com.edustand.service;

import java.sql.*;
import com.edustand.config.DbConfig;

public class NoticeService {

    /** Creates a new notice. @return generated notice_id or -1 on failure. */
    public int createNotice(int authorId, String title, String body,
                             String attachmentPath, String attachmentName,
                             String startDate, String endDate) {
        String query = "INSERT INTO Notices (author_id, title, body, attachment_path, attachment_name, start_date, end_date) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, authorId);
            stmt.setString(2, title);
            stmt.setString(3, body);
            stmt.setString(4, attachmentPath);
            stmt.setString(5, attachmentName);
            stmt.setString(6, startDate);
            stmt.setString(7, endDate);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    /**
     * Updates a notice. lastEditedBy is the user_id of the editor.
     * @return true on success.
     */
    public boolean updateNotice(int noticeId, String title, String body,
                                 String startDate, String endDate, int lastEditedBy) {
        String query = "UPDATE Notices SET title=?, body=?, start_date=?, end_date=?, last_edited_by=? WHERE notice_id=?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, title);
            stmt.setString(2, body);
            stmt.setString(3, startDate);
            stmt.setString(4, endDate);
            stmt.setInt(5, lastEditedBy);
            stmt.setInt(6, noticeId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Counts notices by status: ACTIVE, UPCOMING, EXPIRED
     */
    public int countNoticesByStatus(String status) {
        String query;
        if ("ACTIVE".equalsIgnoreCase(status)) {
            query = "SELECT COUNT(*) FROM Notices WHERE CURDATE() BETWEEN start_date AND end_date";
        } else if ("UPCOMING".equalsIgnoreCase(status)) {
            query = "SELECT COUNT(*) FROM Notices WHERE start_date > CURDATE()";
        } else {
            query = "SELECT COUNT(*) FROM Notices WHERE end_date < CURDATE()";
        }

        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** Deletes a notice by ID. */
    public boolean deleteNotice(int noticeId) {
        String query = "DELETE FROM Notices WHERE notice_id=?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, noticeId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Checks ownership: returns true if given userId is the author of the notice.
     */
    public boolean isAuthor(int noticeId, int userId) {
        String query = "SELECT author_id FROM Notices WHERE notice_id=?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, noticeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("author_id") == userId;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /** Returns the 5 most recent active notices as JSON. */
    public String getRecentNoticesAsJson(int limit) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT n.*, u.full_name AS author_name, "
                + "e.full_name AS editor_name "
                + "FROM Notices n "
                + "JOIN Users u ON n.author_id = u.user_id "
                + "LEFT JOIN Users e ON n.last_edited_by = e.user_id "
                + "WHERE CURDATE() BETWEEN n.start_date AND n.end_date "
                + "ORDER BY n.created_at DESC LIMIT ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append(buildNoticeJson(rs));
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    /** Returns all notices (admin: everyone's; teacher: only theirs). Newest first. */
    public String getAllNoticesAsJson() {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT n.*, u.full_name AS author_name, "
                + "e.full_name AS editor_name "
                + "FROM Notices n "
                + "JOIN Users u ON n.author_id = u.user_id "
                + "LEFT JOIN Users e ON n.last_edited_by = e.user_id "
                + "ORDER BY n.created_at DESC";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append(buildNoticeJson(rs));
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    /** Returns notices authored by a specific user. */
    public String getNoticesByAuthorAsJson(int authorId) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT n.*, u.full_name AS author_name, "
                + "e.full_name AS editor_name "
                + "FROM Notices n "
                + "JOIN Users u ON n.author_id = u.user_id "
                + "LEFT JOIN Users e ON n.last_edited_by = e.user_id "
                + "WHERE n.author_id = ? "
                + "ORDER BY n.created_at DESC";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, authorId);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append(buildNoticeJson(rs));
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    /**
     * Returns login counts grouped by date for the activity chart.
     * @param days number of past days (e.g. 7 for last week)
     * @return JSON: [{date:'May 01', count:5}, ...]
     */
    public String getLoginCountsAsJson(int days) {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT DATE(created_at) as log_date, COUNT(*) as cnt "
                + "FROM ActivityLogs "
                + "WHERE action='LOGIN' AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) "
                + "GROUP BY DATE(created_at) ORDER BY log_date ASC";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append("{\"date\":\"").append(escapeJson(rs.getString("log_date")))
                        .append("\",\"count\":").append(rs.getInt("cnt")).append("}");
                    first = false;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }

    private String buildNoticeJson(ResultSet rs) throws SQLException {
        String attachPath = rs.getString("attachment_path");
        String attachName = rs.getString("attachment_name");
        String editorName = rs.getString("editor_name");
        Timestamp updatedAt = null;
        try { updatedAt = rs.getTimestamp("updated_at"); } catch (Exception ignored) {}
        return "{"
                + "\"id\":" + rs.getInt("notice_id") + ","
                + "\"title\":\"" + escapeJson(rs.getString("title")) + "\","
                + "\"body\":\"" + escapeJson(rs.getString("body")) + "\","
                + "\"author\":\"" + escapeJson(rs.getString("author_name")) + "\","
                + "\"authorId\":" + rs.getInt("author_id") + ","
                + "\"startDate\":\"" + rs.getString("start_date") + "\","
                + "\"endDate\":\"" + rs.getString("end_date") + "\","
                + "\"createdAt\":\"" + rs.getString("created_at") + "\","
                + "\"updatedAt\":\"" + (updatedAt != null ? updatedAt.toString().substring(0,19) : "") + "\","
                + "\"lastEditedBy\":\"" + escapeJson(editorName != null ? editorName : "") + "\","
                + "\"attachmentPath\":\"" + (attachPath != null ? escapeJson(attachPath) : "") + "\","
                + "\"attachmentName\":\"" + (attachName != null ? escapeJson(attachName) : "") + "\""
                + "}";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
