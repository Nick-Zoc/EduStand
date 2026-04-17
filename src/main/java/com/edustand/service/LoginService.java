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

        // The SQL query checks for the email AND ensures the account is ACTIVE.
        // The '?' are placeholders for the PreparedStatement to fill safely.
        String query = "SELECT * FROM Users WHERE email = ? AND status = 'ACTIVE'";

        // Using 'try-with-resources' ensures the Connection, Statement, and ResultSet
        // are automatically closed after we are done to prevent memory leaks.
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            // Safely inject the user's email into the first '?' in the SQL query
            stmt.setString(1, email);

            // Execute the query and store the results in the ResultSet
            try (ResultSet rs = stmt.executeQuery()) {

                // rs.next() moves the cursor to the first row.
                // If it returns true, we found an account with that email.
                if (rs.next()) {
                    // Grab the hashed password from the database row
                    String storedHash = rs.getString("password_hash");

                    boolean isPasswordValid = false;

                    // Primary path: BCrypt hash verification
                    try {
                        isPasswordValid = PasswordUtil.checkPassword(plainTextPassword, storedHash);
                    } catch (IllegalArgumentException invalidHash) {
                        // Legacy path: plain text password present in DB
                        isPasswordValid = plainTextPassword.equals(storedHash);
                    }

                    if (isPasswordValid) {
                        // If the stored value is plain text, upgrade it to BCrypt after successful
                        // login.
                        if (!isBcryptHash(storedHash)) {
                            upgradePasswordHash(conn, rs.getInt("user_id"), plainTextPassword);
                        }

                        // Passwords match! Build a UserModel object to return to the Controller
                        UserModel user = new UserModel();
                        user.setUserId(rs.getInt("user_id"));
                        user.setFullName(rs.getString("full_name"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setStatus(rs.getString("status"));
                        // Note: We intentionally do NOT set the passwordHash into the model we pass
                        // around the app for security reasons.

                        return user;
                    }
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            // If the database crashes or the credentials are bad, print the error to the
            // console
            System.err.println("Database error during authentication: " + e.getMessage());
            e.printStackTrace();
        }

        // If we reach here, the email wasn't found, the password didn't match, or the
        // DB crashed.
        return null;
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