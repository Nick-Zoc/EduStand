package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.edustand.config.DbConfig;
import com.edustand.model.ContactRequestModel;

public class ContactRequestService {

    public boolean createRequest(ContactRequestModel request) {
        String query = "INSERT INTO ContactRequests (user_id, full_name, email, subject, message, read_status, request_status) VALUES (?, ?, ?, ?, ?, 'UNREAD', 'PENDING')";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            if (request.getUserId() == null) {
                stmt.setNull(1, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(1, request.getUserId());
            }
            stmt.setString(2, request.getFullName());
            stmt.setString(3, request.getEmail());
            stmt.setString(4, request.getSubject());
            stmt.setString(5, request.getMessage());
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while creating contact request: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<ContactRequestModel> getAllRequests() {
        String query = "SELECT request_id, user_id, full_name, email, subject, message, read_status, request_status, admin_response, email_notified, created_at, updated_at FROM ContactRequests ORDER BY created_at DESC";
        List<ContactRequestModel> requests = new ArrayList<>();

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                requests.add(mapRequest(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while fetching contact requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    public int countByReadStatus(String readStatus) {
        String query = "SELECT COUNT(*) AS count FROM ContactRequests WHERE read_status = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, readStatus);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while counting contact requests: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateRequest(int requestId, String readStatus, String requestStatus, String adminResponse,
            boolean emailNotified) {
        String query = "UPDATE ContactRequests SET read_status = ?, request_status = ?, admin_response = ?, email_notified = ?, updated_at = CURRENT_TIMESTAMP WHERE request_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, readStatus);
            stmt.setString(2, requestStatus);
            stmt.setString(3, adminResponse == null ? "" : adminResponse);
            stmt.setBoolean(4, emailNotified);
            stmt.setInt(5, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while updating contact request: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public ContactRequestModel findById(int requestId) {
        String query = "SELECT request_id, user_id, full_name, email, subject, message, read_status, request_status, admin_response, email_notified, created_at, updated_at FROM ContactRequests WHERE request_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRequest(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while finding contact request: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private ContactRequestModel mapRequest(ResultSet rs) throws SQLException {
        ContactRequestModel request = new ContactRequestModel();
        request.setRequestId(rs.getInt("request_id"));
        int uid = rs.getInt("user_id");
        request.setUserId(rs.wasNull() ? null : uid);
        request.setFullName(rs.getString("full_name"));
        request.setEmail(rs.getString("email"));
        request.setSubject(rs.getString("subject"));
        request.setMessage(rs.getString("message"));
        request.setReadStatus(rs.getString("read_status"));
        request.setRequestStatus(rs.getString("request_status"));
        request.setAdminResponse(rs.getString("admin_response"));
        request.setEmailNotified(rs.getBoolean("email_notified"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setUpdatedAt(rs.getTimestamp("updated_at"));
        return request;
    }
}
