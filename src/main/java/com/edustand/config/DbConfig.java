package com.edustand.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DbConfig handles the connection to the MySQL database using JDBC.
 */
public class DbConfig {
    
    // Database configuration constants
    private static final String DB_NAME = "edustand_db";

    private static final String URL = "jdbc:mysql://localhost:3306/" + DB_NAME;

    private static final String USERNAME = "root";

    private static final String PASSWORD = "";

    private static boolean initialized = false;

    /**
     * Establishes and returns a connection to the database.
     */
    public static Connection getDbConnection() throws SQLException, ClassNotFoundException {
        // Load the MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the connection using the credentials
        Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        if (!initialized) {
            initializeDatabase(conn);
        }
        return conn;
    }

    private static synchronized void initializeDatabase(Connection conn) {
        if (initialized) return;
        try (java.sql.Statement stmt = conn.createStatement()) {
            try {
                stmt.executeUpdate("ALTER TABLE Users ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE Users ADD COLUMN created_by INT NULL");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE Users ADD COLUMN failed_login_attempts INT NOT NULL DEFAULT 0");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE Users ADD COLUMN locked_until TIMESTAMP NULL");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE Notices ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE Notices ADD COLUMN last_edited_by INT NULL");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("ALTER TABLE ContactRequests ADD COLUMN updated_by INT NULL");
            } catch (SQLException e) { /* already exists */ }
            try {
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS PasswordResetOTPs (" +
                        "otp_id INT AUTO_INCREMENT PRIMARY KEY," +
                        "user_id INT NOT NULL," +
                        "otp_code VARCHAR(6) NOT NULL," +
                        "expires_at TIMESTAMP NOT NULL," +
                        "used BOOLEAN DEFAULT FALSE," +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                        "FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE" +
                        ")");
            } catch (SQLException e) { /* already exists */ }
            initialized = true;
            System.out.println("[INFO] Programmatic database migration finished successfully.");
        } catch (SQLException e) {
            System.err.println("[WARN] Database migration warning: " + e.getMessage());
        }
    }
}