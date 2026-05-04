package com.edustand.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.edustand.config.DbConfig;
import com.edustand.model.UserModel;

public class ProfileService {

    public UserModel getProfileById(int userId) {
        String sql = "SELECT user_id, full_name, email, role, status, phone_number, address, profile_picture_path, created_at "
                + "FROM Users WHERE user_id = ?";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProfile(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while loading profile: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProfile(UserModel user) {
        String sql = "UPDATE Users SET full_name = ?, email = ?, phone_number = ?, address = ?, profile_picture_path = ? "
                + "WHERE user_id = ?";

        try (Connection conn = DbConfig.getDbConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getProfilePicturePath());
            stmt.setInt(6, user.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error while updating profile: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private UserModel mapProfile(ResultSet rs) throws SQLException {
        UserModel user = new UserModel();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setAddress(rs.getString("address"));
        user.setProfilePicturePath(rs.getString("profile_picture_path"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}