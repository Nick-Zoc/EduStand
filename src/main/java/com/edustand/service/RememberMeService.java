package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;
import com.edustand.util.RememberMeUtil;

/**
 * Service for managing Remember Me tokens and auto-login.
 */
public class RememberMeService {
    private final LoginService loginService = new LoginService();

    /**
     * Creates a remember-me token for a user (valid for 30 days).
     */
    public String createToken(int userId) {
        String token = RememberMeUtil.generateToken();
        String tokenHash = RememberMeUtil.hashToken(token);
        Instant expiryTime = Instant.now().plus(30, ChronoUnit.DAYS);

        String query = "INSERT INTO RememberMeTokens (user_id, token_hash, token_expiry) VALUES (?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setString(2, tokenHash);
            stmt.setTimestamp(3, Timestamp.from(expiryTime));
            stmt.executeUpdate();
            System.out.println("[DEBUG] Created remember-me token for user_id=" + userId);
            return token;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to create remember-me token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Validates a token and returns the associated user (if valid and not expired).
     */
    public UserModel validateToken(String token) {
        if (!RememberMeUtil.isValidToken(token)) {
            return null;
        }

        String tokenHash = RememberMeUtil.hashToken(token);
        String query = "SELECT u.* FROM Users u "
                + "JOIN RememberMeTokens t ON u.user_id = t.user_id "
                + "WHERE t.token_hash = ? AND t.token_expiry > NOW() AND u.status = 'ACTIVE'";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, tokenHash);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserModel user = new UserModel();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    System.out.println("[DEBUG] Remember-me token validated for user_id=" + user.getUserId());
                    return user;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to validate remember-me token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Deletes all tokens for a user (called on logout).
     */
    public void invalidateUserTokens(int userId) {
        String query = "DELETE FROM RememberMeTokens WHERE user_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            System.out.println("[DEBUG] Invalidated all remember-me tokens for user_id=" + userId);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to invalidate tokens: " + e.getMessage());
        }
    }
}
