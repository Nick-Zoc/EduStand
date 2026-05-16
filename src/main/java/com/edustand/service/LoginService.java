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
import com.edustand.util.PasswordUtil;

/**
 * LoginService handles user authentication, password verification,
 * and account lockout after 5 consecutive failed login attempts.
 */
public class LoginService {

    /** Maximum failed attempts before the account is locked. */
    private static final int MAX_FAILED_ATTEMPTS = 5;

    /** Lock duration in minutes. */
    private static final int LOCKOUT_MINUTES = 30;

    /**
     * Outcome of an authentication attempt. Callers check this to
     * produce the correct user-facing error message.
     */
    public enum LoginResult {
        SUCCESS,
        USER_NOT_FOUND,
        WRONG_PASSWORD,
        ACCOUNT_LOCKED,
        ACCOUNT_INACTIVE,
        ERROR
    }

    /** Holds the result of a login attempt plus the authenticated user (if success). */
    public static class AuthResult {
        public final LoginResult status;
        public final UserModel user;
        /** Remaining attempts before lockout (only when status == WRONG_PASSWORD). */
        public final int remainingAttempts;
        /** When lock expires (only when status == ACCOUNT_LOCKED). */
        public final Timestamp lockedUntil;

        public AuthResult(LoginResult status, UserModel user, int remainingAttempts, Timestamp lockedUntil) {
            this.status = status;
            this.user = user;
            this.remainingAttempts = remainingAttempts;
            this.lockedUntil = lockedUntil;
        }
    }

    /**
     * Authenticates a user. Enforces lockout after MAX_FAILED_ATTEMPTS failures.
     *
     * @param email             The email entered in the login form.
     * @param plainTextPassword The raw password entered in the login form.
     * @return An {@link AuthResult} describing the outcome.
     */
    public AuthResult authenticate(String email, String plainTextPassword) {
        if (email == null || email.isBlank() || plainTextPassword == null || plainTextPassword.isBlank()) {
            return new AuthResult(LoginResult.USER_NOT_FOUND, null, 0, null);
        }

        String query = "SELECT * FROM Users WHERE email = ?";

        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return new AuthResult(LoginResult.USER_NOT_FOUND, null, 0, null);
                }

                // Check lockout (gracefully skip if columns don't exist yet)
                Timestamp lockedUntil = null;
                int failedAttempts = 0;
                try {
                    lockedUntil = rs.getTimestamp("locked_until");
                    failedAttempts = rs.getInt("failed_login_attempts");
                } catch (SQLException ignored) { /* schema not yet migrated */ }

                if (lockedUntil != null && lockedUntil.toInstant().isAfter(Instant.now())) {
                    return new AuthResult(LoginResult.ACCOUNT_LOCKED, null, 0, lockedUntil);
                }

                // Check password
                String storedHash = rs.getString("password_hash");
                boolean isPasswordValid = false;
                try {
                    isPasswordValid = PasswordUtil.checkPassword(plainTextPassword, storedHash);
                } catch (IllegalArgumentException invalidHash) {
                    isPasswordValid = plainTextPassword.equals(storedHash);
                }

                if (!isPasswordValid) {
                    int newFailed = failedAttempts + 1;
                    int remaining = Math.max(0, MAX_FAILED_ATTEMPTS - newFailed);
                    Timestamp newLock = newFailed >= MAX_FAILED_ATTEMPTS
                            ? Timestamp.from(Instant.now().plus(LOCKOUT_MINUTES, ChronoUnit.MINUTES))
                            : null;
                    recordFailedAttempt(conn, rs.getInt("user_id"), newFailed, newLock);
                    return new AuthResult(LoginResult.WRONG_PASSWORD, null, remaining, newLock);
                }

                // Check account status
                String userStatus = rs.getString("status");
                if (!"ACTIVE".equals(userStatus)) {
                    return new AuthResult(LoginResult.ACCOUNT_INACTIVE, null, 0, null);
                }

                // Success
                int userId = rs.getInt("user_id");
                if (!isBcryptHash(storedHash)) {
                    upgradePasswordHash(conn, userId, plainTextPassword);
                }
                resetFailedAttempts(conn, userId);

                UserModel user = new UserModel();
                user.setUserId(userId);
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(userStatus);
                try { user.setProfilePicturePath(rs.getString("profile_picture_path")); } catch (Exception ignored) {}
                try { user.setPhoneNumber(rs.getString("phone_number")); } catch (Exception ignored) {}
                try { user.setAddress(rs.getString("address")); } catch (Exception ignored) {}

                return new AuthResult(LoginResult.SUCCESS, user, 0, null);
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Database error during authentication: " + e.getMessage());
            e.printStackTrace();
            return new AuthResult(LoginResult.ERROR, null, 0, null);
        }
    }

    /**
     * Legacy method kept for backward compatibility.
     * Prefer {@link #authenticate(String, String)} in new controllers.
     */
    public UserModel authenticateUser(String email, String plainTextPassword) {
        AuthResult result = authenticate(email, plainTextPassword);
        return result.status == LoginResult.SUCCESS ? result.user : null;
    }

    /** Checks if a user account is inactive (for granular error messages). */
    public boolean isUserInactive(String email) {
        if (email == null || email.isBlank()) return false;
        String query = "SELECT status FROM Users WHERE email = ?";
        try (Connection conn = DbConfig.getDbConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return "INACTIVE".equals(rs.getString("status"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Database error checking user status: " + e.getMessage());
        }
        return false;
    }

    private void recordFailedAttempt(Connection conn, int userId, int newFailed, Timestamp lockUntil) {
        String query = "UPDATE Users SET failed_login_attempts = ?, locked_until = ? WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, newFailed);
            stmt.setTimestamp(2, lockUntil);
            stmt.setInt(3, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[WARN] recordFailedAttempt failed (run migrate_audit_columns.sql): " + e.getMessage());
        }
    }

    private void resetFailedAttempts(Connection conn, int userId) {
        String query = "UPDATE Users SET failed_login_attempts = 0, locked_until = NULL WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[WARN] resetFailedAttempts failed: " + e.getMessage());
        }
    }

    private void upgradePasswordHash(Connection conn, int userId, String plainTextPassword) {
        String query = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        String hash = PasswordUtil.hashPassword(plainTextPassword);
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hash);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[WARN] Password hash upgrade failed for user_id " + userId + ": " + e.getMessage());
        }
    }

    private boolean isBcryptHash(String value) {
        if (value == null) return false;
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }
}