package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import com.edustand.config.DbConfig;
import com.edustand.util.PasswordUtil;

/**
 * Handles password reset OTP generation, verification, and email sending via
 * Jakarta Mail.
 */
public class ForgotPasswordService {

    // Dynamic SMTP Configurations (fallback to console if it fails)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "naitikjoshi888@gmail.com";
    private static final String SMTP_PASS = "ooet mnhj rwtu aqfn";

    /**
     * Generates a 6-digit OTP, stores it in the DB, and emails it.
     * Returns the OTP code if successfully processed (even if SMTP fell back to
     * console).
     * Returns null if user is not found.
     */
    public String sendOtp(String email) {
        if (email == null || email.isBlank())
            return null;

        // 1. Verify user exists
        int userId = getUserIdByEmail(email);
        if (userId == -1) {
            System.out.println("[INFO] Password reset requested for non-existent email: " + email);
            return null;
        }

        // 2. Generate 6-digit OTP
        String otp = String.format("%06d", new Random().nextInt(1000000));
        Timestamp expiresAt = Timestamp.from(Instant.now().plus(2, ChronoUnit.MINUTES));

        // 3. Store OTP in DB
        String insertQuery = "INSERT INTO PasswordResetOTPs (user_id, otp_code, expires_at, used) VALUES (?, ?, ?, false)";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
            stmt.setInt(1, userId);
            stmt.setString(2, otp);
            stmt.setTimestamp(3, expiresAt);
            stmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to save OTP to database: " + e.getMessage());
            return null;
        }

        // 4. Send Email using Jakarta Mail
        boolean emailSent = sendEmail(email, otp);
        if (!emailSent) {
            System.out.println("\n=================================================");
            System.out.println("[SMTP OFFLINE] PASSWORD RESET OTP FOR " + email + ": " + otp);
            System.out.println("=================================================\n");
        }

        return otp;
    }

    /**
     * Verifies the OTP code for the given email.
     */
    public boolean verifyOtp(String email, String otp) {
        if (email == null || email.isBlank() || otp == null || otp.isBlank())
            return false;

        int userId = getUserIdByEmail(email);
        if (userId == -1)
            return false;

        String selectQuery = "SELECT * FROM PasswordResetOTPs "
                + "WHERE user_id = ? AND otp_code = ? AND used = false AND expires_at > ? "
                + "ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(selectQuery)) {
            stmt.setInt(1, userId);
            stmt.setString(2, otp);
            stmt.setTimestamp(3, Timestamp.from(Instant.now()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int otpId = rs.getInt("otp_id");
                    // Mark as used
                    markOtpAsUsed(otpId);
                    return true;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to verify OTP: " + e.getMessage());
        }
        return false;
    }

    /**
     * Resets the user's password, hashes it using BCrypt, and unlocks the account.
     */
    public boolean resetPassword(String email, String newPassword) {
        if (email == null || email.isBlank() || newPassword == null || newPassword.isBlank())
            return false;

        int userId = getUserIdByEmail(email);
        if (userId == -1)
            return false;

        String passwordHash = PasswordUtil.hashPassword(newPassword);

        // Also resets failed login attempts and unlocks account!
        String updateQuery = "UPDATE Users SET password_hash = ?, failed_login_attempts = 0, locked_until = NULL WHERE user_id = ?";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, passwordHash);
            stmt.setInt(2, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Failed to reset password: " + e.getMessage());
        }
        return false;
    }

    private int getUserIdByEmail(String email) {
        String query = "SELECT user_id FROM Users WHERE email = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("user_id");
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] getUserIdByEmail failed: " + e.getMessage());
        }
        return -1;
    }

    private void markOtpAsUsed(int otpId) {
        String query = "UPDATE PasswordResetOTPs SET used = true WHERE otp_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, otpId);
            stmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[WARN] Failed to mark OTP as used: " + e.getMessage());
        }
    }

    private boolean sendEmail(String toEmail, String otp) {
        Properties prop = new Properties();
        prop.put("mail.smtp.host", SMTP_HOST);
        prop.put("mail.smtp.port", SMTP_PORT);
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.timeout", "3000"); // short timeout so it doesn't hang the app if offline
        prop.put("mail.smtp.connectiontimeout", "3000");

        Session session = Session.getInstance(prop, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("EduStand - Password Reset Verification Code");

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                    + "<div style='text-align: center; margin-bottom: 20px;'>"
                    + "<h2 style='color: #007fff; margin: 0;'>EduStand Verification Code</h2>"
                    + "</div>"
                    + "<p>Hi there,</p>"
                    + "<p>You requested a password reset for your EduStand account. Use the 6-digit verification code below to reset your password. This code will expire in 2 minutes.</p>"
                    + "<div style='background-color: #f5f9ff; border: 1px dashed #007fff; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #007fff; margin: 20px 0; border-radius: 4px;'>"
                    + otp
                    + "</div>"
                    + "<p style='color: #666; font-size: 12px;'>If you did not request this, you can safely ignore this email.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("[SUCCESS] Password reset OTP sent to " + toEmail);
            return true;
        } catch (MessagingException e) {
            System.err.println("[WARN] SMTP Send failed: " + e.getMessage() + ". Falling back to console output.");
            return false;
        }
    }
}
