package com.edustand.model;

import java.sql.Timestamp;

/**
 * UserModel represents a user entity in the system.
 * It encapsulates user data and provides getters and setters.
 */

/**
 * Default empty constructor
 */
public class UserModel {

    // Private variables mapping exactly to the database schema
    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role; // 'ADMIN', 'TEACHER', 'STUDENT'
    private String status; // 'ACTIVE', 'INACTIVE'
    private String requestReason;
    private Timestamp createdAt;

    /**
     * Default empty constructor (Required for JavaBean standard)
     */
    public UserModel() {
    }

    /**
     * Parameterized constructor for registering a new user (does not inclide ID and
     * createdAt
     * since the database auto-generates those).
     */
    public UserModel(String fullName, String email, String passwordHash, String role, String status) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.status = status;
    }

    // GETTERS AND SETTERS for encapsulation

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRequestReason() {
        return requestReason;
    }

    public void setRequestReason(String requestReason) {
        this.requestReason = requestReason;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}