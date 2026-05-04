package com.edustand.service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.edustand.config.DbConfig;

public class ResourceService {
    public boolean addResource(int uploaderId, String title, String desc, String filePath, String type, String category) {
        String query = "INSERT INTO Resources (uploader_id, title, description, file_path, file_type, category) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, uploaderId);
            stmt.setString(2, title);
            stmt.setString(3, desc);
            stmt.setString(4, filePath);
            stmt.setString(5, type);
            stmt.setString(6, category);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Fetches all resources. If we want folder view, we group by 'category' in JS.
    public String getAllResourcesAsJson() {
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT * FROM Resources ORDER BY upload_date DESC";
        try (Connection conn = DbConfig.getDbConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{")
                    .append("\"id\":").append(rs.getInt("resource_id")).append(",")
                    .append("\"title\":\"").append(rs.getString("title")).append("\",")
                    .append("\"path\":\"").append(rs.getString("file_path")).append("\",")
                    .append("\"type\":\"").append(rs.getString("file_type")).append("\",")
                    .append("\"folder\":\"").append(rs.getString("category")).append("\",")
                    .append("\"date\":\"").append(rs.getTimestamp("upload_date").toString()).append("\"")
                    .append("}");
                first = false;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return json.append("]").toString();
    }
}