package com.edustand.service;

import com.edustand.config.DbConfig;
import java.sql.Connection;
import com.edustand.model.ActivityLogModel;
import java.sql.*;
import java.util.*;

public class ActivityLogService {
    public boolean logActivity(int userId, String action, String description) {
        String sql = "INSERT INTO ActivityLogs (user_id, action, description) VALUES (?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, action);
            stmt.setString(3, description);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error logging activity: " + e.getMessage());
            return false;
        }
    }

    public List<ActivityLogModel> getAllLogs() {
        String sql = "SELECT l.log_id, l.user_id, u.full_name, u.email, l.action, l.description, l.created_at " +
                "FROM ActivityLogs l " +
                "JOIN Users u ON l.user_id = u.user_id " +
                "ORDER BY l.created_at DESC";
        List<ActivityLogModel> logs = new ArrayList<>();
        try (Connection conn = DbConfig.getDbConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                logs.add(mapLog(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching activity logs: " + e.getMessage());
        }
        return logs;
    }

    public List<ActivityLogModel> getLogsByAction(String action) {
        String sql = "SELECT l.log_id, l.user_id, u.full_name, u.email, l.action, l.description, l.created_at " +
                "FROM ActivityLogs l " +
                "JOIN Users u ON l.user_id = u.user_id " +
                "WHERE l.action = ? " +
                "ORDER BY l.created_at DESC";
        List<ActivityLogModel> logs = new ArrayList<>();
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, action);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapLog(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching activity logs by action: " + e.getMessage());
        }
        return logs;
    }

    public List<ActivityLogModel> getLogsByUser(int userId) {
        String sql = "SELECT l.log_id, l.user_id, u.full_name, u.email, l.action, l.description, l.created_at " +
                "FROM ActivityLogs l " +
                "JOIN Users u ON l.user_id = u.user_id " +
                "WHERE l.user_id = ? " +
                "ORDER BY l.created_at DESC";
        List<ActivityLogModel> logs = new ArrayList<>();
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapLog(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching activity logs by user: " + e.getMessage());
        }
        return logs;
    }

    public List<ActivityLogModel> getRecentLogs(int limit) {
        String sql = "SELECT l.log_id, l.user_id, u.full_name, u.email, l.action, l.description, l.created_at " +
                "FROM ActivityLogs l " +
                "JOIN Users u ON l.user_id = u.user_id " +
                "ORDER BY l.created_at DESC LIMIT ?";
        List<ActivityLogModel> logs = new ArrayList<>();
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapLog(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching recent activity logs: " + e.getMessage());
        }
        return logs;
    }

    public int countLogs() {
        String sql = "SELECT COUNT(*) as count FROM ActivityLogs";
        try (Connection conn = DbConfig.getDbConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error counting activity logs: " + e.getMessage());
        }
        return 0;
    }

    private ActivityLogModel mapLog(ResultSet rs) throws SQLException {
        ActivityLogModel log = new ActivityLogModel();
        log.setLogId(rs.getInt("log_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setUserName(rs.getString("full_name"));
        log.setUserEmail(rs.getString("email"));
        log.setAction(rs.getString("action"));
        log.setDescription(rs.getString("description"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }
}
