package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;
import com.edustand.util.PasswordUtil;

/**
 * LoginService handles the database interactions required to authenticate a
 * user.
 */
public class LoginService {

    /**
     * Authenticates a user based on their email and plain-text password.
     * * @param email The email entered in the login form.
     * 
     * @param plainTextPassword The raw password entered in the login form.
     * @return A populated UserModel if login is successful, or null if it fails.
     */
    public UserModel authenticateUser(String email, String plainTextPassword) {
        if (email == null || email.isBlank() || plainTextPassword == null || plainTextPassword.isBlank()) {
            return null;
        }

        // First query: Get user by email (regardless of status) to check if email
        // exists
        String queryAny = "SELECT * FROM Users WHERE email = ?";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(queryAny)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // User exists, check status
                    String userStatus = rs.getString("status");
                    String storedHash = rs.getString("password_hash");

                    // Check password first
                    boolean isPasswordValid = false;
                    try {
                        isPasswordValid = PasswordUtil.checkPassword(plainTextPassword, storedHash);
                    } catch (IllegalArgumentException invalidHash) {
                        isPasswordValid = plainTextPassword.equals(storedHash);
                    }

                    if (!isPasswordValid) {
                        // Wrong password, return null
                        return null;
                    }

                    // Password is correct, now check status
                    if (!"ACTIVE".equals(userStatus)) {
                        // Account is inactive or pending, return null and let controller handle it
                        // Store status in a way controller can check
                        return null;
                    }

                    // Password is valid and user is ACTIVE, return the user
                    if (!isBcryptHash(storedHash)) {
                        upgradePasswordHash(conn, rs.getInt("user_id"), plainTextPassword);
                    }

                    UserModel user = new UserModel();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));

                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error during authentication: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Checks if a user account is inactive. Useful for providing better error
     * messages.
     */
    public boolean isUserInactive(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }

        String query = "SELECT status FROM Users WHERE email = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    return "INACTIVE".equals(status);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error checking user status: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private void upgradePasswordHash(Connection conn, int userId, String plainTextPassword) {
        String updateQuery = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        String upgradedHash = PasswordUtil.hashPassword(plainTextPassword);

        try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
            updateStmt.setString(1, upgradedHash);
            updateStmt.setInt(2, userId);
            updateStmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Password hash upgrade failed for user_id " + userId + ": " + e.getMessage());
        }
    }

    private boolean isBcryptHash(String value) {
        if (value == null) {
            return false;
        }
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }
}