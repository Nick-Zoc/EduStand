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

    /**
     * Establishes and returns a connection to the database.
     */
    public static Connection getDbConnection() throws SQLException, ClassNotFoundException {
        // Load the MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the connection using the credentials
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}