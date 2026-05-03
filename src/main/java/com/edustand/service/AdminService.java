package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;

/**
 * AdminService handles database operations restricted to the Admin role,
 * such as creating, updating, or deleting users.
 */
public class AdminService {
    /**
     * Inserts a new user into the database.
     * * @param user The UserModel containing the new user's data.
     * 
     * @return boolean true if the insertion was successful, false otherwise.
     */
    public boolean addUser(UserModel user) {
        // The SQL INSERT query. We leave user_id and created_at out because
        // MySQL will auto-generate them for us.
        String queryWithReason = "INSERT INTO Users (full_name, email, password_hash, role, status, request_reason) VALUES (?, ?, ?, ?, ?, ?)";
        String queryWithoutReason = "INSERT INTO Users (full_name, email, password_hash, role, status) VALUES (?, ?, ?, ?, ?)";

        // Try-with-resources safely manages the database connection
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(queryWithReason, Statement.RETURN_GENERATED_KEYS)) {

            // Safely bind the data from the UserModel into the SQL query's '?' placeholders
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getStatus());

            // executeUpdate() returns the number of rows affected.
            // If it's greater than 0, our user was successfully added!
            stmt.setString(6, user.getRequestReason());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            if (e instanceof SQLException && e.getMessage() != null
                    && e.getMessage().toLowerCase().contains("request_reason")) {
                try (Connection conn = DbConfig.getDbConnection();
                        PreparedStatement stmt = conn.prepareStatement(queryWithoutReason,
                                Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, user.getFullName());
                    stmt.setString(2, user.getEmail());
                    stmt.setString(3, user.getPasswordHash());
                    stmt.setString(4, user.getRole());
                    stmt.setString(5, user.getStatus());
                    return stmt.executeUpdate() > 0;
                } catch (SQLException | ClassNotFoundException retryError) {
                    System.err.println("Database error while adding user: " + retryError.getMessage());
                    retryError.printStackTrace();
                }
                return false;
            }
            System.err.println("Database error while adding user: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public List<UserModel> getAllUsers() {
        String query = "SELECT user_id, full_name, email, role, status, created_at FROM Users ORDER BY created_at DESC";
        List<UserModel> users = new ArrayList<>();

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }
            System.out.println("[DEBUG] getAllUsers returned " + users.size() + " users");
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("[ERROR] Database error while fetching users: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    public List<UserModel> getPendingUsers() {
        String queryWithReason = "SELECT user_id, full_name, email, role, status, request_reason, created_at FROM Users WHERE status = 'PENDING' ORDER BY created_at DESC";
        String queryWithoutReason = "SELECT user_id, full_name, email, role, status, NULL AS request_reason, created_at FROM Users WHERE status = 'PENDING' ORDER BY created_at DESC";
        List<UserModel> users = new ArrayList<>();

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(queryWithReason);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            if (isMissingRequestReasonColumn(e)) {
                try (Connection conn = DbConfig.getDbConnection();
                        PreparedStatement stmt = conn.prepareStatement(queryWithoutReason);
                        ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        users.add(mapUser(rs));
                    }
                    return users;
                } catch (SQLException | ClassNotFoundException retryError) {
                    System.err.println("Database error while fetching pending users: " + retryError.getMessage());
                    retryError.printStackTrace();
                }
                return users;
            }
            System.err.println("Database error while fetching pending users: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    public int countUsersByRole(String role) {
        String query = "SELECT COUNT(*) AS count FROM Users WHERE role = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while counting users by role: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countUsersByStatus(String status) {
        String query = "SELECT COUNT(*) AS count FROM Users WHERE status = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while counting users by status: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countAllUsers() {
        String query = "SELECT COUNT(*) AS count FROM Users";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while counting all users: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public UserModel findUserById(int userId) {
        String queryWithReason = "SELECT user_id, full_name, email, role, status, request_reason, created_at FROM Users WHERE user_id = ?";
        String queryWithoutReason = "SELECT user_id, full_name, email, role, status, NULL AS request_reason, created_at FROM Users WHERE user_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(queryWithReason)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            if (isMissingRequestReasonColumn(e)) {
                try (Connection conn = DbConfig.getDbConnection();
                        PreparedStatement stmt = conn.prepareStatement(queryWithoutReason)) {
                    stmt.setInt(1, userId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            return mapUser(rs);
                        }
                    }
                } catch (SQLException | ClassNotFoundException retryError) {
                    System.err.println("Database error while finding user by id: " + retryError.getMessage());
                    retryError.printStackTrace();
                }
                return null;
            }
            System.err.println("Database error while finding user by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public UserModel findUserByEmail(String email) {
        String queryWithReason = "SELECT user_id, full_name, email, role, status, request_reason, created_at FROM Users WHERE email = ?";
        String queryWithoutReason = "SELECT user_id, full_name, email, role, status, NULL AS request_reason, created_at FROM Users WHERE email = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(queryWithReason)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            if (isMissingRequestReasonColumn(e)) {
                try (Connection conn = DbConfig.getDbConnection();
                        PreparedStatement stmt = conn.prepareStatement(queryWithoutReason)) {
                    stmt.setString(1, email);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            return mapUser(rs);
                        }
                    }
                } catch (SQLException | ClassNotFoundException retryError) {
                    System.err.println("Database error while finding user by email: " + retryError.getMessage());
                    retryError.printStackTrace();
                }
                return null;
            }
            System.err.println("Database error while finding user by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<UserModel> getRecentUsers(int limit) {
        String query = "SELECT user_id, full_name, email, role, status, created_at FROM Users ORDER BY created_at DESC LIMIT ?";
        List<UserModel> users = new ArrayList<>();

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, Math.max(1, limit));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while fetching recent users: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    private boolean isMissingRequestReasonColumn(Exception e) {
        if (!(e instanceof SQLException) || e.getMessage() == null) {
            return false;
        }
        return e.getMessage().toLowerCase().contains("request_reason");
    }

    public boolean emailExistsForOtherUser(String email, int userId) {
        String query = "SELECT 1 FROM Users WHERE email = ? AND user_id <> ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while checking duplicate email: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(UserModel user, String optionalHashedPassword) {
        String queryWithPassword = "UPDATE Users SET full_name = ?, email = ?, role = ?, status = ?, password_hash = ? WHERE user_id = ?";
        String queryWithoutPassword = "UPDATE Users SET full_name = ?, email = ?, role = ?, status = ? WHERE user_id = ?";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn
                        .prepareStatement(optionalHashedPassword == null ? queryWithoutPassword : queryWithPassword)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getStatus());

            if (optionalHashedPassword == null) {
                stmt.setInt(5, user.getUserId());
            } else {
                stmt.setString(5, optionalHashedPassword);
                stmt.setInt(6, user.getUserId());
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while updating user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(int userId, String status) {
        String query = "UPDATE Users SET status = ? WHERE user_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while updating user status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM Users WHERE user_id = ?";
        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            boolean deleted = stmt.executeUpdate() > 0;
            return deleted;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private UserModel mapUser(ResultSet rs) throws SQLException {
        UserModel user = new UserModel();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        try {
            user.setRequestReason(rs.getString("request_reason"));
        } catch (Exception e) {
            // If the column doesn't exist (older DB), leave null
        }
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}