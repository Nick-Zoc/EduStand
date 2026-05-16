-- =====================================================
-- EduStand DB Migration: Add audit columns + lockout
-- Run this on existing databases to add new columns.
-- Safe to run if columns already exist (IF NOT EXISTS).
-- =====================================================

-- 1. Users: add updated_at, created_by, and lockout columns
ALTER TABLE Users
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS created_by INT NULL,
    ADD COLUMN IF NOT EXISTS failed_login_attempts INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS locked_until TIMESTAMP NULL;

-- 2. Notices: add last_edited_by and updated_at columns
ALTER TABLE Notices
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS last_edited_by INT NULL;

-- 3. ContactRequests: add updated_by column
ALTER TABLE ContactRequests
    ADD COLUMN IF NOT EXISTS updated_by INT NULL;

-- 4. Password Reset OTPs table
CREATE TABLE IF NOT EXISTS PasswordResetOTPs (
    otp_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

